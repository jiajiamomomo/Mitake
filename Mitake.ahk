#Requires AutoHotkey v2.0
#SingleInstance Force

SetTitleMatchMode(2)
DetectHiddenWindows(false)

#Include lib\utils.ahk
#Include lib\window_control.ahk

; 初始化腳本與系統托盤 (Tray)
A_IconTip := "三竹股市 AutoHotkey 控制專案"
A_TrayMenu.Add() ; 分隔線
A_TrayMenu.Add("啟動/切換 三竹股市", MenuLaunchHnd)
A_TrayMenu.Add("切換至 熱門排行", MenuPopRankHnd)
A_TrayMenu.Add("切換至 盤後排行", MenuAfterRankHnd)
A_TrayMenu.Add("顯示系統解析度", MenuShowResHnd)
A_TrayMenu.Default := "啟動/切換 三竹股市"

; 註冊 ShellHook 監聽視窗切換與焦點事件，永遠自動最大化三竹股市視窗
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), ShellMsg)

ShellMsg(wParam, lParam, *) {
    ; HSHELL_WINDOWACTIVATED = 4, HSHELL_RUDEAPPACTIVATED = 32772 (0x8004)
    if (wParam == 4 || wParam == 32772) {
        try {
            proc := WinGetProcessName(lParam)
            procCfg := GetCfg("App", "ProcessName", "三竹股市.exe")
            if (proc == procCfg || proc == "三竹股市.exe" || InStr(proc, "三竹")) {
                WinMaximize(lParam)
            }
        }
    }
}

; 讀取快捷鍵設定
launchHk := GetCfg("Hotkey", "LaunchHotkey", "^!m")
if launchHk != "" {
    try {
        Hotkey(launchHk, HkLaunchHnd)
        LogMsg(Format("已成功設定啟動快捷鍵: {1}", launchHk), "INFO")
    } catch as err {
        LogMsg(Format("綁定快捷鍵 [{1}] 失敗: {2}", launchHk, err.Message), "WARN")
    }
}

menubarHk := GetCfg("Hotkey", "MenuBarHotkey", "^!b")
if menubarHk != "" {
    try {
        Hotkey(menubarHk, HkMenuBarHnd)
        LogMsg(Format("已成功設定選單列快捷鍵: {1}", menubarHk), "INFO")
    } catch as err {
        LogMsg(Format("綁定選單列快捷鍵 [{1}] 失敗: {2}", menubarHk, err.Message), "WARN")
    }
}

secQuoteHk := GetCfg("Hotkey", "SecuritiesQuoteHotkey", "")
if secQuoteHk != "" {
    try {
        Hotkey(secQuoteHk, HkSecQuoteHnd)
        LogMsg(Format("已成功設定證券行情快捷鍵: {1}", secQuoteHk), "INFO")
    } catch as err {
        LogMsg(Format("綁定證券行情快捷鍵 [{1}] 失敗: {2}", secQuoteHk, err.Message), "WARN")
    }
}

popRankHk := GetCfg("Hotkey", "PopularRankingHotkey", "")
if popRankHk != "" {
    try {
        Hotkey(popRankHk, HkPopRankHnd)
        LogMsg(Format("已成功設定熱門排行快捷鍵: {1}", popRankHk), "INFO")
    } catch as err {
        LogMsg(Format("綁定熱門排行快捷鍵 [{1}] 失敗: {2}", popRankHk, err.Message), "WARN")
    }
}

afterRankHk := GetCfg("Hotkey", "AfterMarketRankingHotkey", "")
if afterRankHk != "" {
    try {
        Hotkey(afterRankHk, HkAfterRankHnd)
        LogMsg(Format("已成功設定盤後排行快捷鍵: {1}", afterRankHk), "INFO")
    } catch as err {
        LogMsg(Format("綁定盤後排行快捷鍵 [{1}] 失敗: {2}", afterRankHk, err.Message), "WARN")
    }
}

mainRes := GetRes()
LogMsg(Format("三竹股市 AutoHotkey 控制腳本載入完成。主顯示器解析度: {1}", mainRes.str), "INFO")

; 執行主程序：啟動或切換至三竹股市
LaunchMitake()

MenuLaunchHnd(ItemName, ItemPos, MyMenu) {
    LaunchMitake()
}

MenuToggleBarHnd(ItemName, ItemPos, MyMenu) {
    ToggleMenuBar()
}

MenuSecQuoteHnd(ItemName, ItemPos, MyMenu) {
    ClickSecQuoteMenu()
}

MenuPopRankHnd(ItemName, ItemPos, MyMenu) {
    SwitchToPopRankWin()
}

MenuAfterRankHnd(ItemName, ItemPos, MyMenu) {
    SwitchToAfterRankWin()
}

MenuShowResHnd(ItemName, ItemPos, MyMenu) {
    displays := GetAllRes()
    info := ""
    for idx, d in displays {
        info .= Format("顯示器 #{1}: {2} ({3}x{4}) {5}`n", idx, d.str, d.width, d.height, d.isPrimary ? "[主顯示器]" : "")
    }
    MsgBox(info, "系統顯示器解析度資訊", "Iconi")
}

HkLaunchHnd(HotkeyName) {
    LaunchMitake()
}

HkMenuBarHnd(HotkeyName) {
    ToggleMenuBar()
}

HkSecQuoteHnd(HotkeyName) {
    ClickSecQuoteMenu()
}

HkPopRankHnd(HotkeyName) {
    SwitchToPopRankWin()
}

HkAfterRankHnd(HotkeyName) {
    SwitchToAfterRankWin()
}
