#Requires AutoHotkey v2.0
#SingleInstance Force

; 視窗標題採部分比對，且僅操作目前可見的視窗
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

; 註冊 ShellHook 監聽視窗切換與焦點事件，自動最大化標題非空白的三竹股市視窗
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), ShellMsg)

ShellMsg(wParam, lParam, *) {
    ; HSHELL_WINDOWACTIVATED = 4, HSHELL_RUDEAPPACTIVATED = 32772 (0x8004)
    if (wParam == 4 || wParam == 32772) {
        try {
            proc := WinGetProcessName(lParam)
            winTitle := WinGetTitle(lParam)
            procCfg := GetCfg("App", "ProcessName", "三竹股市.exe")
            if ShouldMaximizeMitakeWin(proc, winTitle, procCfg) {
                WinMaximize(lParam)
            }
        }
    }
}

; 註冊快捷鍵輔助函式
RegisterHk(cfgKey, defKey, desc, handler) {
    hk := GetCfg("Hotkey", cfgKey, defKey)
    if (hk != "") {
        try {
            Hotkey(hk, handler)
            LogMsg(Format("已成功設定{1}快捷鍵: {2}", desc, hk), "INFO")
        } catch as err {
            LogMsg(Format("綁定{1}快捷鍵 [{2}] 失敗: {3}", desc, hk, err.Message), "WARN")
        }
    }
}

; 快捷鍵與功能對應表
hkDefs := [
    {cfg: "LaunchHotkey",             def: "^!m", desc: "啟動",     hnd: (*) => LaunchMitake()},
    {cfg: "MenuBarHotkey",            def: "^!b", desc: "選單列",   hnd: (*) => ToggleMenuBar()},
    {cfg: "SecuritiesQuoteHotkey",    def: "",    desc: "證券行情", hnd: (*) => ClickSecQuoteMenu()},
    {cfg: "PopularRankingHotkey",     def: "",    desc: "熱門排行", hnd: (*) => SwitchToPopRankWin()},
    {cfg: "AfterMarketRankingHotkey", def: "",    desc: "盤後排行", hnd: (*) => SwitchToAfterRankWin()}
]

for item in hkDefs {
    RegisterHk(item.cfg, item.def, item.desc, item.hnd)
}

mainRes := GetRes()
LogMsg(Format("三竹股市 AutoHotkey 控制腳本載入完成。主顯示器解析度: {1}", mainRes.str), "INFO")

; 執行主程序：啟動或切換至三竹股市
LaunchMitake()

; 托盤選單處理函式 (保持命名兼容性)
MenuLaunchHnd(*)   => LaunchMitake()
MenuToggleBarHnd(*) => ToggleMenuBar()
MenuSecQuoteHnd(*)  => ClickSecQuoteMenu()
MenuPopRankHnd(*)   => SwitchToPopRankWin()
MenuAfterRankHnd(*)  => SwitchToAfterRankWin()

MenuShowResHnd(*) {
    displays := GetAllRes()
    info := ""
    for idx, d in displays {
        info .= Format("顯示器 #{1}: {2} ({3}x{4}) {5}`n", idx, d.str, d.width, d.height, d.isPrimary ? "[主顯示器]" : "")
    }
    MsgBox(info, "系統顯示器解析度資訊", "Iconi")
}
