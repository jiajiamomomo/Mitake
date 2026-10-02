#Requires AutoHotkey v2.0
#SingleInstance Force

#Include lib\utils.ahk
#Include lib\window_control.ahk

; 初始化腳本與系統托盤 (Tray)
A_IconTip := "三竹股市 AutoHotkey 控制專案"
A_TrayMenu.Add() ; 分隔線
A_TrayMenu.Add("啟動/切換 三竹股市", MenuLaunchHandler)
A_TrayMenu.Add("開啟/切換 選單列", MenuToggleMenuBarHandler)
A_TrayMenu.Add("切換至 證券行情", MenuClickSecuritiesQuoteHandler)
A_TrayMenu.Add("切換至 熱門排行", MenuClickPopularRankingHandler)
A_TrayMenu.Add("顯示系統解析度", MenuShowResolutionHandler)
A_TrayMenu.Default := "啟動/切換 三竹股市"

; 註冊 ShellHook 監聽視窗切換與焦點事件，永遠自動最大化三竹股市視窗
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), ShellMessage)

ShellMessage(wParam, lParam, *) {
    ; HSHELL_WINDOWACTIVATED = 4, HSHELL_RUDEAPPACTIVATED = 32772 (0x8004)
    if (wParam == 4 || wParam == 32772) {
        try {
            proc := WinGetProcessName(lParam)
            procConfig := GetConfig("App", "ProcessName", "三竹股市.exe")
            if (proc == procConfig || proc == "三竹股市.exe" || InStr(proc, "三竹")) {
                WinMaximize(lParam)
            }
        }
    }
}

; 讀取快捷鍵設定
launchhk := GetConfig("Hotkey", "LaunchHotkey", "^!m")
if launchhk != "" {
    try {
        Hotkey(launchhk, HotkeyLaunchHandler)
        LogMessage(Format("已成功設定啟動快捷鍵: {1}", launchhk), "INFO")
    } catch as err {
        LogMessage(Format("綁定快捷鍵 [{1}] 失敗: {2}", launchhk, err.Message), "WARN")
    }
}

menubarhk := GetConfig("Hotkey", "MenuBarHotkey", "^!b")
if menubarhk != "" {
    try {
        Hotkey(menubarhk, HotkeyMenuBarHandler)
        LogMessage(Format("已成功設定選單列快捷鍵: {1}", menubarhk), "INFO")
    } catch as err {
        LogMessage(Format("綁定選單列快捷鍵 [{1}] 失敗: {2}", menubarhk, err.Message), "WARN")
    }
}

secquotehk := GetConfig("Hotkey", "SecuritiesQuoteHotkey", "")
if secquotehk != "" {
    try {
        Hotkey(secquotehk, HotkeySecuritiesQuoteHandler)
        LogMessage(Format("已成功設定證券行情快捷鍵: {1}", secquotehk), "INFO")
    } catch as err {
        LogMessage(Format("綁定證券行情快捷鍵 [{1}] 失敗: {2}", secquotehk, err.Message), "WARN")
    }
}

poprankhk := GetConfig("Hotkey", "PopularRankingHotkey", "")
if poprankhk != "" {
    try {
        Hotkey(poprankhk, HotkeyPopularRankingHandler)
        LogMessage(Format("已成功設定熱門排行快捷鍵: {1}", poprankhk), "INFO")
    } catch as err {
        LogMessage(Format("綁定熱門排行快捷鍵 [{1}] 失敗: {2}", poprankhk, err.Message), "WARN")
    }
}

mainRes := GetDisplayResolution()
LogMessage(Format("三竹股市 AutoHotkey 控制腳本載入完成。主顯示器解析度: {1}", mainRes.str), "INFO")

; 執行主程序：啟動或切換至三竹股市
LaunchMitakeStock()

MenuLaunchHandler(ItemName, ItemPos, MyMenu) {
    LaunchMitakeStock()
}

MenuToggleMenuBarHandler(ItemName, ItemPos, MyMenu) {
    ToggleMitakeMenuBar()
}

MenuClickSecuritiesQuoteHandler(ItemName, ItemPos, MyMenu) {
    ClickSecuritiesQuoteMenu()
}

MenuClickPopularRankingHandler(ItemName, ItemPos, MyMenu) {
    ClickPopularRankingMenu()
}

MenuShowResolutionHandler(ItemName, ItemPos, MyMenu) {
    displays := GetAllDisplaysResolution()
    info := ""
    for idx, d in displays {
        info .= Format("顯示器 #{1}: {2} ({3}x{4}) {5}`n", idx, d.str, d.width, d.height, d.isPrimary ? "[主顯示器]" : "")
    }
    MsgBox(info, "系統顯示器解析度資訊", "Iconi")
}

HotkeyLaunchHandler(HotkeyName) {
    LaunchMitakeStock()
}

HotkeyMenuBarHandler(HotkeyName) {
    ToggleMitakeMenuBar()
}

HotkeySecuritiesQuoteHandler(HotkeyName) {
    ClickSecuritiesQuoteMenu()
}

HotkeyPopularRankingHandler(HotkeyName) {
    ClickPopularRankingMenu()
}

