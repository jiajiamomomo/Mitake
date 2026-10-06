Project Path: 三竹

Source Tree:

```txt
三竹
├── ABBREVIATIONS.md
├── Mitake.ahk
├── README.md
├── agents.md
├── assets
│   ├── 1920x1080
│   │   ├── menu_證券行情.png
│   │   ├── 熱門排行.png
│   │   └── 盤後排行.png
│   └── 2560x1440
│       ├── menu_證券行情.png
│       ├── 熱門排行.png
│       └── 盤後排行.png
├── bypass.bat
├── config
│   └── settings.ini
├── lib
│   ├── utils.ahk
│   └── window_control.ahk
├── tests
├── 熱門排行
└── 盤後排行

```

`ABBREVIATIONS.md`:

```md
# AutoHotkey 變數與函式縮寫對照表 (Naming Abbreviations)

本專案遵循此縮寫對照表以維持命名一致性與簡潔性。

---

## 1. 核心字彙縮寫規則 (Core Words)

| 原詞 (Original) | 縮寫 (Abbreviation) | 範例說明 |
| :--- | :--- | :--- |
| Window | `Win` | `WinTitle`, `mainWin` |
| Process | `Proc` | `procName` |
| Image | `Img` | `imgPath`, `imgRes`, `imgW`, `imgH` |
| Configuration / Config | `Cfg` | `GetCfg`, `procCfg` |
| Display / Resolution | `Res` | `GetRes`, `GetAllRes`, `IsSupportedRes` |
| Primary | `Pri` | `priIdx`, `ValidatePriRes` |
| Coordinate / Coordinates | `Coord` / `Coords` | `GetResCoords` |
| Message | `Msg` | `LogMsg`, `errMsg`, `ShellMsg` |
| Default | `Def` | `defVal`, `defX`, `defY` |
| Target | `Tgt` | `tgtWin`, `tgtPath`, `tgtRes`, `tgtMon` |
| Directory | `Dir` | `logDir`, `dirPath`, `GetRootDir` |
| Hotkey | `HK` | `launchHk`, `menubarHk`, `HkLaunch` |
| Handler | `Hnd` | `MenuLaunchHnd`, `HkLaunchHnd` |
| Popular Ranking (熱門排行) | `PopRank` | `GetPopRankWinTitle`, `ClickPopRankMenu` |
| After-Market Ranking (盤後排行) | `AfterRank` | `GetAfterRankWinTitle`, `ClickAfterRankMenu` |
| Securities Quote (證券行情) | `SecQuote` | `ClickSecQuoteMenu` |
| Menu Bar | `MenuBar` | `ToggleMenuBar` |
| Mitake (三竹股市) | `Mitake` | `IsMitakeRunning`, `LaunchMitake` |

---

## 2. 函式名稱對照表 (Functions)

### `lib/utils.ahk`
| 原函式名 | 新縮短函式名 | 說明 |
| :--- | :--- | :--- |
| `EnsureIniEncoding` | `EnsureIniEnc` | 確保 INI 使用 UTF-16 LE 編碼 |
| `GetConfig` | `GetCfg` | 讀取 INI 設定檔內容 |
| `LogMessage` | `LogMsg` | 寫入執行日誌 |
| `GetProjectRootDir` | `GetRootDir` | 取得專案根目錄 |
| `GetDisplayResolution` | `GetRes` | 取得指定/主顯示器解析度資訊 |
| `GetAllDisplaysResolution` | `GetAllRes` | 取得所有顯示器解析度列表 |
| `IsSupportedDisplayResolution` | `IsSupportedRes` | 檢查解析度是否受支援 |
| `ValidatePrimaryDisplayResolution` | `ValidatePriRes` | 驗證主顯示器解析度 |

### `lib/window_control.ahk`
| 原函式名 | 新縮短函式名 | 說明 |
| :--- | :--- | :--- |
| `GetMainWindowTitle` | `GetMainWinTitle` | 取得三竹主視窗 WinTitle |
| `GetPopularRankingWindowTitle` | `GetPopRankWinTitle` | 取得「熱門排行」視窗 WinTitle |
| `GetAfterMarketRankingWindowTitle` | `GetAfterRankWinTitle` | 取得「盤後排行」視窗 WinTitle |
| `FindMitakeWindow` | `FindMitakeWin` | 尋找三竹股市相關視窗 HWND |
| `ClickClientPoint` | `ClickPoint` | 視窗客戶區座標點擊 (支援 control 與 physical) |
| `SwitchToMainWindow` | `SwitchToMainWin` | 切換至主程式視窗 |
| `IsMitakeRunning` | `IsMitakeRunning` | 檢查三竹股市是否執行中 |
| `LaunchMitakeStock` | `LaunchMitake` | 啟動或聚焦三竹股市 |
| `ActivateMitake` | `ActivateMitake` | 聚焦並最大化指定視窗 |
| `ToggleMitakeMenuBar` | `ToggleMenuBar` | 切換或開啟選單列 |
| `GetImageSize` | `GetImgSize` | 取得圖檔寬度與高度 |
| `FindAndClickImage` | `FindClickImg` | 影像搜尋並點擊中心點 |
| `GetAssetImagePath` | `GetAssetImgPath` | 取得資產圖檔路徑 |
| `GetResolutionClickCoords` | `GetResCoords` | 取得指定解析度點擊座標 |
| `ClickSecuritiesQuoteMenu` | `ClickSecQuoteMenu` | 點擊「證券行情」選單 |
| `ClickRankingMenu` | `ClickRankMenu` | 通用點擊「證券行情」下拉排行項目並等待視窗 |
| `ClickPopularRankingMenu` | `ClickPopRankMenu` | 點擊「熱門排行」選單 |
| `ClickAfterMarketRankingMenu` | `ClickAfterRankMenu` | 點擊「盤後排行」選單 |
| `SwitchToSubWindow` | `SwitchToSubWin` | 通用切換或開啟子視窗 |
| `SwitchToPopularRankingWindow` | `SwitchToPopRankWin` | 切換至「熱門排行」視窗 |
| `SwitchToAfterMarketRankingWindow` | `SwitchToAfterRankWin` | 切換至「盤後排行」視窗 |

### `Mitake.ahk` (Handlers & Helpers)
| 原名稱 | 新縮短名稱 | 說明 |
| :--- | :--- | :--- |
| `RegisterHotkey` | `RegisterHk` | 註冊快捷鍵設定與日誌記錄輔助函式 |
| `ShellMessage` | `ShellMsg` | ShellHook 監聽處理常式 |
| `MenuLaunchHandler` | `MenuLaunchHnd` | 托盤「啟動/切換 三竹股市」處理函式 |
| `MenuToggleMenuBarHandler` | `MenuToggleBarHnd` | 托盤「切換選單列」處理函式 |
| `MenuClickSecuritiesQuoteHandler` | `MenuSecQuoteHnd` | 托盤「證券行情」處理函式 |
| `MenuClickPopularRankingHandler` | `MenuPopRankHnd` | 托盤「熱門排行」處理函式 |
| `MenuClickAfterMarketRankingHandler` | `MenuAfterRankHnd` | 托盤「盤後排行」處理函式 |
| `MenuShowResolutionHandler` | `MenuShowResHnd` | 托盤「顯示解析度」處理函式 |
| `HotkeyLaunchHandler` | `HkLaunchHnd` | 快捷鍵啟動處理函式 |
| `HotkeyMenuBarHandler` | `HkMenuBarHnd` | 快捷鍵選單列處理函式 |
| `HotkeySecuritiesQuoteHandler` | `HkSecQuoteHnd` | 快捷鍵證券行情處理函式 |
| `HotkeyPopularRankingHandler` | `HkPopRankHnd` | 快捷鍵熱門排行處理函式 |
| `HotkeyAfterMarketRankingHandler` | `HkAfterRankHnd` | 快捷鍵盤後排行處理函式 |

```
`Mitake.ahk`:

```ahk
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

本專案使用中文字串(如 '三竹股市.exe')，請避免編碼解析異常，建議採用UTF-8；在 PowerShell 終端機執行指令時，需將 `[Console]::OutputEncoding` 設為 UTF-8，以便終端機正常顯示與避免亂碼。

使用Jujutsu(jj)配合GitHub作版本管理。每次執行 `jj git push` 之前，務必先運行 `code2prompt . -e "tests/**" -e "prompt.md" -O prompt.md`。

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
├── ABBREVIATIONS.md      # 變數與函式命名縮寫對照表
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

## 開發與踩坑注意事項 (Lessons Learned & Best Practices)

### 一、 檔案編碼與 CLI 執行環境 (Encoding & Environment)

1. **檔案編碼診斷與 INI 設定檔限制**：
   - **編碼診斷**：文字或設定檔出現亂碼時，優先檢查二進位標頭 (Magic Bytes / BOM)：`[System.IO.File]::ReadAllBytes(...)`，切勿僅依終端文字猜測（`FF FE` 為 UTF-16 LE；`EF BB BF` 為 UTF-8 with BOM）。
   - **Windows INI API 限制**：Windows 原生 API (`GetPrivateProfileStringW` / AHK `IniRead`) 讀取中文僅支援 **UTF-16 LE (含 BOM)** 或 ANSI；若存為無 BOM 的 UTF-8 會被視為 ANSI (CP950) 解析導致亂碼。設定檔需由 `EnsureIniEnc()` 嚴格維護為 UTF-16 LE。
   - **文字工具相容性**：部分 CLI/AI 工具僅支援 UTF-8，遇到 UTF-16 LE 會誤判二進位。檢視或編輯時應透過 PowerShell 指定編碼（`Get-Content -Encoding Unicode ...`）或腳本專用轉換函式，切勿直接以純文字工具覆寫，以免遺失 BOM。
2. **PowerShell 與 CLI 執行環境注意事項**：
   - **命令路徑完整性**：所有 AHK 指令一律使用完整路徑（如 `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"`）執行，避免環境未將其加入全域 PATH 而拋出 `CommandNotFoundException`。
   - **終端編碼與語法**：在 PowerShell 執行指令前確保 `[Console]::OutputEncoding = UTF-8`；Jujutsu 的修訂符號 `@` 需以引號包裹（如 `jj bookmark set main -r "@"`）；多行腳本使用 Here-String (`@' ... '@`)。
   - **主控台輸出捕捉**：`AutoHotkey64.exe` 為 GUI 程序（`SUBSYSTEM_WINDOWS`），預設未附加輸出緩衝區；CLI 捕捉 stdout 務必附加 `/ErrorStdOut` 參數；動態執行腳本需透過管道傳入標準輸入並指定 `*`（因 AHK 無 `/e` 參數）；等待 GUI 程序結束並獲取 ExitCode 應使用 `Start-Process ... -NoNewWindow -PassThru -Wait`。

### 二、 設定檔驅動與領域架構邊界 (Configuration-Driven & Architecture)

3. **多解析度設定檔驅動與預設值邊界原則**：
   - **多解析度集中管理**：各解析度點擊像素座標一律於 `config/settings.ini` 以 `ClickX_{Resolution}` 與 `ClickY_{Resolution}` 維護，全權由 `GetResCoords(section)` 依主顯示器解析度動態讀取。
   - **選用配置 vs 領域必要配置之預設值邊界**：
     - 基礎設施通用原語 `GetCfg(section, key, defVal := "")` 保留 `defVal` 是合理且必要的，用以支援「選用配置」（如熱鍵、逾時秒數）之「約定優於配置（Convention over Configuration）」。
     - **反模式**：切勿將高度特異、不可隨意推導的「領域關鍵配置」（如按鈕像素座標）隨手在呼叫端寫死一份當作 `defVal` 或寫死條件分支（如 `(res.str == "1920x1080") ? 77 : 78`）。這會引發**雙重真實來源（Two Sources of Truth）**，並在設定檔遺失或失效時造成**靜默錯誤遮蔽（Silent Failure Masking）**。
     - **解決方案**：關鍵必要配置應由設定檔動態驅動或回傳中性無效值（如 `x: 0, y: 0`）並記錄警告日誌，讓呼叫端安全退回圖像辨識（ImageSearch）比對，而非盲目點擊錯誤的像素。
4. **重構中「差異參數化」之洩漏抽象反模式 (Parameterization of Differences)**：
   - 當多段重複代碼存在細微差異時，重構初期的直覺通常是「找出相異處並抽成參數由呼叫端傳入」。
   - 陷阱：若該差異本質上是系統配置（如座標、逾時時間），將其粗暴提為呼叫端參數，只會將寫死的魔術數字與分支邏輯由被呼叫端轉移至呼叫端，造成呼叫端承擔不必要的配置知識（Feature Envy / Leaky Abstraction）。
   - 解決方案：重構重複代碼時，優先探究「差異資料的來源與權威真相（SSOT）在哪裡？」，讓共用核心直接向權威資料源（如 INI 設定檔）查詢，而非逼迫上層呼叫端當傳話筒。

### 三、 AutoHotkey v2 語言特性與重構模式 (Language & Patterns)

5. **跨模組重構之單一真實來源與命名同步 (SSOT & Identifier Sync)**：
   - AHK v2 於載入期進行靜態檢查。當多個檔案彼此 `#Include`，若將通用函式（如 `GetRootDir`）下沉至共用底層模組（`lib/utils.ahk`）時，必須徹底清理高層模組的原有定義，否則編譯載入期會直接引發致命錯誤 `Duplicate function definition`。
   - 跨模組重構識別碼時，務必建立專案級縮寫對照表（[ABBREVIATIONS.md](file:///d:/DJC/TEST/%E4%B8%89%E7%AB%B9/ABBREVIATIONS.md)），底層模組、主程式與測試集同步更新，並以 `run_tests.ahk` 作為全域回歸閘門驗證 0 錯誤。
6. **一級函式與表驅動註冊模式 (Table-Driven Registration)**：
   - 傳統寫法常為每個熱鍵或托盤菜單建立單行轉發函式（Proxy handlers），造成程式碼膨脹。
   - 解決方案：善用 AHK v2 一級函式與匿名胖箭頭語法（`(*) => Handler()`），搭配配置物件陣列（`[{cfg: ..., def: ..., hnd: ...}]`）進行表驅動迭代註冊，大幅縮減頂層膠水代碼。
7. **邏輯運算子短路求值與回傳型態強制收斂**：
   - AHK v2 中 `||` 與 `&&` 具短路求值特性，直接回傳命中的運算元本身（如 HWND 或 PID）。若函式宣告回傳型態為布林值（`@returns {Boolean}`），必須使用三元運算子 `(condition) ? true : false` 或 `!(...)` 明確強制收斂為布林值，避免嚴格比對時斷言失敗。
8. **生命週期常駐特性與 TDD 骨架先行原則 (Stub Skeleton)**：
   - AHK v2 腳本一旦建立了 `Gui()` 物件即自動變為常駐進程，除非在結尾明確呼叫 `ExitApp()`，否則 CLI 等待會持續掛起。
   - 實踐 TDD 紅燈階段時，由於 AHK v2 載入期會靜態驗證所有調用函式宣告，若直接調用未宣告的函式會引發 `Call to nonexistent function` 致命中斷，因此應先宣告空白骨架函式（Stub），方能順利產出完整測試報告。

### 四、 視窗控制、顯示器與自繪 UI 自動化 (Window, Display & UI Automation)

9. **階層式自繪選單之焦點保護與展開過渡延遲**：
   - **焦點干擾保護**：自繪介面點擊展開下拉選單後，若後續搜尋子項目時再次調用 `WinActivate` 或 `WinMaximize`，系統發送的重繪訊息會**立刻強制關閉已展開的下拉選單**，導致子項目圖像辨識失敗。搜尋展開的選單項目時應停用啟用邏輯（`shouldActivate := false`）。
   - **過渡展開延遲**：自繪下拉選單展開渲染需要時間（約 200~300ms）。在點擊主選單與點擊子選單之間必須插入適當緩衝延遲（如 `Sleep(300)`），避免因視覺元件尚未渲染完成而比對失敗誤觸座標備援。
10. **Windows 最小化視窗解除與前台焦點鎖定突破 (ASFW)**：
   - 對處於最小化（`WinGetMinMax == -1`）的視窗單純呼叫 `WinActivate` 無法可靠還原（常只在工作列閃爍）。
   - 解決方案：必須先調用 `WinRestore(hwnd)`，並配合 `DllCall("user32\AllowSetForegroundWindow", "Int", -1)` 與 `DllCall("user32\SetForegroundWindow", "Ptr", hwnd)` 突破前台鎖定，再進行激活與最大化。
11. **同進程多視窗之標題精確匹配與備援 (`FindMitakeWin`)**：
   - 三竹股市主程式視窗與子視窗（「熱門排行」、「盤後排行」）屬於同一程序（`三竹股市.exe`）。若僅以 `ahk_exe 三竹股市.exe` 比對，會誤抓頂層子視窗。
   - 解決方案：視窗定位應以標題精確區分（`"三竹股市"`、`"熱門排行"`、`"盤後排行"`），並統一封裝於 `FindMitakeWin(winTitle)` 中處理精確標題與進程名稱備援。
12. **顯示器邊界計算與真實物理 DPI 解析度偵測**：
   - **多螢幕邊界計算**：多螢幕環境中若副螢幕位於主螢幕左方或上方，其邊界座標可能為負數，計算寬高必須使用差值：`Width := Right - Left`、`Height := Bottom - Top`。
   - **DPI 虛擬化避坑**：透過第三方環境（如 .NET）偵測螢幕解析度時，若啟用了系統 DPI 縮放會回傳虛擬化後的邏輯尺寸。解析度偵測一律應依賴 AHK v2 原生 `MonitorGet()` 或呼叫 Win32 API 取得真實物理像素邊界。

### 五、 測試架構與實機驗證工具隔離 (Test Architecture & Tooling)

13. **資料驅動測試套件重構 (Data-Driven Test Suite Pattern)**：
   - 多解析度、多資產與多座標的驗證若逐條複製貼上斷言，會導致測試代碼膨脹且難以擴展。
   - 解決方案：改採資料驅動測試結構，以案例陣列（`cases := [{...}]`）配合迴圈動態檢驗，不僅提升測試可讀性與擴展性，也能輸出更具語意化的動態失敗除錯訊息。
14. **無頭自動化測試與手動實機驗證工具之架構隔離**：
   - **無頭自動化測試**：`tests/run_tests.ahk` 作為持續整合與版本回歸閘門，必須保持純淨、快速且無阻斷式彈窗；業務函式應提供 UI 抑制參數（`showMsgBox := false`）。
   - **手動實機驗證工具**：涉及真實桌面焦點切換、滑鼠軌跡與確認彈窗的實機校正需求，應獨立建置專用腳本（`tests/test_coords_click.ahk`），搭配平滑游標移動（`MouseMove(x, y, 10)`）與 `ToolTip` 浮動標籤提示目標名稱與落點座標，兼顧除錯直觀性而不干擾全域測試。
15. **背景 Session 與互動式桌面隔離限制 (Session Isolation & UIPI)**：
   - 命令列終端（PowerShell / 背景 Task）受限於 Windows Session 隔離機制，無法直接枚舉或控制真實使用者互動桌面上的 GUI 視窗（`WinGetList` / `WinActive` 會回傳 0）。
   - 單元測試焦點切換應以 `WinExist` 及函式回傳值驗證，避免依賴無桌面環境下的 `WinActive`；定位疑難問題時，以實體執行日誌 `logs/app.log` 留下的真實軌跡為準。


---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。


```
`bypass.bat`:

```bat
@echo off
:: 這個腳本被三竹呼叫後會直接閃退，藉此阻止 Excel 自動開啟
:: 最新生成的 CSV 檔案仍會順利保存在 MitakeGU\USER\OUT\ 資料夾中

exit

```
`config\settings.ini`:

```ini
[App]
Path = D:\Program Files\MitakeGU\三竹股市.exe
ProcessName = 三竹股市.exe
WinTitle = 三竹股市
MainWinTitle = 三竹股市
PopularRankingWinTitle = 熱門排行
AfterMarketRankingWinTitle = 盤後排行
Timeout = 15

[Hotkey]
LaunchHotkey = ^!m
MenuBarHotkey = ^!b
SecuritiesQuoteHotkey = 
PopularRankingHotkey = 
AfterMarketRankingHotkey = 

[MenuBar]
TriggerMode = click
TriggerKey = {Alt}
ClickX_1920x1080 = 35
ClickY_1920x1080 = 45
ClickX_2560x1440 = 35
ClickY_2560x1440 = 45
ClickX = 35
ClickY = 45

[SecuritiesQuote]
ClickX_1920x1080 = 337
ClickY_1920x1080 = 15
ClickX_2560x1440 = 337
ClickY_2560x1440 = 14
ClickX = 337
ClickY = 15

[PopularRanking]
ClickX_1920x1080 = 77
ClickY_1920x1080 = 80
ClickX_2560x1440 = 78
ClickY_2560x1440 = 80
ClickX = 77
ClickY = 80

[AfterMarketRanking]
ClickX_1920x1080 = 78
ClickY_1920x1080 = 110
ClickX_2560x1440 = 78
ClickY_2560x1440 = 110
ClickX = 78
ClickY = 110

```
`lib\utils.ahk`:

```ahk
#Requires AutoHotkey v2.0

/**
 * 確保 INI 設定檔使用 UTF-16 LE 編碼，以支援 Windows API (GetPrivateProfileStringW) 正確讀取中文
 * @param {String} iniPath INI 檔案路徑
 */
EnsureIniEnc(iniPath) {
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
 * 取得專案根目錄路徑
 * @returns {String} 專案根目錄絕對路徑
 */
GetRootDir() {
    static rootDir := ""
    if (rootDir != "")
        return rootDir
    
    dir := A_ScriptDir
    Loop 5 {
        if (FileExist(dir "\Mitake.ahk") || FileExist(dir "\config\settings.ini") || FileExist(dir "\assets")) {
            rootDir := dir
            return rootDir
        }
        SplitPath(dir, , &parent)
        if (parent == dir || parent == "")
            break
        dir := parent
    }
    rootDir := A_ScriptDir
    return rootDir
}

/**
 * 取得設定檔內容
 * @param {String} section 區段名稱
 * @param {String} key 鍵名
 * @param {String} defVal 預設值
 * @returns {String} 設定值
 */
GetCfg(section, key, defVal := "") {
    static iniPath := ""
    if (iniPath == "") {
        iniPath := GetRootDir() "\config\settings.ini"
    }
    if !FileExist(iniPath) {
        return defVal
    }
    EnsureIniEnc(iniPath)
    try {
        val := IniRead(iniPath, section, key, defVal)
        return val != "" ? val : defVal
    } catch {
        return defVal
    }
}

/**
 * 記錄執行日誌
 * @param {String} msg 訊息內容
 * @param {String} level 日誌等級 (INFO, WARN, ERROR)
 */
LogMsg(msg, level := "INFO") {
    static logDir := ""
    static logFile := ""
    if (logDir == "") {
        logDir := GetRootDir() "\logs"
        logFile := logDir "\app.log"
    }
    
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
 * @param {Integer} monNum 顯示器編號 (0 代表主顯示器，1..N 代表指定顯示器)
 * @returns {Object} 包含 width, height, left, top, right, bottom, isPrimary, str 的物件
 */
GetRes(monNum := 0) {
    priIdx := MonitorGetPrimary()
    tgtMon := (monNum == 0) ? priIdx : monNum
    
    if MonitorGet(tgtMon, &left, &top, &right, &bottom) {
        w := right - left
        h := bottom - top
        return {
            width: w,
            height: h,
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            isPrimary: (tgtMon == priIdx),
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
GetAllRes() {
    count := MonitorGetCount()
    displays := []
    
    Loop count {
        displays.Push(GetRes(A_Index))
    }
    
    return displays
}

/**
 * 檢查指定的解析度字串是否為允許的解析度之一
 * @param {String} resStr 解析度字串 (例: "1920x1080")
 * @param {Array} allowedRes 支援的解析度清單 (預設為 ["1920x1080", "2560x1440"])
 * @returns {Boolean} 是否支援
 */
IsSupportedRes(resStr, allowedRes := "") {
    if (allowedRes == "") {
        allowedRes := ["1920x1080", "2560x1440"]
    }
    for item in allowedRes {
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
ValidatePriRes(showMsgBox := true) {
    res := GetRes(0) ; 0 為主顯示器
    if IsSupportedRes(res.str) {
        return true
    }
    
    errMsg := Format("顯示器解析度錯誤：主顯示器解析度為 {1}。`n本軟體僅於主顯示器解析度為 1920x1080 或 2560x1440 時繼續執行。", res.str)
    LogMsg(errMsg, "ERROR")
    
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
 * 取得三竹股市主程式視窗之 WinTitle
 * @returns {String} 主程式視窗 WinTitle (預設: "三竹股市")
 */
GetMainWinTitle() {
    return GetCfg("App", "MainWinTitle", GetCfg("App", "WinTitle", "三竹股市"))
}

/**
 * 取得「熱門排行」視窗之 WinTitle
 * @returns {String} 熱門排行視窗 WinTitle (預設: "熱門排行")
 */
GetPopRankWinTitle() {
    return GetCfg("App", "PopularRankingWinTitle", "熱門排行")
}

/**
 * 取得「盤後排行」視窗之 WinTitle
 * @returns {String} 盤後排行視窗 WinTitle (預設: "盤後排行")
 */
GetAfterRankWinTitle() {
    return GetCfg("App", "AfterMarketRankingWinTitle", "盤後排行")
}

/**
 * 判斷三竹股市視窗是否應自動最大化
 * @param {String} procName 視窗所屬程序名稱
 * @param {String} winTitle 視窗標題
 * @param {String} cfgProcName 設定檔中的三竹股市程序名稱
 * @returns {Boolean} 程序符合且視窗標題非空白時回傳 true
 */
ShouldMaximizeMitakeWin(procName, winTitle, cfgProcName) {
    isMitakeProc := procName == cfgProcName
        || procName == "三竹股市.exe"
        || InStr(procName, "三竹")
    return (Trim(winTitle) != "" && isMitakeProc) ? true : false
}

/**
 * 尋找三竹股市相關視窗 HWND (支援標題精確匹配與進程名稱備援)
 * @param {String} winTitle 視窗標題 (預設為空，代表主程式視窗)
 * @returns {Integer} 視窗 HWND (若未找到則回傳 0)
 */
FindMitakeWin(winTitle := "") {
    mainTitle := GetMainWinTitle()
    tgtTitle := (winTitle != "") ? winTitle : mainTitle
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    
    hwnd := WinExist(tgtTitle)
    if (!hwnd) {
        hwnd := (tgtTitle == mainTitle) ? WinExist("ahk_exe " procName) : WinExist(tgtTitle " ahk_exe " procName)
    }
    return hwnd ? hwnd : 0
}

/**
 * 執行視窗客戶區座標點擊 (支援 control 與 physical 兩種點擊方式)
 * @param {Integer} clickX X 座標
 * @param {Integer} clickY Y 座標
 * @param {String|Integer} tgtWin 目標視窗 WinTitle 或 HWND (預設主視窗)
 * @param {Boolean} shouldActivate 是否先激活視窗 (實體滑鼠點擊時適用)
 */
ClickPoint(clickX, clickY, tgtWin := "", shouldActivate := false) {
    target := (tgtWin != "") ? tgtWin : GetMainWinTitle()
    clickMethod := GetCfg("App", "ClickMethod", "physical")
    
    if (clickMethod == "control") {
        ControlClick(Format("X{1} Y{2}", clickX, clickY), target)
    } else {
        oldMouse := CoordMode("Mouse", "Client")
        if (shouldActivate) {
            hwnd := WinExist(target)
            if (hwnd && !WinActive(hwnd)) {
                WinActivate(hwnd)
            }
        }
        MouseMove(clickX, clickY, 0)
        Click(clickX, clickY)
        CoordMode("Mouse", oldMouse)
    }
}

/**
 * 切換至三竹股市主程式視窗 (WinTitle: "三竹股市") 並置於最前台與最大化
 * 僅主程式視窗具備 menu bar，點擊 menu bar 前應先調用本函式切換到主程式視窗
 * @param {Integer} timeout 等待視窗就緒之超時秒數 (預設 3 秒)
 * @returns {Boolean} 切換是否成功
 */
SwitchToMainWin(timeout := 3) {
    mainWinTitle := GetMainWinTitle()
    hwnd := FindMitakeWin(mainWinTitle)
    
    if !hwnd {
        LogMsg(Format("切換主程式視窗失敗：未偵測到主程式視窗 [{1}]", mainWinTitle), "WARN")
        return false
    }
    
    ActivateMitake(hwnd)
    
    if WinWaitActive(hwnd, , timeout) {
        LogMsg(Format("已成功切換至主程式視窗: {1}", mainWinTitle), "INFO")
        return true
    } else {
        return WinExist(hwnd) ? true : false
    }
}

/**
 * 檢查三竹股市是否正在執行
 * @returns {Boolean} 是否在執行中
 */
IsMitakeRunning() {
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    return (FindMitakeWin() || ProcessExist(procName)) ? true : false
}

/**
 * 啟動並定位「三竹股市電腦版」
 * @param {String} customPath 可選的自訂執行檔路徑
 * @returns {Boolean} 啟動或聚焦是否成功
 */
LaunchMitake(customPath := "") {
    ; 0. 驗證主顯示器解析度 (僅支援 1920x1080 或 2560x1440)
    if !ValidatePriRes(true) {
        return false
    }

    mainWinTitle := GetMainWinTitle()
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    timeoutStr := GetCfg("App", "Timeout", "15")
    timeout := Integer(timeoutStr)

    ; 1. 若主程式視窗已經存在，切換至主程式視窗並最大化
    if WinExist(mainWinTitle) || WinExist("ahk_exe " procName) {
        LogMsg("三竹股市已在執行中，正在切換至主程式視窗...", "INFO")
        return SwitchToMainWin()
    } else if ProcessExist(procName) {
        LogMsg("檢測到三竹股市程序運作中，等待主程式視窗出現...", "INFO")
        if WinWait(mainWinTitle, , 5) || WinWait("ahk_exe " procName, , 5) {
            return SwitchToMainWin()
        }
    }

    ; 2. 確定執行檔路徑
    tgtPath := customPath != "" ? customPath : GetCfg("App", "Path", "D:\Program Files\MitakeGU\三竹股市.exe")

    if !FileExist(tgtPath) {
        errMsg := Format("找不到三竹股市執行檔: {1}", tgtPath)
        LogMsg(errMsg, "ERROR")
        MsgBox(errMsg "`n請確認安裝路徑或至 config/settings.ini 設定。", "錯誤", "Icon!")
        return false
    }

    ; 3. 執行程式
    LogMsg(Format("正在啟動三竹股市: {1}", tgtPath), "INFO")
    SplitPath(tgtPath, &fileName, &dirPath)
    
    try {
        Run(tgtPath, dirPath)
    } catch as err {
        LogMsg(Format("啟動失敗: {1}", err.Message), "ERROR")
        MsgBox(Format("無法啟動三竹股市：{1}", err.Message), "啟動失敗", "Icon!")
        return false
    }

    ; 4. 等待主程式視窗開啟 (同時兼容主標題或程序名稱)
    if WinWait(mainWinTitle, , timeout) || WinWait("ahk_exe " procName, , timeout) {
        LogMsg("三竹股市主程式視窗已成功啟動。", "INFO")
        Sleep(500)
        return SwitchToMainWin()
    } else {
        LogMsg(Format("啟動三竹股市超時 ({1} 秒內未偵測到主程式視窗)。", timeout), "WARN")
        return false
    }
}

/**
 * 聚焦並將指定視窗或三竹股市主視窗最大化
 * 若視窗處於最小化狀態則先還原；若已最大化則避免重覆最大化以防下拉選單被強制關閉
 * @param {Integer|String} target 視窗 HWND 或 WinTitle (0 代表預設主程式視窗)
 * @returns {Boolean} 是否成功激活
 */
ActivateMitake(target := 0) {
    mainWinTitle := GetMainWinTitle()
    tgtWin := (target != 0) ? target : mainWinTitle
    hwnd := (target != 0 && WinExist(target)) ? WinExist(target) : FindMitakeWin(tgtWin)
    
    if !hwnd {
        return false
    }
    
    ; 1. 若視窗處於最小化，先還原以確保正常顯示於桌面
    minMax := WinGetMinMax(hwnd)
    if (minMax == -1) {
        WinRestore(hwnd)
        Sleep(50)
    }
    
    ; 2. 設置前景焦點鎖定許可並激活視窗
    DllCall("user32\AllowSetForegroundWindow", "Int", -1)
    DllCall("user32\SetForegroundWindow", "Ptr", hwnd)
    WinActivate(hwnd)
    
    ; 3. 若未處於最大化狀態，再進行最大化，避免重覆最大化關閉已展開的選單
    if (WinGetMinMax(hwnd) != 1) {
        WinMaximize(hwnd)
    }
    
    LogMsg(Format("已將視窗 [{1}] (HWND: {2}) 切換至最前台並最大化。", tgtWin, hwnd), "INFO")
    return true
}

/**
 * 切換或開啟「三竹股市電腦版」選單列 (Menu Bar)
 * 由於三竹股市電腦版採用自訂 GUI 介面，非標準 Win32 選單列，
 * 本函式支援聚焦視窗後傳送選單快捷鍵、相對座標點擊或圖像辨識定位點擊。
 * @returns {Boolean} 執行是否成功
 */
ToggleMenuBar() {
    mainWinTitle := GetMainWinTitle()
    
    if !WinExist(mainWinTitle) && !IsMitakeRunning() {
        LogMsg("切換選單列失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ; 僅主程式視窗有 menu bar，切換至主程式視窗
    if !SwitchToMainWin() {
        return false
    }
    
    ; 讀取設定檔中的觸發模式 (key, click, image)
    mode := GetCfg("MenuBar", "TriggerMode", "click")
    
    if (mode == "image") {
        res := GetRes(0)
        imgPath := Format("assets/{1}/menu.png", res.str)
        if !FileExist(imgPath) {
            imgPath := Format("assets/menu_{1}.png", res.str)
        }
        if !FileExist(imgPath) {
            imgPath := GetCfg("MenuBar", "ImagePath", "assets/1920x1080/menu.png")
        }
        imgRes := FindClickImg(imgPath, 0, 0, 1200, 400, 30, mainWinTitle)
        if imgRes.found {
            return true
        }
        
        ; 影像辨識退回預設座標點擊
        coords := GetResCoords("MenuBar")
        ClickPoint(coords.x, coords.y, mainWinTitle, true)
        LogMsg(Format("圖像搜尋未找到，降級採用解析度 [{1}] 座標點擊 (X:{2}, Y:{3})", res.str, coords.x, coords.y), "WARN")
        return true
    } else if (mode == "click") {
        ; 模擬點擊選單按鈕 (依解析度由 settings.ini 讀取)
        res := GetRes(0)
        coords := GetResCoords("MenuBar")
        ClickPoint(coords.x, coords.y, mainWinTitle, true)
        LogMsg(Format("已對三竹股市視窗進行選單點擊 (解析度: {1}, X:{2}, Y:{3})", res.str, coords.x, coords.y), "INFO")
    } else {
        ; 傳送選單按鍵 (預設傳送 Alt 鍵)
        triggerKey := GetCfg("MenuBar", "TriggerKey", "{Alt}")
        Send(triggerKey)
        LogMsg(Format("已發送選單列快捷鍵: {1}", triggerKey), "INFO")
    }
    
    return true
}

/**
 * 取得圖像寬度與高度
 * @param {String} imgPath 圖像路徑
 * @param {VarRef} width 傳出寬度
 * @param {VarRef} height 傳出高度
 */
GetImgSize(imgPath, &width, &height) {
    width := 20, height := 20
    if !FileExist(imgPath)
        return
    try {
        g := Gui()
        pic := g.Add("Pic",, imgPath)
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
 * @param {String} imgPath 圖像檔案路徑
 * @param {Integer} winX1 搜尋區域左上 X
 * @param {Integer} winY1 搜尋區域左上 Y
 * @param {Integer} winX2 搜尋區域右下 X
 * @param {Integer} winY2 搜尋區域右下 Y
 * @param {Integer} variation 色彩容許度 (0-255)
 * @param {String} tgtWin 指定目標視窗 (若未指定則使用主程式視窗)
 * @param {Boolean} shouldActivate 是否先激活視窗 (搜尋已展開之選單時應設為 false 以免關閉選單)
 * @returns {Object} {found: Boolean, x: Integer, y: Integer}
 */
FindClickImg(imgPath, winX1 := 0, winY1 := 0, winX2 := 1200, winY2 := 400, variation := 30, tgtWin := "", shouldActivate := true) {
    if !FileExist(imgPath) {
        LogMsg(Format("找不到搜尋圖像檔案: {1}", imgPath), "WARN")
        return {found: false, x: 0, y: 0}
    }
    
    winTitle := (tgtWin != "") ? tgtWin : GetMainWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if !hwnd {
        return {found: false, x: 0, y: 0}
    }
    
    if (shouldActivate && !WinActive(hwnd)) {
        ActivateMitake(hwnd)
    }
    
    oldPixel := CoordMode("Pixel", "Client")
    
    try {
        searchSpec := Format("*{} {}", variation, imgPath)
        
        if ImageSearch(&foundX, &foundY, winX1, winY1, winX2, winY2, searchSpec) {
            GetImgSize(imgPath, &imgW, &imgH)
            targetX := foundX + (imgW // 2)
            targetY := foundY + (imgH // 2)
            
            ClickPoint(targetX, targetY, hwnd, shouldActivate)
            clickMethod := GetCfg("App", "ClickMethod", "physical")
            
            LogMsg(Format("圖像辨識成功 ({1})，圖案尺寸({2}x{3})，已用[{4}]點擊中心座標 ({5}, {6})", imgPath, imgW, imgH, clickMethod, targetX, targetY), "INFO")
            
            CoordMode("Pixel", oldPixel)
            return {found: true, x: targetX, y: targetY}
        }
    } catch as err {
        LogMsg(Format("ImageSearch 執行異常: {1}", err.Message), "WARN")
    }
    
    CoordMode("Pixel", oldPixel)
    LogMsg(Format("圖像辨識未找到匹配項目: {1}", imgPath), "WARN")
    return {found: false, x: 0, y: 0}
}

/**
 * 取得指定資產圖檔的路徑，優先匹配當前主顯示器解析度 (或指定解析度)
 * @param {String} assetName 圖檔名稱 (如 "menu_證券行情.png" 或 "盤後排行.png")
 * @param {String} tgtRes 可選的目標解析度 (例: "2560x1440" 或 "1920x1080")，預設抓取主顯示器解析度
 * @returns {String} 解析後的圖檔完整路徑
 */
GetAssetImgPath(assetName, tgtRes := "") {
    if !InStr(assetName, ".") {
        assetName .= ".png"
    }
    if (tgtRes == "") {
        res := GetRes(0)
        tgtRes := res.str
    }
    
    rootDir := GetRootDir()
    
    ; 1. 優先匹配 assets/{解析度}/{檔名} (例如 assets/2560x1440/盤後排行.png)
    p1 := rootDir "\assets\" tgtRes "\" assetName
    if FileExist(p1)
        return p1
        
    ; 2. 匹配向下相容命名 assets/{檔名無副檔名}_{解析度}.png
    nameNoExt := SubStr(assetName, 1, InStr(assetName, ".", , -1) - 1)
    p2 := rootDir "\assets\" nameNoExt "_" tgtRes ".png"
    if FileExist(p2)
        return p2
        
    ; 3. 備援尋找 2560x1440 目錄
    p3 := rootDir "\assets\2560x1440\" assetName
    if FileExist(p3)
        return p3

    ; 4. 備援尋找 1920x1080 目錄
    p4 := rootDir "\assets\1920x1080\" assetName
    if FileExist(p4)
        return p4
        
    ; 5. 備援尋找 assets/ 直屬目錄
    p5 := rootDir "\assets\" assetName
    if FileExist(p5)
        return p5
        
    ; 若皆不存在，傳回最符合預期的路徑 p1
    return p1
}

/**
 * 取得指定區段在指定解析度 (或當前主顯示器解析度) 下的降級點擊座標
 * 優先讀取 ClickX_{Resolution} / ClickY_{Resolution} (例如 ClickX_1920x1080, ClickX_2560x1440)，
 * 亦支援 {Resolution}_ClickX / {Resolution}_ClickY 命名格式，
 * 若未設定則向後相容讀取 ClickX / ClickY，最後回傳傳入之預設值。
 * @param {String} section INI 區段名稱 (例: "SecuritiesQuote", "PopularRanking", "AfterMarketRanking")
 * @param {Integer} defX 備用 X 座標預設值
 * @param {Integer} defY 備用 Y 座標預設值
 * @param {String} tgtRes 可選的目標解析度字串 (例: "1920x1080" 或 "2560x1440")，預設抓取主顯示器解析度
 * @returns {Object} {x: Integer, y: Integer}
 */
GetResCoords(section, defX := 0, defY := 0, tgtRes := "") {
    if (tgtRes == "") {
        res := GetRes(0)
        tgtRes := res.str
    }
    
    ; 1. 優先嘗試讀取 ClickX_{解析度} 或 {解析度}_ClickX
    valX := GetCfg(section, "ClickX_" tgtRes, "")
    if (valX == "") {
        valX := GetCfg(section, tgtRes "_ClickX", "")
    }
    
    valY := GetCfg(section, "ClickY_" tgtRes, "")
    if (valY == "") {
        valY := GetCfg(section, tgtRes "_ClickY", "")
    }
    
    ; 2. 若未設定，降級向後相容讀取一般通用 ClickX / ClickY
    if (valX == "") {
        valX := GetCfg(section, "ClickX", String(defX))
    }
    if (valY == "") {
        valY := GetCfg(section, "ClickY", String(defY))
    }
    
    return {x: Integer(valX), y: Integer(valY)}
}

/**
 * 點擊「三竹股市」選單列的「證券行情」項目
 * 僅主程式視窗具備 menu bar，點擊前應先切換到主程式視窗 (WinTitle: "三竹股市")
 * 參照 assets/{resolution}/menu_證券行情.png 進行圖像辨識定位與點擊
 * @returns {Boolean} 點擊是否成功
 */
ClickSecQuoteMenu() {
    mainWinTitle := GetMainWinTitle()
    
    ; 點擊 menu bar「證券行情」前應先切換到主程式視窗
    if !SwitchToMainWin() {
        LogMsg("點擊證券行情失敗：無法切換至主程式視窗", "WARN")
        return false
    }
    
    Sleep(200) ; 確保切換至主程式視窗並渲染就緒
    
    res := GetRes(0)
    imgPath := GetAssetImgPath("menu_證券行情.png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 500 : 350
    
    imgRes := FindClickImg(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    if imgRes.found {
        LogMsg("已成功透過圖像辨識點擊「證券行情」。", "INFO")
        return true
    } else {
        ; 影像搜尋若未比對成功，降級採用 settings.ini 當前解析度的相對座標點擊
        coords := GetResCoords("SecuritiesQuote")
        ClickPoint(coords.x, coords.y, mainWinTitle, false)
        LogMsg(Format("圖像辨識點擊「證券行情」未比對到 ({1})，降級採用解析度 [{2}] 座標點擊 (X:{3}, Y:{4})", imgPath, res.str, coords.x, coords.y), "WARN")
        return true
    }
}

/**
 * 通用點擊「證券行情」下拉選單之排行項目並可選等待新視窗
 * 點擊座標依據 settings.ini 中對應解析度設定自動讀取
 * @param {String} itemName 項目名稱 (例: "熱門排行"、"盤後排行")
 * @param {String} section INI 區段名稱 (例: "PopularRanking"、"AfterMarketRanking")
 * @param {String} tgtWinTitle 目標新視窗標題
 * @param {Boolean} waitNewWindow 是否等待新視窗出現
 * @param {Integer} timeout 等待超時秒數
 * @returns {Boolean} 點擊是否成功
 */
ClickRankMenu(itemName, section, tgtWinTitle, waitNewWindow := true, timeout := 5) {
    ; 1. 點擊 menu bar 前應先切換到主程式視窗並點擊「證券行情」
    if !ClickSecQuoteMenu() {
        LogMsg(Format("點擊{1}失敗：開啟證券行情選單未成功", itemName), "WARN")
        return false
    }
    
    Sleep(300) ; 等待選單展開
    
    ; 2. 尋找與點擊目標項目 (shouldActivate 設為 false，避免關閉已展開的下拉選單)
    mainWinTitle := GetMainWinTitle()
    res := GetRes(0)
    imgPath := GetAssetImgPath(itemName ".png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 750 : 500
    
    imgRes := FindClickImg(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    clicked := false
    if imgRes.found {
        LogMsg(Format("已成功透過圖像辨識點擊「{1}」。", itemName), "INFO")
        clicked := true
    } else {
        coords := GetResCoords(section)
        ClickPoint(coords.x, coords.y, mainWinTitle, false)
        LogMsg(Format("圖像辨識點擊「{1}」未比對到 ({2})，降級採用解析度 [{3}] 座標點擊 (X:{4}, Y:{5})", itemName, imgPath, res.str, coords.x, coords.y), "WARN")
        clicked := true
    }
    
    ; 3. 點擊後等待新視窗出現
    if (clicked && waitNewWindow) {
        procName := GetCfg("App", "ProcessName", "三竹股市.exe")
        hwnd := 0
        if WinWait(tgtWinTitle, , timeout) || WinWait(tgtWinTitle " ahk_exe " procName, , timeout) {
            hwnd := FindMitakeWin(tgtWinTitle)
            ActivateMitake(hwnd)
            LogMsg(Format("已偵測到「{1}」新視窗 ({2}) 並最大化顯示", itemName, tgtWinTitle), "INFO")
        } else {
            LogMsg(Format("等待「{1}」新視窗 ({2}) 出現超時 ({3} 秒)", itemName, tgtWinTitle, timeout), "WARN")
        }
    }
    
    return clicked
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「熱門排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "熱門排行"
 * 參照 assets/{resolution}/熱門排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「熱門排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickPopRankMenu(waitNewWindow := true, timeout := 5) {
    return ClickRankMenu("熱門排行", "PopularRanking", GetPopRankWinTitle(), waitNewWindow, timeout)
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「盤後排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "盤後排行"
 * 參照 assets/{resolution}/盤後排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「盤後排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickAfterRankMenu(waitNewWindow := true, timeout := 5) {
    return ClickRankMenu("盤後排行", "AfterMarketRanking", GetAfterRankWinTitle(), waitNewWindow, timeout)
}

/**
 * 切換至子視窗或點擊選單開啟新視窗
 * @param {String} winTitle 子視窗 WinTitle
 * @param {String} itemName 子視窗項目名稱
 * @param {Func} openFunc 未開啟時調用的開啟函式
 * @param {Integer} timeout 等待超時秒數
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToSubWin(winTitle, itemName, openFunc, timeout := 5) {
    hwnd := FindMitakeWin(winTitle)
    if hwnd {
        ActivateMitake(hwnd)
        LogMsg(Format("已切換至現有的「{1}」視窗: {2}", itemName, winTitle), "INFO")
        return true
    }
    
    LogMsg(Format("「{1}」視窗尚未開啟，切換至主程式點擊選單開啟...", itemName), "INFO")
    return openFunc(true, timeout)
}

/**
 * 切換至「熱門排行」視窗 (WinTitle: "熱門排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToPopRankWin(timeout := 5) {
    return SwitchToSubWin(GetPopRankWinTitle(), "熱門排行", ClickPopRankMenu, timeout)
}

/**
 * 切換至「盤後排行」視窗 (WinTitle: "盤後排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToAfterRankWin(timeout := 5) {
    return SwitchToSubWin(GetAfterRankWinTitle(), "盤後排行", ClickAfterRankMenu, timeout)
}

```