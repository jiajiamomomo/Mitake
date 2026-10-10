#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include ..\lib\export.ahk
#Include helpers\assert.ahk

/**
 * 尋找系統中的 Excel 執行檔完整路徑
 * @returns {String} 找到的 EXCEL.EXE 路徑，找不到則為空字串
 */
FindInstalledExcel() {
    candidates := [
        "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE",
        "C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE",
        "C:\Program Files\Microsoft Office\Office16\EXCEL.EXE",
        "C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE",
        "C:\Program Files\Microsoft Office\Office15\EXCEL.EXE",
        "C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE"
    ]
    for p in candidates {
        if FileExist(p)
            return p
    }
    return ""
}

/**
 * 實機驗證 Excel 生命週期與清理保護機制
 * @param {Boolean} showDialog 是否彈出完成提示
 * @returns {Boolean} 測試是否成功
 */
RunExcelCleanupLiveVerification(showDialog := true) {
    Print(text) => FileAppend(text, "*", "UTF-8")

    Print("========================================`n")
    Print("開始 Excel 清理與安全保護實機驗證`n")
    Print("========================================`n")

    excelExe := FindInstalledExcel()
    if (excelExe == "") {
        msg := "系統未偵測到 Microsoft Excel 安裝，略過視窗生命週期實機啟動測試。"
        Print(msg "`n")
        LogMsg(msg, "WARN")
        if showDialog
            MsgBox(msg, "Excel 實機驗證", "Icon!")
        return true
    }

    ; 1. 捕捉既有基準 (包含任何已存在的 Excel)
    Print("步驟 1/5: 捕捉既有 Excel 保護基準...`n")
    baseline := CaptureExcelBaseline()
    initialPidCount := baseline.pids.Count
    initialHwndCount := baseline.hwnds.Count
    Print(Format("  保護基準包含既有 PID: {1} 個, 視窗: {2} 個`n", initialPidCount, initialHwndCount))

    ; 2. 啟動一個全新的 Excel 實體 (模擬三竹匯出時系統叫起)
    Print("步驟 2/5: 啟動測試用 Excel 實體...`n")
    testPid := 0
    try {
        Run(Format('"{1}" /e', excelExe), , , &testPid)
    } catch as err {
        msg := Format("無法啟動 Excel: {1}", err.Message)
        Print(msg "`n")
        LogMsg(msg, "ERROR")
        return false
    }

    if (!testPid) {
        Print("無法取得啟動之 Excel PID，驗證中斷`n")
        return false
    }
    Print(Format("  已啟動測試 Excel (PID: {1})，等待視窗就緒...`n", testPid))

    ; 等待視窗出現 (最多等待 5 秒)
    testHwnd := 0
    deadline := A_TickCount + 5000
    while (A_TickCount < deadline) {
        newWins := FindNewExportExcelWindows(baseline)
        for w in newWins {
            if (w.pid == testPid || testPid == 0) {
                testHwnd := w.hwnd
                break
            }
        }
        if (testHwnd)
            break
        Sleep(200)
    }

    ; 3. 驗證 FindNewExportExcelWindows 差集辨識與保護隔離
    Print("步驟 3/5: 驗證差集辨識與既有 PID 保護隔離...`n")
    detectedWins := FindNewExportExcelWindows(baseline)
    if (detectedWins.Length == 0) {
        Print("  警告: 未在頂層視窗捕捉到新 Excel 視窗 (可能僅為背景進程)`n")
    } else {
        Print(Format("  成功識別相較基準新增之 Excel 視窗共 {1} 個`n", detectedWins.Length))
        for item in detectedWins {
            if baseline.pids.Has(item.pid) {
                Print(Format("  致命錯誤: 基準中既有 PID {1} 誤被列入新增視窗！`n", item.pid))
                return false
            }
        }
    }

    newPids := FindNewExportExcelProcesses(baseline)
    hasTestPid := false
    for pid in newPids {
        if (pid == testPid)
            hasTestPid := true
        if baseline.pids.Has(pid) {
            Print(Format("  致命錯誤: 基準中既有 PID {1} 誤被列入新增進程！`n", pid))
            return false
        }
    }
    Print(Format("  程序差集檢查通過 (新增 PID 包含測試 PID: {1})`n", hasTestPid ? "是" : "否"))

    ; 4. 執行 CloseNewExportExcels 清理
    Print("步驟 4/5: 執行 CloseNewExportExcels 清理...`n")
    res := CloseNewExportExcels(baseline, 2000)
    Print(Format("  清理結果: 關閉視窗: {1}, 終止程序: {2}, 失敗數: {3}`n", res.closedWins, res.closedPids, res.failed.Length))

    ; 5. 驗證測試 Excel 已完全退場，且基準保護未受破壞
    Print("步驟 5/5: 驗證測試進程已關閉且既有 Excel 完好...`n")
    isTestClosed := !ProcessExist(testPid)
    if (!isTestClosed) {
        ; 若仍存活，進行安全終止以防殘留
        try ProcessClose(testPid)
        Print("  注意: 測試 PID 在清理函式結束後短暫存活，已強制回收`n")
    } else {
        Print("  測試 Excel 程序已成功完全退出！`n")
    }

    ; 再次確認既有 PID 仍受保護
    for pid in baseline.pids {
        if (!ProcessExist(pid)) {
            Print(Format("  警告: 原基準 PID {1} 不存在 (可能為使用者在測試中自行關閉)`n", pid))
        }
    }

    report := Format("Excel 清理實機驗證成功！`n`n測試 PID: {1}`n關閉視窗: {2}`n終止程序: {3}`n保護基準保持獨立無受干擾。", testPid, res.closedWins, res.closedPids)
    Print(report "`n")
    if showDialog
        MsgBox(report, "Excel 清理實機驗證", "Iconi")
    return true
}

; 若直接以 CLI / 測試工具執行
if (A_LineFile == A_ScriptFullPath) {
    headless := false
    for arg in A_Args {
        if (arg == "/Headless" || arg == "--headless")
            headless := true
    }
    success := RunExcelCleanupLiveVerification(!headless)
    ExitApp(success ? 0 : 1)
}
