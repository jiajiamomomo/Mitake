#Requires AutoHotkey v2.0

; =============================================================================
; 匯出模組：對「熱門排行」各項目執行「資料匯出」並將 CSV 複製至專案目錄
; 三竹匯出後呼叫的關聯程式由 bypass.bat 立即結束，CSV 會留在 USER\OUT\ 目錄
; =============================================================================

/**
 * 匯出流程時序常數 (依設計共識直接寫在程式內，非 settings.ini 配置)
 */
class ExportTiming {
    static RefreshDelayMs := 1500   ; Enter 選取項目後等待資料刷新
    static DropOpenDelayMs := 300   ; 點擊下拉箭頭後等待清單展開
    static KeyHoldMs := 40          ; 自繪清單需辨識完整的按下／放開事件
    static KeyDelayMs := 60         ; 每次按鍵脈衝放開後的間隔
    static TimeoutMs := 10000       ; 輪詢匯出 CSV 之逾時
    static PollMs := 200            ; 輪詢間隔
    static MaxRetries := 2          ; 單一項目失敗後最多重試次數
}

class ExportRunState {
    static Busy := false
    static CancelRequested := false
    static Kind := ""
    static ExcelBaseline := ""
}


/**
 * 建立自繪下拉清單的鍵盤導航計畫。
 * 每個 Down 都保留為獨立脈衝，避免 SendInput 合併或三竹忽略連續快速按鍵。
 */
BuildDropdownNavPlan(itemNo, includeHome := false) {
    plan := []
    if includeHome
        plan.Push("Home")
    Loop 5
        plan.Push("PgUp")
    Loop itemNo - 1
        plan.Push("Down")
    plan.Push("Enter")
    return plan
}

SendDropdownKeyPulse(keyName) {
    SendEvent("{" keyName " down}")
    Sleep(ExportTiming.KeyHoldMs)
    SendEvent("{" keyName " up}")
    Sleep(ExportTiming.KeyDelayMs)
}

ExecuteDropdownNav(itemNo, includeHome := false) {
    plan := BuildDropdownNavPlan(itemNo, includeHome)
    for keyName in plan {
        if IsExportCancelled()
            return false
        SendDropdownKeyPulse(keyName)
    }
    return true
}

IsExportRunActive() => ExportRunState.Busy
IsExportCancelled() => ExportRunState.CancelRequested

SetExportUiEnabled(enabled) {
    for itemName in ["啟動/切換 三竹股市", "切換至 熱門排行", "切換至 盤後排行", "匯出熱門排行", "匯出盤後排行"] {
        try enabled ? A_TrayMenu.Enable(itemName) : A_TrayMenu.Disable(itemName)
    }
}

BeginExportRun(kind, showMsgBox := true) {
    if ExportRunState.Busy {
        msg := Format("無法啟動{1}：目前正在執行{2}", kind, ExportRunState.Kind)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "匯出作業進行中", "Icon!")
        return false
    }
    ExportRunState.Busy := true
    ExportRunState.CancelRequested := false
    ExportRunState.Kind := kind
    ExportRunState.ExcelBaseline := CaptureExcelBaseline()
    SetExportUiEnabled(false)
    return true
}

RequestExportCancel() {
    if !ExportRunState.Busy
        return false
    ExportRunState.CancelRequested := true
    LogMsg(Format("使用者要求中止{1}", ExportRunState.Kind), "WARN")
    return true
}

EndExportRun() {
    SetExportUiEnabled(true)
    ExportRunState.Busy := false
    ExportRunState.CancelRequested := false
    ExportRunState.Kind := ""
    ExportRunState.ExcelBaseline := ""
}

/**
 * 熱門排行匯出所需之圖檔 (須存在於 assets/{解析度}/)
 */
PopRankAssets() => ["熱門下拉.png", "資料匯出.png"]

/**
 * 取得「熱門排行」下拉清單項目總數
 * @returns {Integer} 項目總數 (settings.ini [PopularRanking] TotalItems，預設 44)
 */
GetPopRankTotalItems() {
    val := GetCfg("PopularRanking", "TotalItems", "44")
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : 44
}

/**
 * 取得三竹匯出 CSV 之輸出目錄
 * @param {String} section INI 區段名稱 (例: "PopularRanking")
 * @returns {String} 輸出目錄 (預設 D:\Program Files\MitakeGU\USER\OUT)
 */
GetExportOutDir(section) {
    return RTrim(GetCfg(section, "OutDir", "D:\Program Files\MitakeGU\USER\OUT"), "\")
}

/**
 * 取得熱門排行匯出檔之專案目的根目錄
 * @returns {String} <專案根目錄>\熱門排行
 */
GetPopRankDstRoot() {
    return GetRootDir() "\熱門排行"
}

/**
 * 取得 CSV 的修改時間、大小與內容雜湊簽章
 * @param {String} path CSV 完整路徑
 * @returns {String} 簽章，讀取失敗則回傳空字串
 */
GetCsvSignature(path) {
    try {
        raw := FileRead(path, "RAW")
        hash := 2166136261
        Loop raw.Size {
            hash := ((hash ^ NumGet(raw, A_Index - 1, "UChar")) * 16777619) & 0xFFFFFFFF
        }
        return FileGetTime(path, "M") "|" raw.Size "|" hash
    } catch {
        return ""
    }
}

CaptureCsvState(outDir) {
    state := Map()
    state.CaseSense := false
    if !DirExist(outDir)
        return state
    Loop Files, outDir "\*.csv" {
        sig := GetCsvSignature(A_LoopFileFullPath)
        if (sig != "")
            state[A_LoopFileFullPath] := sig
    }
    return state
}

/**
 * 批次前將 OUT 目錄既有 CSV 移至可復原備份，避免三竹遇到同名檔時不重新寫入。
 * @returns {Object} {outDir, stageDir, names}
 */
StageExistingCsvs(outDir, kind, backupRoot := "") {
    state := {outDir: outDir, stageDir: "", names: []}
    if !DirExist(outDir)
        return state

    existing := []
    Loop Files, outDir "\*.csv"
        existing.Push(A_LoopFileFullPath)
    if (existing.Length == 0)
        return state

    if (backupRoot == "")
        backupRoot := GetRootDir() "\logs\out-backups"
    safeKind := RegExReplace(kind, "[\\/:*?`"<>|]", "_")
    stageDir := backupRoot "\" FormatTime(A_Now, "yyyyMMdd_HHmmss") "_" safeKind "_" DllCall("GetCurrentProcessId") "_" A_TickCount
    DirCreate(stageDir)
    state.stageDir := stageDir

    try {
        for src in existing {
            SplitPath(src, &fileName)
            FileMove(src, stageDir "\" fileName)
            state.names.Push(fileName)
        }
    } catch as err {
        FinalizeCsvStage(state)
        throw Error(Format("暫存既有 CSV 失敗：{1}", err.Message))
    }

    LogMsg(Format("{1}：已暫存 OUT 目錄既有 CSV 共 {2} 個至 {3}", kind, state.names.Length, stageDir), "INFO")
    return state
}

/**
 * 批次結束後恢復未被新輸出取代的 CSV；同名舊檔保留於備份目錄。
 * @returns {Integer} 保留於備份目錄的同名舊檔數量
 */
FinalizeCsvStage(state) {
    if !IsObject(state) || state.stageDir == "" || !DirExist(state.stageDir)
        return 0

    conflicts := 0
    for fileName in state.names {
        staged := state.stageDir "\" fileName
        if !FileExist(staged)
            continue
        target := state.outDir "\" fileName
        if FileExist(target) {
            conflicts++
            continue
        }
        try FileMove(staged, target)
        catch as err {
            conflicts++
            LogMsg(Format("恢復暫存 CSV 失敗 ({1} → {2}): {3}", staged, target, err.Message), "ERROR")
        }
    }

    hasRemaining := false
    Loop Files, state.stageDir "\*.csv" {
        hasRemaining := true
        break
    }
    if !hasRemaining {
        try DirDelete(state.stageDir)
    } else {
        LogMsg(Format("同名舊 CSV 已保留於備份目錄：{1}", state.stageDir), "INFO")
    }
    return conflicts
}

/**
 * 尋找相較於基準快照新增或內容已變更的最新 CSV
 * 相容舊測試與工具傳入 YYYYMMDDHH24MISS 時間字串。
 * @param {String} outDir 輸出目錄
 * @param {Map|String} sinceOrBaseline CSV 基準快照或起始時間
 * @returns {String} CSV 完整路徑，找不到則回傳空字串
 */
FindNewCsv(outDir, sinceOrBaseline) {
    if !DirExist(outDir)
        return ""
    useBaseline := Type(sinceOrBaseline) == "Map"
    newest := "", newestTime := "", newestCreated := ""
    Loop Files, outDir "\*.csv" {
        t := A_LoopFileTimeModified
        created := A_LoopFileTimeCreated
        isCandidate := false
        if useBaseline {
            sig := GetCsvSignature(A_LoopFileFullPath)
            isCandidate := sig != "" && (!sinceOrBaseline.Has(A_LoopFileFullPath) || sinceOrBaseline[A_LoopFileFullPath] != sig)
        } else {
            isCandidate := t >= sinceOrBaseline
        }
        if (isCandidate && (newest == "" || t > newestTime || (t == newestTime && created > newestCreated))) {
            newest := A_LoopFileFullPath
            newestTime := t
            newestCreated := created
        }
    }
    return newest
}

/**
 * 判斷檔案是否已寫入完成 (可被獨佔開啟)
 * @param {String} path 檔案路徑
 * @returns {Boolean}
 */
IsFileReady(path) {
    try {
        f := FileOpen(path, "r -rwd")
        if !f
            return false
        f.Close()
        return true
    } catch {
        return false
    }
}

/**
 * 輪詢輸出目錄直到出現新的 CSV 且寫入完成，或逾時
 * @param {String} outDir 輸出目錄
 * @param {Map|String} sinceOrBaseline CSV 基準快照或相容用起始時間
 * @param {Integer} timeoutMs 逾時毫秒
 * @param {Integer} pollMs 輪詢間隔毫秒
 * @returns {String} CSV 完整路徑，逾時則回傳空字串
 */
WaitNewCsv(outDir, sinceOrBaseline, timeoutMs := 10000, pollMs := 200) {
    deadline := A_TickCount + timeoutMs
    lastPath := "", lastSig := "", stableCount := 0
    Loop {
        if IsExportCancelled()
            return ""
        csv := FindNewCsv(outDir, sinceOrBaseline)
        if (csv != "" && IsFileReady(csv)) {
            sig := GetCsvSignature(csv)
            if (csv == lastPath && sig != "" && sig == lastSig) {
                stableCount++
                if (stableCount >= 2)
                    return csv
            } else {
                lastPath := csv
                lastSig := sig
                stableCount := 1
            }
        }
        if (A_TickCount >= deadline)
            return ""
        Sleep(pollMs)
    }
}

/**
 * 將檔案複製至 dstRoot\dateStr\ (保留原檔名，同名覆蓋)
 * @param {String} src 來源檔案
 * @param {String} dstRoot 目的根目錄
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 目的檔完整路徑，失敗則回傳空字串
 */
CopyToDateDir(src, dstRoot, dateStr) {
    if !FileExist(src)
        return ""
    SplitPath(src, &fileName)
    dstDir := dstRoot "\" dateStr
    try {
        if !DirExist(dstDir)
            DirCreate(dstDir)
        dst := dstDir "\" fileName
        FileCopy(src, dst, true)
        return dst
    } catch as err {
        LogMsg(Format("複製匯出檔失敗 ({1} → {2}): {3}", src, dstDir, err.Message), "ERROR")
        return ""
    }
}

/**
 * 取得系統中所有 EXCEL.EXE 的程序 ID (PID)
 * 使用 Win32 Toolhelp32Snapshot，高效率且不依賴外部服務
 * @returns {Map} Map(pid, true)
 */
GetExcelProcessIds() {
    pids := Map()
    hSnap := DllCall("CreateToolhelp32Snapshot", "UInt", 0x2, "UInt", 0, "Ptr")
    if (hSnap == -1 || hSnap == 0)
        return pids
    pe32 := Buffer(568, 0)
    NumPut("UInt", 568, pe32, 0)
    if DllCall("Process32FirstW", "Ptr", hSnap, "Ptr", pe32) {
        Loop {
            name := StrGet(pe32.Ptr + 44)
            if (StrCompare(name, "EXCEL.EXE", false) == 0) {
                pid := NumGet(pe32, 8, "UInt")
                pids[pid] := true
            }
            if !DllCall("Process32NextW", "Ptr", hSnap, "Ptr", pe32)
                break
        }
    }
    DllCall("CloseHandle", "Ptr", hSnap)
    return pids
}

/**
 * 記錄批次開始前的 Excel PID 與頂層視窗 HWND 基準
 * @returns {Object} { pids: Map, hwnds: Map }
 */
CaptureExcelBaseline() {
    baseline := { pids: Map(), hwnds: Map() }

    ; 1. 取得所有目前已存在的 EXCEL.EXE 程序 ID
    pids := GetExcelProcessIds()
    for pid in pids
        baseline.pids[pid] := true

    ; 2. 取得所有目前已存在的 EXCEL.EXE 視窗代碼
    try {
        hwnds := WinGetList("ahk_exe EXCEL.EXE")
        for hwnd in hwnds {
            baseline.hwnds[hwnd] := true
            try {
                pid := WinGetPID(hwnd)
                if (pid)
                    baseline.pids[pid] := true
            }
        }
    }
    return baseline
}

/**
 * 純邏輯過濾：從視窗清單中排除 baseline 受保護的 HWND 與 PID
 * @param {Array} rawWindows [{hwnd, pid, title}, ...]
 * @param {Object} baseline 基準物件
 * @returns {Array} 相較基準新增的視窗清單
 */
FilterNewExportExcelWindows(rawWindows, baseline) {
    newWins := []
    if !IsObject(baseline) || !baseline.HasProp("pids") || !baseline.HasProp("hwnds")
        return newWins

    for item in rawWindows {
        if baseline.hwnds.Has(item.hwnd)
            continue
        if (item.HasProp("pid") && item.pid && baseline.pids.Has(item.pid))
            continue
        newWins.Push(item)
    }
    return newWins
}

/**
 * 列出相較基準新增的 Excel 視窗，並排除受保護 PID 與 HWND
 * @param {Object} baseline 基準物件
 * @returns {Array} [{hwnd, pid, title}, ...]
 */
FindNewExportExcelWindows(baseline) {
    if !IsObject(baseline) || !baseline.HasProp("pids") || !baseline.HasProp("hwnds")
        return []

    rawWins := []
    try {
        hwnds := WinGetList("ahk_exe EXCEL.EXE")
        for hwnd in hwnds {
            pid := 0
            title := ""
            try pid := WinGetPID(hwnd)
            try title := WinGetTitle(hwnd)
            rawWins.Push({ hwnd: hwnd, pid: pid, title: title })
        }
    }
    return FilterNewExportExcelWindows(rawWins, baseline)
}

/**
 * 純邏輯過濾：從程序清單中排除 baseline 受保護的 PID
 * @param {Array|Map} currentPids 當前 PID 清單
 * @param {Object} baseline 基準物件
 * @returns {Array} 相較基準新增的 PID 清單
 */
FilterNewExportExcelProcesses(currentPids, baseline) {
    newPids := []
    if !IsObject(baseline) || !baseline.HasProp("pids")
        return newPids

    for pid in currentPids {
        if !baseline.pids.Has(pid)
            newPids.Push(pid)
    }
    return newPids
}

/**
 * 列出相較基準新增的 EXCEL.EXE 程序 PID
 * @param {Object} baseline 基準物件
 * @returns {Array} 新增的 PID 清單
 */
FindNewExportExcelProcesses(baseline) {
    if !IsObject(baseline) || !baseline.HasProp("pids")
        return []
    currPids := GetExcelProcessIds()
    return FilterNewExportExcelProcesses(currPids, baseline)
}

/**
 * 關閉相較基準新增由三竹開啟的 Excel 視窗與程序
 * 優先採用 WinClose 正常關閉，若逾時且確認屬於本批次新開啟，則終止程序。
 * 清理失敗不中斷流程，詳細記錄日誌。
 * @param {Object} baseline 基準物件
 * @param {Integer} timeoutMs 正常關閉確認逾時毫秒 (預設 1500ms)
 * @returns {Object} { closedWins: Integer, closedPids: Integer, failed: Array }
 */
CloseNewExportExcels(baseline, timeoutMs := 1500) {
    result := { closedWins: 0, closedPids: 0, failed: [] }
    if !IsObject(baseline) || !baseline.HasProp("pids") || !baseline.HasProp("hwnds")
        return result

    try {
        newWins := FindNewExportExcelWindows(baseline)
        if (newWins.Length == 0) {
            ; 檢查是否有無視窗殘留之新增 Excel 程序
            newPids := FindNewExportExcelProcesses(baseline)
            for pid in newPids {
                if baseline.pids.Has(pid)
                    continue
                try {
                    ProcessClose(pid)
                    result.closedPids++
                    LogMsg(Format("已終止三竹殘留無效 Excel 程序 (PID: {1})", pid), "INFO")
                } catch as err {
                    result.failed.Push(Format("PID {1}: {2}", pid, err.Message))
                    LogMsg(Format("終止殘留 Excel 程序失敗 (PID: {1}): {2}", pid, err.Message), "WARN")
                }
            }
            return result
        }

        ; 1. 對所有新增視窗發送 WinClose 正常關閉
        targetPids := Map()
        for item in newWins {
            LogMsg(Format("正在正常關閉三竹匯出開啟之 Excel 視窗 (HWND: {1}, PID: {2}, 標題: '{3}')", item.hwnd, item.pid, item.title), "INFO")
            if (item.pid)
                targetPids[item.pid] := true
            try WinClose(item.hwnd)
            catch as err {
                LogMsg(Format("傳送 WinClose 失敗 (HWND: {1}): {2}", item.hwnd, err.Message), "WARN")
            }
        }

        ; 2. 輪詢確認視窗關閉
        deadline := A_TickCount + timeoutMs
        pendingWins := newWins.Clone()
        Loop {
            stillOpen := []
            for item in pendingWins {
                if WinExist(item.hwnd)
                    stillOpen.Push(item)
                else
                    result.closedWins++
            }
            pendingWins := stillOpen
            if (pendingWins.Length == 0)
                break
            if (A_TickCount >= deadline)
                break
            Sleep(50)
        }

        ; 3. 逾時處理：若視窗仍未關閉，依安全條件終止確認為本批次新增之程序
        if (pendingWins.Length > 0) {
            for item in pendingWins {
                ; 嚴格保護：絕不終止基準中的既有 PID 或 HWND
                if (baseline.hwnds.Has(item.hwnd) || (item.pid && baseline.pids.Has(item.pid))) {
                    LogMsg(Format("安全防護攔截：視窗 (HWND: {1}, PID: {2}) 屬於受保護基準，略過強制終止", item.hwnd, item.pid), "ERROR")
                    continue
                }
                LogMsg(Format("Excel 視窗正常關閉逾時 ({1}ms)，強制結束新增程序 (PID: {2}, 標題: '{3}')", timeoutMs, item.pid, item.title), "WARN")
                if (item.pid && ProcessExist(item.pid)) {
                    try {
                        ProcessClose(item.pid)
                        ProcessWaitClose(item.pid, 0.5)
                        result.closedPids++
                    } catch as err {
                        result.failed.Push(Format("HWND {1}/PID {2}: {3}", item.hwnd, item.pid, err.Message))
                        LogMsg(Format("強制結束 Excel 程序失敗 (PID: {1}): {2}", item.pid, err.Message), "ERROR")
                    }
                }
            }
        }

        ; 4. 檢查是否有剩餘未清理的新增 Excel 程序
        for pid in FindNewExportExcelProcesses(baseline) {
            if baseline.pids.Has(pid)
                continue
            try {
                ProcessClose(pid)
                result.closedPids++
                LogMsg(Format("清理新增 Excel 程序 (PID: {1})", pid), "INFO")
            } catch as err {
                result.failed.Push(Format("PID {1}: {2}", pid, err.Message))
            }
        }
    } catch as topErr {
        LogMsg(Format("CloseNewExportExcels 執行異常: {1}", topErr.Message), "ERROR")
        result.failed.Push(topErr.Message)
    }

    return result
}


/**
 * 檢查指定解析度目錄下的圖檔是否齊全 (不使用跨解析度備援)
 * @param {Array} names 圖檔名稱清單
 * @param {String} resStr 解析度字串，預設為主顯示器解析度
 * @returns {Boolean}
 */
HasResAssets(names, resStr := "") {
    if (resStr == "")
        resStr := GetRes(0).str
    for name in names {
        if !FileExist(GetRootDir() "\assets\" resStr "\" name)
            return false
    }
    return true
}

/**
 * 重設「熱門排行」視窗狀態：
 * 送出 Esc 鍵關閉殘留下拉選單，並將滑鼠游標移至左上角空白區以清除按鈕 Hover 高亮狀態
 * @param {String|Integer} tgtWin 目標視窗 (預設抓取「熱門排行」)
 */
ResetPopRankState(tgtWin := "") {
    winTitle := (tgtWin != "") ? tgtWin : GetPopRankWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if (hwnd) {
        if (!WinActive(hwnd)) {
            WinActivate(hwnd)
            Sleep(50)
        }
        Send("{Esc}")
        Sleep(100)
        oldMouse := CoordMode("Mouse", "Client")
        MouseMove(10, 10, 0)
        CoordMode("Mouse", oldMouse)
        Sleep(50)
    }
}

/**
 * 點擊「資料匯出」按鈕：優先圖像辨識，失敗時退回 settings.ini [ExportButton] 之解析度座標
 * 若該解析度未設定座標 (0,0) 則不盲點，回傳 false
 * @param {String} winTitle 目標視窗
 * @param {Object} res 主顯示器解析度物件 (GetRes)
 * @returns {Boolean} 是否已點擊
 */
ClickExportBtn(winTitle, res) {
    exportImg := GetRootDir() "\assets\" res.str "\資料匯出.png"
    if FindClickImg(exportImg, 0, 0, res.width, res.height, 45, winTitle, true).found
        return true

    coords := GetResCoords("ExportButton", 0, 0, res.str)
    if (coords.x <= 0 || coords.y <= 0) {
        LogMsg(Format("資料匯出：圖像未比對到且 [ExportButton] 未設定 {1} 座標", res.str), "WARN")
        return false
    }
    if !ClickPoint(coords.x, coords.y, winTitle, false)
        return false
    LogMsg(Format("資料匯出：圖像未比對到，降級採用解析度 [{1}] 座標點擊 (X:{2}, Y:{3})", res.str, coords.x, coords.y), "WARN")
    return true
}

/**
 * 執行單次「熱門排行」單一項目匯出 (不含重試)
 * @param {Integer} itemNo 項目序號 (1 起算)
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 複製後的目的檔路徑，失敗則回傳空字串
 */
TryExportPopRankItem(itemNo, dateStr) {
    res := GetRes(0)
    winTitle := GetPopRankWinTitle()

    ; 0. 操作前重設狀態 (收合殘留下拉選單並移開滑鼠清除 Hover)
    ResetPopRankState(winTitle)

    ; 1. 切換至「熱門排行」視窗並最大化 (未開啟則自動開啟)
    if !SwitchToPopRankWin() {
        LogMsg(Format("熱門排行 #{1}：無法切換至熱門排行視窗", itemNo), "WARN")
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊下拉箭頭 (variation 設為 45 提升容許度)
    dropImg := GetRootDir() "\assets\" res.str "\熱門下拉.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("熱門排行 #{1}：找不到下拉箭頭", itemNo), "WARN")
        ResetPopRankState(winTitle)
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. PageUp × 5 次回首項 → 獨立 Down 脈衝 × (itemNo-1) → Enter
    LogMsg(Format("熱門排行 #{1}：下拉導航 PgUp×5、Down×{2}", itemNo, itemNo - 1), "INFO")
    if !ExecuteDropdownNav(itemNo)
        return ""

    ; 選取後立即移開滑鼠，避免游標停在按鈕上方造成 Hover 影響或干擾畫面
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)

    ; 7. 點擊資料匯出 (記錄觸發時間以辨識新產生的 CSV；圖像辨識失敗時退回 settings.ini 座標)
    outDir := GetExportOutDir("PopularRanking")
    baseline := CaptureCsvState(outDir)
    if !ClickExportBtn(winTitle, res) {
        LogMsg(Format("熱門排行 #{1}：找不到資料匯出按鈕", itemNo), "WARN")
        ResetPopRankState(winTitle)
        return ""
    }

    ; 點擊後再次移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 8. 輪詢輸出目錄取得新 CSV
    csv := WaitNewCsv(outDir, baseline, ExportTiming.TimeoutMs, ExportTiming.PollMs)
    if (csv == "") {
        if IsExportCancelled()
            return ""
        LogMsg(Format("熱門排行 #{1}：{2} 毫秒內未在 {3} 偵測到新 CSV", itemNo, ExportTiming.TimeoutMs, outDir), "WARN")
        ResetPopRankState(winTitle)
        if IsObject(ExportRunState.ExcelBaseline)
            CloseNewExportExcels(ExportRunState.ExcelBaseline)
        return ""
    }

    ; 9. 複製至 熱門排行\YYYYMMDD\
    dst := CopyToDateDir(csv, GetPopRankDstRoot(), dateStr)
    if (dst != "") {
        LogMsg(Format("熱門排行 #{1}：已匯出 {2}", itemNo, dst), "INFO")
        excelBase := IsObject(ExportRunState.ExcelBaseline) ? ExportRunState.ExcelBaseline : CaptureExcelBaseline()
        CloseNewExportExcels(excelBase)
    }
    return dst
}

/**
 * 匯出「熱門排行」單一項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNo 項目序號 (1 起算)
 * @param {String} dateStr 日期子資料夾名稱 (預設為今日 YYYYMMDD)
 * @returns {Boolean} 是否成功
 */
ExportPopRankItem(itemNo, dateStr := "") {
    total := GetPopRankTotalItems()
    if (!IsInteger(itemNo) || itemNo < 1 || itemNo > total) {
        LogMsg(Format("熱門排行匯出：項目序號無效 ({1})", itemNo), "ERROR")
        return false
    }
    if (dateStr == "")
        dateStr := FormatTime(A_Now, "yyyyMMdd")

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("熱門排行 #{1}：第 {2} 次重試，先進行狀態重設", itemNo, A_Index - 1), "WARN")
            ResetPopRankState()
            Sleep(300)
        }
        try {
            if (TryExportPopRankItem(itemNo, dateStr) != "")
                return true
        } catch as err {
            LogMsg(Format("熱門排行 #{1}：執行異常 {2}", itemNo, err.Message), "ERROR")
        }
    }
    LogMsg(Format("熱門排行 #{1}：重試 {2} 次後仍失敗", itemNo, ExportTiming.MaxRetries), "ERROR")
    ResetPopRankState()
    return false
}

/**
 * 批次匯出「熱門排行」全部項目 (1..TotalItems)
 * @param {Boolean} showMsgBox 完成或中止時是否彈出提示視窗 (無頭測試時設為 false)
 * @returns {Object} {total: Integer, ok: Array, failed: Array, aborted: Boolean}
 */
ExportPopRankAll(showMsgBox := true) {
    total := GetPopRankTotalItems()
    if !BeginExportRun("熱門排行匯出", showMsgBox)
        return {total: total, ok: [], failed: [], aborted: true}
    stageState := ""
    try {
        stageState := StageExistingCsvs(GetExportOutDir("PopularRanking"), "熱門排行")
        return RunExportPopRankAll(showMsgBox)
    } catch as err {
        msg := Format("熱門排行匯出中止：{1}", err.Message)
        LogMsg(msg, "ERROR")
        if showMsgBox
            MsgBox(msg, "熱門排行匯出", "Icon!")
        return {total: total, ok: [], failed: [], aborted: true}
    } finally {
        if IsObject(stageState)
            FinalizeCsvStage(stageState)
        if IsObject(ExportRunState.ExcelBaseline)
            CloseNewExportExcels(ExportRunState.ExcelBaseline)
        EndExportRun()
    }
}

RunExportPopRankAll(showMsgBox := true) {
    total := GetPopRankTotalItems()
    result := {total: total, ok: [], failed: [], aborted: false}

    ; 前置檢查：解析度與該解析度之圖檔
    res := GetRes(0)
    if !ValidatePriRes(showMsgBox) || !HasResAssets(PopRankAssets(), res.str) {
        msg := Format("熱門排行匯出中止：解析度 {1} 缺少圖檔 (assets\{1}\熱門下拉.png、資料匯出.png) 或不支援", res.str)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "熱門排行匯出", "Icon!")
        result.aborted := true
        return result
    }

    dateStr := FormatTime(A_Now, "yyyyMMdd")
    LogMsg(Format("熱門排行匯出開始：共 {1} 項，目的資料夾 {2}\{3}", total, GetPopRankDstRoot(), dateStr), "INFO")

    Loop total {
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        ok := ExportPopRankItem(A_Index, dateStr)
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        if ok
            result.ok.Push(A_Index)
        else
            result.failed.Push(A_Index)
    }

    failedStr := ""
    for n in result.failed
        failedStr .= (failedStr == "" ? "" : ", ") n
    summary := Format("熱門排行匯出{1}：成功 {2} / {3} 項{4}", result.aborted ? "已中止" : "完成", result.ok.Length, total
        , result.failed.Length ? "`n失敗項目：" failedStr : "")
    LogMsg(StrReplace(summary, "`n", "；"), result.aborted || result.failed.Length ? "WARN" : "INFO")
    if showMsgBox
        MsgBox(summary, "熱門排行匯出", result.aborted || result.failed.Length ? "Icon!" : "Iconi")
    return result
}

; =============================================================================
; 盤後排行匯出函式群 (左側分類 5 項，各分類所屬子項目數量不一)
; =============================================================================

/**
 * 盤後排行匯出所需之圖檔 (須存在於 assets/{解析度}/)
 */
AfterRankAssets() => ["盤後下拉L.png", "盤後下拉R.png", "資料匯出.png"]

/**
 * 取得「盤後排行」左側下拉清單項目總數
 * @returns {Integer} 項目總數 (settings.ini [AfterMarketRanking] TotalItemsL，預設 5)
 */
GetAfterRankTotalItemsL() {
    val := GetCfg("AfterMarketRanking", "TotalItemsL", "5")
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : 5
}

/**
 * 取得「盤後排行」指定左側項目對應之右側下拉清單項目總數
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Integer} 項目總數 (settings.ini [AfterMarketRanking] TotalItemsR{itemNoL}，預設依規格對照)
 */
GetAfterRankTotalItemsR(itemNoL := 1) {
    static defCounts := Map(1, 10, 2, 10, 3, 4, 4, 8, 5, 4)
    defVal := defCounts.Has(itemNoL) ? String(defCounts[itemNoL]) : "10"
    val := GetCfg("AfterMarketRanking", "TotalItemsR" itemNoL, defVal)
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : Integer(defVal)
}

/**
 * 取得盤後排行匯出檔之專案目的根目錄
 * @returns {String} <專案根目錄>\盤後排行
 */
GetAfterRankDstRoot() {
    return GetRootDir() "\盤後排行"
}

/**
 * 重設「盤後排行」視窗狀態：
 * 送出 Esc 鍵關閉殘留下拉選單，並將滑鼠游標移至左上角空白區以清除按鈕 Hover 高亮狀態
 * @param {String|Integer} tgtWin 目標視窗 (預設抓取「盤後排行」)
 */
ResetAfterRankState(tgtWin := "") {
    winTitle := (tgtWin != "") ? tgtWin : GetAfterRankWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if (hwnd) {
        if (!WinActive(hwnd)) {
            WinActivate(hwnd)
            Sleep(50)
        }
        Send("{Esc}")
        Sleep(100)
        oldMouse := CoordMode("Mouse", "Client")
        MouseMove(10, 10, 0)
        CoordMode("Mouse", oldMouse)
        Sleep(50)
    }
}

/**
 * 執行單次「盤後排行」左側下拉項目選取 (不含重試)
 * 1. SwitchToAfterRankWin()
 * 2. FindClickImg("盤後下拉L.png")
 * 3. Send("{Home}") + PgUp 批次歸位
 * 4. Send("{Down}") × (itemNoL - 1)
 * 5. Send("{Enter}")
 * 6. Sleep 等待資料刷新
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Boolean} 是否選取成功
 */
TryExportAfterRankItemL(itemNoL) {
    res := GetRes(0)
    winTitle := GetAfterRankWinTitle()

    ; 0. 操作前重設狀態 (收合殘留下拉選單並移開滑鼠清除 Hover)
    ResetAfterRankState(winTitle)

    ; 1. 切換至「盤後排行」視窗並最大化 (未開啟則自動開啟)
    if !SwitchToAfterRankWin() {
        LogMsg(Format("盤後排行 L#{1}：無法切換至盤後排行視窗", itemNoL), "WARN")
        return false
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊左側下拉箭頭 (搜尋整個工作區，variation 設為 45)
    dropImg := GetRootDir() "\assets\" res.str "\盤後下拉L.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("盤後排行 L#{1}：找不到左側下拉箭頭 (盤後下拉L.png)", itemNoL), "WARN")
        ResetAfterRankState(winTitle)
        return false
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. 首項歸位 (Home + PgUp 批次防護) → 獨立 Down 脈衝 → Enter
    LogMsg(Format("盤後排行 L#{1}：下拉導航 Home、PgUp×5、Down×{2}", itemNoL, itemNoL - 1), "INFO")
    if !ExecuteDropdownNav(itemNoL, true)
        return false

    ; 選取後立即移開滑鼠，避免游標停在按鈕上方造成 Hover 影響
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)
    LogMsg(Format("盤後排行 L#{1}：選取完成", itemNoL), "INFO")
    return true
}

/**
 * 選取「盤後排行」左側下拉項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Boolean} 是否成功
 */
ExportAfterRankItemL(itemNoL) {
    if (!IsInteger(itemNoL) || itemNoL < 1 || itemNoL > GetAfterRankTotalItemsL()) {
        LogMsg(Format("盤後排行 L 選取：項目序號無效 ({1})", itemNoL), "ERROR")
        return false
    }

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("盤後排行 L#{1}：第 {2} 次重試，先進行狀態重設", itemNoL, A_Index - 1), "WARN")
            ResetAfterRankState()
            Sleep(300)
        }
        try {
            if TryExportAfterRankItemL(itemNoL)
                return true
        } catch as err {
            LogMsg(Format("盤後排行 L#{1}：執行異常 {2}", itemNoL, err.Message), "ERROR")
        }
    }
    LogMsg(Format("盤後排行 L#{1}：重試 {2} 次後仍失敗", itemNoL, ExportTiming.MaxRetries), "ERROR")
    ResetAfterRankState()
    return false
}

/**
 * 執行單次「盤後排行」右側下拉項目匯出 (不含重試)
 * 1. 確保切換至「盤後排行」視窗 (防止被 Excel 等程式搶走焦點)
 * 2. FindClickImg("盤後下拉R.png")
 * 3. Send("{Home}") + PgUp 批次歸位
 * 4. Send("{Down}") × (itemNoR - 1)
 * 5. Send("{Enter}")
 * 6. Sleep 等待資料刷新
 * 7. 擷取 CSV 基準快照 → FindClickImg("資料匯出.png")
 * 8. 輪詢 OutDir 尋找相較快照新增或內容已變更的 CSV
 * 9. CopyToDateDir(csv, <專案>\盤後排行, dateStr)
 * @param {Integer} itemNoR 右側項目序號 (1 起算)
 * @param {Integer} itemNoL 所屬左側項目序號 (供日誌記錄，選用)
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 複製後的目的檔路徑，失敗則回傳空字串
 */
TryExportAfterRankItemR(itemNoR, itemNoL := 0, dateStr := "") {
    res := GetRes(0)
    winTitle := GetAfterRankWinTitle()
    tag := (itemNoL > 0) ? Format("L#{1}-R#{2}", itemNoL, itemNoR) : Format("R#{1}", itemNoR)

    ; 0. 操作前重設狀態
    ResetAfterRankState(winTitle)

    ; 1. 切換至「盤後排行」視窗 (若 Excel 或其他程式搶焦點則切回)
    if !SwitchToAfterRankWin() {
        LogMsg(Format("盤後排行 {1}：無法切換至盤後排行視窗", tag), "WARN")
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊右側下拉箭頭 (搜尋整個工作區，variation 設為 45)
    dropImg := GetRootDir() "\assets\" res.str "\盤後下拉R.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("盤後排行 {1}：找不到右側下拉箭頭 (盤後下拉R.png)", tag), "WARN")
        ResetAfterRankState(winTitle)
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. 首項歸位 (Home + PgUp 批次防護) → 獨立 Down 脈衝 → Enter
    LogMsg(Format("盤後排行 {1}：下拉導航 Home、PgUp×5、Down×{2}", tag, itemNoR - 1), "INFO")
    if !ExecuteDropdownNav(itemNoR, true)
        return ""

    ; 選取後立即移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)

    ; 7. 點擊資料匯出
    outDir := GetExportOutDir("AfterMarketRanking")
    baseline := CaptureCsvState(outDir)
    if !ClickExportBtn(winTitle, res) {
        LogMsg(Format("盤後排行 {1}：找不到資料匯出按鈕", tag), "WARN")
        ResetAfterRankState(winTitle)
        return ""
    }

    ; 點擊後再次移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 8. 輪詢輸出目錄取得新 CSV
    csv := WaitNewCsv(outDir, baseline, ExportTiming.TimeoutMs, ExportTiming.PollMs)
    if (csv == "") {
        if IsExportCancelled()
            return ""
        LogMsg(Format("盤後排行 {1}：{2} 毫秒內未在 {3} 偵測到新 CSV", tag, ExportTiming.TimeoutMs, outDir), "WARN")
        ResetAfterRankState(winTitle)
        if IsObject(ExportRunState.ExcelBaseline)
            CloseNewExportExcels(ExportRunState.ExcelBaseline)
        return ""
    }

    ; 9. 複製至 盤後排行\YYYYMMDD\
    dst := CopyToDateDir(csv, GetAfterRankDstRoot(), dateStr)
    if (dst != "") {
        LogMsg(Format("盤後排行 {1}：已匯出 {2}", tag, dst), "INFO")
        excelBase := IsObject(ExportRunState.ExcelBaseline) ? ExportRunState.ExcelBaseline : CaptureExcelBaseline()
        CloseNewExportExcels(excelBase)
    }
    return dst
}

/**
 * 匯出「盤後排行」右側單一項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNoR 右側項目序號 (1 起算)
 * @param {Integer} itemNoL 所屬左側項目序號 (供日誌記錄，選用)
 * @param {String} dateStr 日期子資料夾名稱 (預設為今日 YYYYMMDD)
 * @returns {Boolean} 是否成功
 */
ExportAfterRankItemR(itemNoR, itemNoL := 0, dateStr := "") {
    tag := (itemNoL > 0) ? Format("L#{1}-R#{2}", itemNoL, itemNoR) : Format("R#{1}", itemNoR)
    if (!IsInteger(itemNoL) || itemNoL < 0 || itemNoL > GetAfterRankTotalItemsL()) {
        LogMsg(Format("盤後排行匯出：左側項目序號無效 ({1})", itemNoL), "ERROR")
        return false
    }
    maxR := (IsInteger(itemNoL) && itemNoL >= 1 && itemNoL <= GetAfterRankTotalItemsL())
        ? GetAfterRankTotalItemsR(itemNoL) : 10
    if (!IsInteger(itemNoR) || itemNoR < 1 || itemNoR > maxR) {
        LogMsg(Format("盤後排行匯出：項目序號無效 ({1})", tag), "ERROR")
        return false
    }
    if (dateStr == "")
        dateStr := FormatTime(A_Now, "yyyyMMdd")

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("盤後排行 {1}：第 {2} 次重試，先進行狀態重設", tag, A_Index - 1), "WARN")
            ResetAfterRankState()
            Sleep(300)
        }
        try {
            if (TryExportAfterRankItemR(itemNoR, itemNoL, dateStr) != "")
                return true
        } catch as err {
            LogMsg(Format("盤後排行 {1}：執行異常 {2}", tag, err.Message), "ERROR")
        }
    }
    LogMsg(Format("盤後排行 {1}：重試 {2} 次後仍失敗", tag, ExportTiming.MaxRetries), "ERROR")
    ResetAfterRankState()
    return false
}

/**
 * 批次匯出「盤後排行」全部項目 (所有 L 與各 L 對應之所有 R)
 * @param {Boolean} showMsgBox 完成或中止時是否彈出提示視窗 (無頭測試時設為 false)
 * @returns {Object} {total: Integer, ok: Array, failed: Array, aborted: Boolean}
 */
ExportAfterRankAll(showMsgBox := true) {
    totalL := GetAfterRankTotalItemsL()
    totalItems := 0
    Loop totalL
        totalItems += GetAfterRankTotalItemsR(A_Index)
    if !BeginExportRun("盤後排行匯出", showMsgBox)
        return {total: totalItems, ok: [], failed: [], aborted: true}
    stageState := ""
    try {
        stageState := StageExistingCsvs(GetExportOutDir("AfterMarketRanking"), "盤後排行")
        return RunExportAfterRankAll(showMsgBox)
    } catch as err {
        msg := Format("盤後排行匯出中止：{1}", err.Message)
        LogMsg(msg, "ERROR")
        if showMsgBox
            MsgBox(msg, "盤後排行匯出", "Icon!")
        return {total: totalItems, ok: [], failed: [], aborted: true}
    } finally {
        if IsObject(stageState)
            FinalizeCsvStage(stageState)
        if IsObject(ExportRunState.ExcelBaseline)
            CloseNewExportExcels(ExportRunState.ExcelBaseline)
        EndExportRun()
    }
}

RunExportAfterRankAll(showMsgBox := true) {
    totalL := GetAfterRankTotalItemsL()
    totalItems := 0
    Loop totalL
        totalItems += GetAfterRankTotalItemsR(A_Index)
    result := {total: totalItems, ok: [], failed: [], aborted: false}

    ; 前置檢查：主顯示器解析度與該解析度圖檔是否齊全 (支援 1920x1080 與 2560x1440)
    res := GetRes(0)
    if !ValidatePriRes(showMsgBox) || !HasResAssets(AfterRankAssets(), res.str) {
        msg := Format("盤後排行匯出中止：解析度 {1} 缺少圖檔 (assets\{1}\盤後下拉L.png、盤後下拉R.png、資料匯出.png) 或不支援", res.str)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "盤後排行匯出", "Icon!")
        result.aborted := true
        return result
    }

    dateStr := FormatTime(A_Now, "yyyyMMdd")
    LogMsg(Format("盤後排行匯出開始：共 {1} 項，目的資料夾 {2}\{3}", totalItems, GetAfterRankDstRoot(), dateStr), "INFO")

    Loop totalL {
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        itemNoL := A_Index
        totalR := GetAfterRankTotalItemsR(itemNoL)
        LogMsg(Format("盤後排行：開始處理左側分類 #{1} (共 {2} 個子項目)", itemNoL, totalR), "INFO")

        leftOk := ExportAfterRankItemL(itemNoL)
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        if !leftOk {
            LogMsg(Format("盤後排行：左側分類 #{1} 選取失敗，跳過所屬 {2} 個子項目", itemNoL, totalR), "ERROR")
            Loop totalR {
                result.failed.Push(Format("L{1}-R{2}", itemNoL, A_Index))
            }
            continue
        }

        Loop totalR {
            if IsExportCancelled() {
                result.aborted := true
                break
            }
            itemNoR := A_Index
            tag := Format("L{1}-R{2}", itemNoL, itemNoR)
            rightOk := ExportAfterRankItemR(itemNoR, itemNoL, dateStr)
            if IsExportCancelled() {
                result.aborted := true
                break
            }
            if rightOk
                result.ok.Push(tag)
            else
                result.failed.Push(tag)
        }
    }

    failedStr := ""
    for k in result.failed
        failedStr .= (failedStr == "" ? "" : ", ") k
    summary := Format("盤後排行匯出{1}：成功 {2} / {3} 項{4}", result.aborted ? "已中止" : "完成", result.ok.Length, result.total
        , result.failed.Length ? "`n失敗項目：" failedStr : "")
    LogMsg(StrReplace(summary, "`n", "；"), result.aborted || result.failed.Length ? "WARN" : "INFO")
    if showMsgBox
        MsgBox(summary, "盤後排行匯出", result.aborted || result.failed.Length ? "Icon!" : "Iconi")
    return result
}
