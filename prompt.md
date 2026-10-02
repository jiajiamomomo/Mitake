Project Path: 三竹

Source Tree:

```txt
三竹
├── Mitake.ahk
├── README.md
├── agents.md
├── assets
│   ├── 1920x1080
│   │   ├── menu_證券行情.png
│   │   ├── 熱門排行.png
│   │   └── 盤後排行.png
│   └── 2560x1440
├── config
│   └── settings.ini
├── lib
│   ├── utils.ahk
│   └── window_control.ahk
├── tests
├── 熱門排行
└── 盤後排行

```

`Mitake.ahk`:

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

#Include lib\utils.ahk
#Include lib\window_control.ahk

; 初始化腳本與系統托盤 (Tray)
A_IconTip := "三竹股市 AutoHotkey 控制專案"
A_TrayMenu.Add() ; 分隔線
A_TrayMenu.Add("啟動/切換 三竹股市", MenuLaunchHandler)
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


```
`README.md`:

```md
# Mitake
使用AutoHotkey (AHK v2)對「三竹股市電腦版」自動化執行匯出資料

```
`agents.md`:

```md
# 三竹股市電腦版 AutoHotkey 控制與自動化專案

本專案旨在利用 **AutoHotkey (AHK v2)** 自動化腳本，針對「**三竹股市電腦版**」進行軟體操控、視窗管理、熱鍵擴充及自動化執行。

---

## 專案簡介 (Overview)

透過 AutoHotkey 的視窗控制 (Window Management)、模擬輸入 (Input Simulation) 以及控制項操作 (Control API / GUI Automation)，實現以下目的：
- 自動啟動並定位三竹股市電腦版視窗。
- 讀取顯示器解析度。僅於主顯示器解析度為1920x1080或2560x1440時繼續執行，否則顯示顯示器解析度錯誤訊息。
- 自動化例行性操作 (對"熱門排行"與"盤後排行"的所有項目均執行匯出檔案)。

遵循Test-driven development (TDD)原則

所有與 AutoHotkey 相關之執行與測試命令在本專案中均視為自動核准 (Auto-approved)，開發時可直接執行驗證。

呼叫 AutoHotkey64.exe 時，使用完整路徑 `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"` 執行。

本專案使用中文字串(如 '三竹股市.exe')，請避免編碼解析異常，建議採用UTF-8。

使用Jujutsu(jj)配合GitHub作版本管理。

---

## 環境與軟體需求 (Prerequisites)

| 軟體 / 工具 | 建議版本 | 說明 |
| :--- | :--- | :--- |
| **Windows OS** | Windows 11 | 本專案執行環境 |
| **AutoHotkey** | v2.0 | AHK v2完整路徑: `C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe` |
| **三竹股市電腦版** | 最新官方版本 | D:\Program Files\MitakeGU\三竹股市.exe |

---

## 預計專案結構 (Directory Structure)

```text
三竹/
├── README.md             # 專案初始化與說明文件
├── AGENTS.md             # 專案 AI Agent 指引與規範文件
├── Mitake.ahk            # 主程式進入點 (Main entry)
├── assets/               # 圖像辨識與圖資目錄
│   ├── 1920x1080/        # 1920x1080 解析度圖檔目錄
│   └── 2560x1440/        # 2560x1440 解析度圖檔目錄
├── config/               # 設定檔目錄
│   └── settings.ini      # 專案參數與設定檔
├── lib/                  # 模組與函式庫 (功能模組)
│   ├── window_control.ahk # 三竹股市視窗控制模組
│   └── utils.ahk         # 通用工具函式 (如 Log、提示訊息等)
├── tests/                # 測試目錄 (TDD 測試案例與 Test Runner)
│   ├── run_tests.ahk     # 自動化測試執行器入口
│   ├── test_utils.ahk    # utils.ahk 單元測試集
│   ├── test_window_control.ahk # window_control.ahk 單元測試集
│   └── helpers/          # 測試輔助模組 (如 Assert 斷言庫)
│       └── assert.ahk
├── logs/                 # 執行日誌輸出
├── 熱門排行/             # "熱門排行"所有項目匯出檔
└── 盤後排行/             # "盤後排行"所有項目匯出檔

```

---

## 核心功能規劃 (Roadmap & Feature List)

- [x] **視窗啟動與鎖定**：偵測「三竹股市電腦版」是否已開啟，若否則自動啟動。
- [ ] **熱門排行**：對「證劵行情」→「熱門排行」的所有項目均執行匯出檔案。
- [ ] **盤後排行**：對「證劵行情」→「盤後排行」的所有項目均執行匯出檔案。

---

## 快速開始 (Quick Start)

1. 安裝 [AutoHotkey v2](https://www.autohotkey.com/)。
2. 檢查或編輯 `config/settings.ini` 中的執行檔路徑 (預設: `D:\Program Files\MitakeGU\三竹股市.exe`)。
3. 執行主腳本 `Mitake.ahk`。
4. 使用快捷鍵 `Ctrl + Alt + M` 或點擊托盤圖示菜單「啟動/切換 三竹股市」即可自動開啟或切換至三竹股市視窗。

---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。

```
`config\settings.ini`:

```ini
[App]
Path = D:\Program Files\MitakeGU\三竹股市.exe
ProcessName = 三竹股市.exe
WinTitle = ahk_exe 三竹股市.exe
Timeout = 15

[Hotkey]
LaunchHotkey = ^!m
MenuBarHotkey = ^!b

[MenuBar]
TriggerMode = click
TriggerKey = {Alt}
ClickX = 35
ClickY = 45
[SecuritiesQuote]
ClickX = 120
ClickY = 45

[PopularRanking]
ClickX = 120
ClickY = 80

```
`lib\utils.ahk`:

```ahk
#Requires AutoHotkey v2.0

/**
 * 確保 INI 設定檔使用 UTF-16 LE 編碼，以支援 Windows API (GetPrivateProfileStringW) 正確讀取中文
 * @param {String} iniPath INI 檔案路徑
 */
EnsureIniEncoding(iniPath) {
    if !FileExist(iniPath)
        return
    try {
        rawBuf := FileRead(iniPath, "RAW")
        if rawBuf.Size >= 2 && NumGet(rawBuf, 0, "UChar") == 0xFF && NumGet(rawBuf, 1, "UChar") == 0xFE {
            return ; 已經是 UTF-16 LE (BOM: FF FE)
        }
        ; 若不是 UTF-16 LE，依 UTF-8 讀取並重新轉存為 UTF-16 LE
        content := FileRead(iniPath, "UTF-8")
        f := FileOpen(iniPath, "w", "UTF-16")
        f.Write(content)
        f.Close()
    } catch {
        ; 發生例外時不中斷主流程
    }
}

/**
 * 取得設定檔內容
 * @param {String} section 區段名稱
 * @param {String} key 鍵名
 * @param {String} defaultValue 預設值
 * @returns {String} 設定值
 */
GetConfig(section, key, defaultValue := "") {
    static iniPath := A_ScriptDir "\config\settings.ini"
    if !FileExist(iniPath) {
        return defaultValue
    }
    EnsureIniEncoding(iniPath)
    try {
        val := IniRead(iniPath, section, key, defaultValue)
        return val != "" ? val : defaultValue
    } catch {
        return defaultValue
    }
}

/**
 * 記錄執行日誌
 * @param {String} msg 訊息內容
 * @param {String} level 日誌等級 (INFO, WARN, ERROR)
 */
LogMessage(msg, level := "INFO") {
    static logDir := A_ScriptDir "\logs"
    static logFile := logDir "\app.log"
    
    if !DirExist(logDir) {
        DirCreate(logDir)
    }
    
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    logLine := Format("[{1}] [{2}] {3}`n", timestamp, level, msg)
    
    try {
        FileAppend(logLine, logFile, "`n UTF-8")
    }
    OutputDebug(logLine)
}

/**
 * 讀取顯示器解析度與邊界資訊
 * @param {Integer} monitorNum 顯示器編號 (0 代表主顯示器，1..N 代表指定顯示器)
 * @returns {Object} 包含 width, height, left, top, right, bottom, isPrimary, str 的物件
 */
GetDisplayResolution(monitorNum := 0) {
    primaryIndex := MonitorGetPrimary()
    
    if (monitorNum == 0) {
        targetMonitor := primaryIndex
    } else {
        targetMonitor := monitorNum
    }
    
    if MonitorGet(targetMonitor, &left, &top, &right, &bottom) {
        w := right - left
        h := bottom - top
        return {
            width: w,
            height: h,
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            isPrimary: (targetMonitor == primaryIndex),
            str: Format("{1}x{2}", w, h)
        }
    } else {
        return {
            width: 0,
            height: 0,
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            isPrimary: false,
            str: "0x0"
        }
    }
}

/**
 * 取得所有顯示器的解析度資訊列表
 * @returns {Array} 顯示器資訊物件陣列
 */
GetAllDisplaysResolution() {
    count := MonitorGetCount()
    displays := []
    
    Loop count {
        displays.Push(GetDisplayResolution(A_Index))
    }
    
    return displays
}

/**
 * 檢查指定的解析度字串是否為允許的解析度之一
 * @param {String} resStr 解析度字串 (例: "1920x1080")
 * @param {Array} allowedResolutions 支援的解析度清單 (預設為 ["1920x1080", "2560x1440"])
 * @returns {Boolean} 是否支援
 */
IsSupportedDisplayResolution(resStr, allowedResolutions := "") {
    if (allowedResolutions == "") {
        allowedResolutions := ["1920x1080", "2560x1440"]
    }
    for item in allowedResolutions {
        if (item == resStr) {
            return true
        }
    }
    return false
}

/**
 * 驗證目前主顯示器的解析度是否符合系統需求
 * @param {Boolean} showMsgBox 是否在解析度不符合時彈出提示視窗 (預設為 true)
 * @returns {Boolean} 符合需求傳回 true，否則傳回 false
 */
ValidatePrimaryDisplayResolution(showMsgBox := true) {
    res := GetDisplayResolution(0) ; 0 為主顯示器
    if IsSupportedDisplayResolution(res.str) {
        return true
    }
    
    errMsg := Format("顯示器解析度錯誤：主顯示器解析度為 {1}。`n本軟體僅於主顯示器解析度為 1920x1080 或 2560x1440 時繼續執行。", res.str)
    LogMessage(errMsg, "ERROR")
    
    if (showMsgBox) {
        MsgBox(errMsg, "顯示器解析度錯誤", "Icon!")
    }
    return false
}



```
`lib\window_control.ahk`:

```ahk
#Requires AutoHotkey v2.0

/**
 * 檢查三竹股市是否正在執行
 * @returns {Boolean} 是否在執行中
 */
IsMitakeRunning() {
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    
    return (WinExist(winTitle) || ProcessExist(procName)) ? true : false
}

/**
 * 啟動並定位「三竹股市電腦版」
 * @param {String} customPath 可選的自訂執行檔路徑
 * @returns {Boolean} 啟動或聚焦是否成功
 */
LaunchMitakeStock(customPath := "") {
    ; 0. 驗證主顯示器解析度 (僅支援 1920x1080 或 2560x1440)
    if !ValidatePrimaryDisplayResolution(true) {
        return false
    }

    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    timeoutStr := GetConfig("App", "Timeout", "15")
    timeout := Integer(timeoutStr)

    ; 1. 若已經在執行，直接切換至前台並顯示
    if WinExist(winTitle) {
        LogMessage("三竹股市已在執行中，正在切換至前台...", "INFO")
        ActivateMitake()
        return true
    } else if ProcessExist(procName) {
        LogMessage("檢測到三竹股市程序運作中，等待視窗出現...", "INFO")
        if WinWait(winTitle, , 5) {
            ActivateMitake()
            return true
        }
    }

    ; 2. 確定執行檔路徑
    targetPath := customPath != "" ? customPath : GetConfig("App", "Path", "D:\Program Files\MitakeGU\三竹股市.exe")

    if !FileExist(targetPath) {
        errMsg := Format("找不到三竹股市執行檔: {1}", targetPath)
        LogMessage(errMsg, "ERROR")
        MsgBox(errMsg "`n請確認安裝路徑或至 config/settings.ini 設定。", "錯誤", "Icon!")
        return false
    }

    ; 3. 執行程式
    LogMessage(Format("正在啟動三竹股市: {1}", targetPath), "INFO")
    SplitPath(targetPath, &fileName, &dirPath)
    
    try {
        Run(targetPath, dirPath)
    } catch as err {
        LogMessage(Format("啟動失敗: {1}", err.Message), "ERROR")
        MsgBox(Format("無法啟動三竹股市：{1}", err.Message), "啟動失敗", "Icon!")
        return false
    }

    ; 4. 等待視窗開啟
    if WinWait(winTitle, , timeout) {
        LogMessage("三竹股市已成功啟動並開啟視窗。", "INFO")
        ActivateMitake()
        return true
    } else {
        LogMessage(Format("啟動三竹股市超時 ({1} 秒內未偵測到視窗)。", timeout), "WARN")
        return false
    }
}

/**
 * 聚焦並永遠將「三竹股市」視窗最大化
 * @param {Integer|String} target 視窗 HWND 或 WinTitle (0 代表預設/所有三竹股市視窗)
 */
ActivateMitake(target := 0) {
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    
    if (target != 0) {
        if WinExist(target) {
            WinActivate(target)
            WinMaximize(target)
            LogMessage("已將指定的三竹股市視窗切換至最前台並最大化。", "INFO")
        }
        return
    }
    
    if WinExist(winTitle) {
        winList := WinGetList(winTitle)
        for hwnd in winList {
            try {
                WinMaximize(hwnd)
            }
        }
        WinActivate(winTitle)
        WinMaximize(winTitle)
        LogMessage("已將三竹股市視窗切換至最前台並全數最大化。", "INFO")
    }
}

/**
 * 切換或開啟「三竹股市電腦版」選單列 (Menu Bar)
 * 由於三竹股市電腦版採用自訂 GUI 介面，非標準 Win32 選單列，
 * 本函式支援聚焦視窗後傳送選單快捷鍵、相對座標點擊或圖像辨識定位點擊。
 * @returns {Boolean} 執行是否成功
 */
ToggleMitakeMenuBar() {
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    
    if !WinExist(winTitle) {
        LogMessage("切換選單列失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ActivateMitake()
    
    ; 讀取設定檔中的觸發模式 (key, click, image)
    mode := GetConfig("MenuBar", "TriggerMode", "click")
    clickMethod := GetConfig("App", "ClickMethod", "physical")
    
    if (mode == "image") {
        res := GetDisplayResolution(0)
        imgPath := Format("assets/{1}/menu.png", res.str)
        if !FileExist(imgPath) {
            imgPath := Format("assets/menu_{1}.png", res.str)
        }
        if !FileExist(imgPath) {
            imgPath := GetConfig("MenuBar", "ImagePath", "assets/1920x1080/menu.png")
        }
        imgRes := FindAndClickImage(imgPath)
        if imgRes.found {
            return true
        } else {
            ; 影像辨識退回預設座標點擊
            clickX := Integer(GetConfig("MenuBar", "ClickX", "35"))
            clickY := Integer(GetConfig("MenuBar", "ClickY", "45"))
            if (clickMethod == "control") {
                ControlClick(Format("X{1} Y{2}", clickX, clickY), winTitle)
            } else {
                oldMouse := CoordMode("Mouse", "Client")
                WinActivate(winTitle)
                MouseMove(clickX, clickY, 0)
                Click(clickX, clickY)
                CoordMode("Mouse", oldMouse)
            }
            LogMessage(Format("圖像搜尋未找到，降級採用座標點擊 (X:{1}, Y:{2})", clickX, clickY), "WARN")
            return true
        }
    } else if (mode == "click") {
        ; 模擬點擊選單按鈕 (預設座標可由 settings.ini 自訂)
        clickX := Integer(GetConfig("MenuBar", "ClickX", "35"))
        clickY := Integer(GetConfig("MenuBar", "ClickY", "45"))
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), winTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            WinActivate(winTitle)
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("已對三竹股市視窗進行選單點擊 (X:{1}, Y:{2})", clickX, clickY), "INFO")
    } else {
        ; 傳送選單按鍵 (預設傳送 Alt 鍵)
        triggerKey := GetConfig("MenuBar", "TriggerKey", "{Alt}")
        Send(triggerKey)
        LogMessage(Format("已發送選單列快捷鍵: {1}", triggerKey), "INFO")
    }
    
    return true
}

/**
 * 取得圖像寬度與高度
 * @param {String} imagePath 圖像路徑
 * @param {VarRef} width 傳出寬度
 * @param {VarRef} height 傳出高度
 */
GetImageSize(imagePath, &width, &height) {
    width := 20, height := 20
    if !FileExist(imagePath)
        return
    try {
        g := Gui()
        pic := g.Add("Pic",, imagePath)
        ControlGetPos(,, &w, &h, pic.Hwnd)
        g.Destroy()
        if (w > 0 && h > 0) {
            width := w
            height := h
        }
    } catch {
        width := 20, height := 20
    }
}

/**
 * 透過 ImageSearch 尋找目標圖像按鈕並點擊圖案中心點
 * @param {String} imagePath 圖像檔案路徑
 * @param {Integer} winX1 搜尋區域左上 X
 * @param {Integer} winY1 搜尋區域左上 Y
 * @param {Integer} winX2 搜尋區域右下 X
 * @param {Integer} winY2 搜尋區域右下 Y
 * @param {Integer} variation 色彩容許度 (0-255)
 * @returns {Object} {found: Boolean, x: Integer, y: Integer}
 */
FindAndClickImage(imagePath, winX1 := 0, winY1 := 0, winX2 := 1200, winY2 := 400, variation := 30) {
    if !FileExist(imagePath) {
        LogMessage(Format("找不到搜尋圖像檔案: {1}", imagePath), "WARN")
        return {found: false, x: 0, y: 0}
    }
    
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    if !WinExist(winTitle) {
        return {found: false, x: 0, y: 0}
    }
    
    ActivateMitake()
    
    oldPixel := CoordMode("Pixel", "Client")
    oldMouse := CoordMode("Mouse", "Client")
    
    try {
        searchSpec := Format("*{} {}", variation, imagePath)
        
        if ImageSearch(&foundX, &foundY, winX1, winY1, winX2, winY2, searchSpec) {
            GetImageSize(imagePath, &imgW, &imgH)
            targetX := foundX + (imgW // 2)
            targetY := foundY + (imgH // 2)
            
            clickMethod := GetConfig("App", "ClickMethod", "physical")
            
            if (clickMethod == "control") {
                ControlClick(Format("X{} Y{}", targetX, targetY), winTitle)
            } else {
                ; 實體滑鼠移動與點擊 (自訂繪製視窗必備)
                WinActivate(winTitle)
                MouseMove(targetX, targetY, 0)
                Click(targetX, targetY)
            }
            
            LogMessage(Format("圖像辨識成功 ({1})，圖案尺寸({2}x{3})，已用[{4}]點擊中心座標 ({5}, {6})", imagePath, imgW, imgH, clickMethod, targetX, targetY), "INFO")
            
            CoordMode("Pixel", oldPixel)
            CoordMode("Mouse", oldMouse)
            return {found: true, x: targetX, y: targetY}
        }
    } catch as err {
        LogMessage(Format("ImageSearch 執行異常: {1}", err.Message), "WARN")
    }
    
    CoordMode("Pixel", oldPixel)
    CoordMode("Mouse", oldMouse)
    LogMessage(Format("圖像辨識未找到匹配項目: {1}", imagePath), "WARN")
    return {found: false, x: 0, y: 0}
}

/**
 * 點擊「三竹股市」選單列的「證券行情」項目
 * 參照 assets/{resolution}/menu_證券行情.png (如 assets/1920x1080/menu_證券行情.png) 進行圖像辨識定位與點擊
 * @returns {Boolean} 點擊是否成功
 */
ClickSecuritiesQuoteMenu() {
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    
    if !WinExist(winTitle) {
        LogMessage("點擊證券行情失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ActivateMitake()
    
    res := GetDisplayResolution(0)
    imgPath := Format("assets/{1}/menu_證券行情.png", res.str)
    if !FileExist(imgPath) {
        imgPath := Format("assets/menu_證券行情_{1}.png", res.str)
    }
    if !FileExist(imgPath) {
        imgPath := "assets/1920x1080/menu_證券行情.png"
    }
    
    imgRes := FindAndClickImage(imgPath, 0, 0, 1200, 350, 30)
    if imgRes.found {
        LogMessage("已成功透過圖像辨識點擊「證券行情」。", "INFO")
        return true
    } else {
        ; 影像搜尋若未比對成功，降級採用預設相對座標點擊
        clickX := Integer(GetConfig("SecuritiesQuote", "ClickX", "120"))
        clickY := Integer(GetConfig("SecuritiesQuote", "ClickY", "45"))
        clickMethod := GetConfig("App", "ClickMethod", "physical")
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), winTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            WinActivate(winTitle)
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("圖像辨識點擊「證券行情」未比對到 ({1})，降級採用座標點擊 (X:{2}, Y:{3})", imgPath, clickX, clickY), "WARN")
        return true
    }
}

/**
 * 對「三竹股市」視窗點擊選單列「證券行情」→「熱門排行」
 * 參照 assets/{resolution}/熱門排行.png (如 assets/1920x1080/熱門排行.png) 進行圖像辨識定位與點擊
 * @returns {Boolean} 點擊是否成功
 */
ClickPopularRankingMenu() {
    winTitle := GetConfig("App", "WinTitle", "ahk_exe 三竹股市.exe")
    
    if !WinExist(winTitle) {
        LogMessage("點擊熱門排行失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ActivateMitake()
    
    ; 1. 先點擊選單列「證券行情」
    if !ClickSecuritiesQuoteMenu() {
        LogMessage("點擊熱門排行失敗：開啟證券行情選單未成功", "WARN")
        return false
    }
    
    Sleep(300) ; 等待選單選單展開或畫面切換
    
    ; 2. 尋找與點擊「熱門排行」
    res := GetDisplayResolution(0)
    imgPath := Format("assets/{1}/熱門排行.png", res.str)
    if !FileExist(imgPath) {
        imgPath := Format("assets/熱門排行_{1}.png", res.str)
    }
    if !FileExist(imgPath) {
        imgPath := "assets/1920x1080/熱門排行.png"
    }
    
    imgRes := FindAndClickImage(imgPath, 0, 0, 1200, 500, 30)
    if imgRes.found {
        LogMessage("已成功透過圖像辨識點擊「熱門排行」。", "INFO")
        return true
    } else {
        ; 影像搜尋若未比對成功，降級採用預設相對座標點擊
        clickX := Integer(GetConfig("PopularRanking", "ClickX", "120"))
        clickY := Integer(GetConfig("PopularRanking", "ClickY", "80"))
        clickMethod := GetConfig("App", "ClickMethod", "physical")
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), winTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            WinActivate(winTitle)
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("圖像辨識點擊「熱門排行」未比對到 ({1})，降級採用座標點擊 (X:{2}, Y:{3})", imgPath, clickX, clickY), "WARN")
        return true
    }
}



```