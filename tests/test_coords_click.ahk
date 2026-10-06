#Requires AutoHotkey v2.0
#Include ../lib/utils.ahk
#Include ../lib/window_control.ahk

/**
 * 測試相對座標點擊輔助函式
 * @param {String} targetSection "PopularRanking" 或 "AfterMarketRanking"
 * @param {String} targetName "熱門排行" 或 "盤後排行"
 * @param {Boolean} showDialog 測試完成後是否顯示彈窗提示
 * @returns {Boolean} 是否成功開啟視窗
 */
TestCoordinateClick(targetSection, targetName, showDialog := true) {
    ; 1. 確保三竹股市正在執行
    if !IsMitakeRunning() {
        LogMsg("尚未偵測到三竹股市，正在自動啟動...", "INFO")
        if !LaunchMitake() {
            MsgBox("無法啟動三竹股市，測試中止。", "錯誤", "Icon!")
            return false
        }
    } else {
        SwitchToMainWin()
    }
    
    Sleep(500)
    res := GetRes(0)
    mainTitle := GetMainWinTitle()
    
    ; 設定滑鼠與 ToolTip 為 Client (視窗客戶區) 座標系統
    oldMouse := CoordMode("Mouse", "Client")
    oldToolTip := CoordMode("ToolTip", "Client")
    
    ; 2. 步驟一：移動並點擊「證券行情」
    sqCoords := GetResCoords("SecuritiesQuote", 337, (res.str == "1920x1080") ? 15 : 14, res.str)
    ToolTip(Format("【1/2】即將點擊【證券行情】`n解析度: {1}`n座標: ({2}, {3})", res.str, sqCoords.x, sqCoords.y), sqCoords.x, sqCoords.y + 25)
    MouseMove(sqCoords.x, sqCoords.y, 10)
    Sleep(800)
    Click(sqCoords.x, sqCoords.y)
    ToolTip()
    
    ; 等待選單下拉展開動畫
    Sleep(400)
    
    ; 3. 步驟二：移動並點擊目標排行子選單
    defX := (targetSection == "PopularRanking") ? ((res.str == "1920x1080") ? 77 : 78) : 78
    defY := (targetSection == "PopularRanking") ? 80 : 110
    tgtCoords := GetResCoords(targetSection, defX, defY, res.str)
    
    ToolTip(Format("【2/2】即將點擊【{1}】`n解析度: {2}`n座標: ({3}, {4})", targetName, res.str, tgtCoords.x, tgtCoords.y), tgtCoords.x, tgtCoords.y + 25)
    MouseMove(tgtCoords.x, tgtCoords.y, 10)
    Sleep(800)
    Click(tgtCoords.x, tgtCoords.y)
    ToolTip()
    
    ; 還原 CoordMode
    CoordMode("Mouse", oldMouse)
    CoordMode("ToolTip", oldToolTip)
    
    ; 4. 驗證是否開啟新視窗
    tgtWinTitle := (targetSection == "PopularRanking") ? GetPopRankWinTitle() : GetAfterRankWinTitle()
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    
    success := false
    if WinWait(tgtWinTitle, , 5) || WinWait(tgtWinTitle " ahk_exe " procName, , 5) {
        hwnd := WinExist(tgtWinTitle) ? WinExist(tgtWinTitle) : WinExist(tgtWinTitle " ahk_exe " procName)
        ActivateMitake(hwnd)
        success := true
        LogMsg(Format("相對座標點擊測試成功：已開啟【{1}】視窗 (HWND: {2})", targetName, hwnd), "INFO")
        if (showDialog) {
            MsgBox(Format("測試成功！`n已透過相對座標成功點擊並開啟【{1}】視窗 (HWND: {2})。`n`n點擊座標：`n證券行情: ({3}, {4})`n{1}: ({5}, {6})", targetName, hwnd, sqCoords.x, sqCoords.y, tgtCoords.x, tgtCoords.y), "測試結果 - 成功", "Iconi")
        }
    } else {
        LogMsg(Format("相對座標點擊測試超時：未偵測到【{1}】新視窗", targetName), "WARN")
        if (showDialog) {
            MsgBox(Format("測試未成功：在 5 秒內未偵測到【{1}】新視窗出現。`n`n請觀察剛才滑鼠游標落點 ({2}, {3}) 是否落在該按鈕範圍內。", targetName, tgtCoords.x, tgtCoords.y), "測試結果 - 需微調", "Icon!")
        }
    }
    
    return success
}

; 依命令列參數執行或顯示互動式測試面板
if (A_Args.Length > 0) {
    action := StrLower(A_Args[1])
    if (action == "pop" || action == "popular" || action == "熱門排行") {
        TestCoordinateClick("PopularRanking", "熱門排行")
    } else if (action == "after" || action == "aftermarket" || action == "盤後排行") {
        TestCoordinateClick("AfterMarketRanking", "盤後排行")
    } else if (action == "all" || action == "全部") {
        TestCoordinateClick("PopularRanking", "熱門排行", false)
        Sleep(1000)
        TestCoordinateClick("AfterMarketRanking", "盤後排行", false)
        MsgBox("「熱門排行」與「盤後排行」相對座標點擊測試已全數完成！", "測試完成", "Iconi")
    }
    ExitApp()
}

; 顯示互動式測試視窗
resInfo := GetRes(0)
testGui := Gui("+AlwaysOnTop", "三竹股市 - 相對座標點擊測試工具")
testGui.SetFont("s10", "Microsoft JhengHei")
testGui.Add("Text", "w320", Format("目前主顯示器解析度：{1} ({2}x{3})`n請點選下方按鈕直接測試座標點擊：", resInfo.str, resInfo.width, resInfo.height))

btnPop := testGui.Add("Button", "w320 h35", "測試：證券行情 → 熱門排行")
btnAfter := testGui.Add("Button", "w320 h35 y+8", "測試：證券行情 → 盤後排行")
btnAll := testGui.Add("Button", "w320 h35 y+8", "測試：依序測試兩者")
btnExit := testGui.Add("Button", "w320 h30 y+15", "關閉測試工具")

btnPop.OnEvent("Click", (*) => (testGui.Hide(), TestCoordinateClick("PopularRanking", "熱門排行"), testGui.Show()))
btnAfter.OnEvent("Click", (*) => (testGui.Hide(), TestCoordinateClick("AfterMarketRanking", "盤後排行"), testGui.Show()))
btnAll.OnEvent("Click", (*) => (
    testGui.Hide(),
    TestCoordinateClick("PopularRanking", "熱門排行", false),
    Sleep(1000),
    TestCoordinateClick("AfterMarketRanking", "盤後排行", false),
    MsgBox("「熱門排行」與「盤後排行」相對座標點擊測試已全數完成！", "測試完成", "Iconi"),
    testGui.Show()
))
btnExit.OnEvent("Click", (*) => ExitApp())
testGui.OnEvent("Close", (*) => ExitApp())

testGui.Show("w360")
