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
│   ├── export.ahk        # 熱門排行/盤後排行匯出模組 (CSV 輪詢與複製)
│   └── utils.ahk         # 通用工具函式 (如 Log、提示訊息等)
├── tests/                # 測試目錄 (TDD 測試案例與 Test Runner)
│   ├── run_tests.ahk     # 自動化測試執行器入口
│   ├── test_utils.ahk    # utils.ahk 單元測試集
│   ├── test_window_control.ahk # window_control.ahk 單元測試集
│   ├── test_export.ahk   # export.ahk 無頭單元測試集 (暫存目錄)
│   ├── test_pop_rank_export.ahk # 熱門排行匯出手動實機驗證腳本
│   └── helpers/          # 測試輔助模組 (如 Assert 斷言庫)
│       └── assert.ahk
├── bypass.bat            # 三竹匯出後呼叫之關聯程式 (立即結束，阻止 Excel 開啟)
├── logs/                 # 執行日誌輸出
├── 熱門排行/             # "熱門排行"所有項目匯出檔 (YYYYMMDD 子資料夾)
└── 盤後排行/             # "盤後排行"所有項目匯出檔

```

---

## 核心功能規劃 (Roadmap & Feature List)

- [x] **視窗啟動與鎖定**：偵測「三竹股市電腦版」是否已開啟，若否則自動啟動。
- [x] **熱門排行**：對「證劵行情」→「熱門排行」的所有項目均執行匯出檔案。
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
   - **Send 自我觸發熱鍵陷阱**：未使用鍵盤 hook 的熱鍵（如 `Esc::`）會被同一腳本自身的 `Send("{Esc}")` 觸發。中止熱鍵若與流程中送出的按鍵相同，必須加上 `$` 前綴（`$Esc::`）強制使用 hook，否則流程會在送出按鍵的瞬間誤判為使用者中止。

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
13. **自繪清單鍵盤導航：`Home` 失效時的 `PageUp` 批次歸位模式**：
   - **現象**：三竹等自訂自繪下拉選單通常未實作標準 Win32 的 `{Home}` 跳至首項行為，發送 `{Home}` 鍵完全被忽略。當展開選單時游標停留在前次選定項目，直接執行 `(ItemNo - 1)` 次 `{Down}` 會造成游標累積位移錯亂，執行數十項時反覆停滯在最末項。
   - **解決方案**：改用多次（如 5 次）`Send("{PgUp}")` 向上翻頁作為首項歸位機制，百分之百保證游標穩定回到第 1 項，再向下按 `{Down}` 遞增定位。
14. **滑鼠停懸 (Hover) 狀態干擾與純淨影像裁切準則 (Tight Cropping)**：
   - **Hover 色偏陷阱**：滑鼠點擊下拉箭頭或按鈕後若游標停留在原地，元件會進入 Hover 高亮狀態（底色、邊框或反鋸齒陰影變更），導致後續搜尋原始未停懸圖檔時引發連鎖式匹配失敗。
   - **防護措施**：點擊任何按鈕或確認選取後，立即將游標移至視窗角落空白區（如 `(10, 10)`）解除 Hover 狀態。
   - **圖檔純淨度**：截取資產圖檔時嚴禁包含周圍易隨視窗狀態或主題色變更的外圍邊界（如標題列藍條、外部黑邊），應僅保留按鈕核心圖示（如 24x30 純圖示），確保各狀態下最高的辨識穩定度。
15. **自動化批次重試之乾淨狀態復原 (Clean State Reset)**：
   - 當單一項目執行失敗進入重試循環時，若前一次殘留的自繪下拉浮層仍呈展開狀態，直接重新點擊會點在浮層上遮擋底層控制項，引發連鎖失敗。
   - **解決方案**：在每次進入重試或單項操作開頭，必須呼叫狀態復原常式（`ResetPopRankState`）：送出 `{Esc}` 強制關閉可能殘留的自繪浮層，並移開游標，確保每次重試均處於乾淨的基準環境。

### 五、 測試架構與實機驗證工具隔離 (Test Architecture & Tooling)

16. **資料驅動測試套件重構 (Data-Driven Test Suite Pattern)**：
   - 多解析度、多資產與多座標的驗證若逐條複製貼上斷言，會導致測試代碼膨脹且難以擴展。
   - 解決方案：改採資料驅動測試結構，以案例陣列（`cases := [{...}]`）配合迴圈動態檢驗，不僅提升測試可讀性與擴展性，也能輸出更具語意化的動態失敗除錯訊息。
17. **無頭自動化測試與手動實機驗證工具之架構隔離**：
   - **無頭自動化測試**：`tests/run_tests.ahk` 作為持續整合與版本回歸閘門，必須保持純淨、快速且無阻斷式彈窗；業務函式應提供 UI 抑制參數（`showMsgBox := false`）。
   - **手動實機驗證工具**：涉及真實桌面焦點切換、滑鼠軌跡與確認彈窗的實機校正需求，應獨立建置專用腳本（`tests/test_coords_click.ahk`），搭配平滑游標移動（`MouseMove(x, y, 10)`）與 `ToolTip` 浮動標籤提示目標名稱與落點座標，兼顧除錯直觀性而不干擾全域測試。
18. **背景 Session 與互動式桌面隔離限制 (Session Isolation & UIPI)**：
   - 命令列終端（PowerShell / 背景 Task）受限於 Windows Session 隔離機制，無法直接枚舉或控制真實使用者互動桌面上的 GUI 視窗（`WinGetList` / `WinActive` 會回傳 0）。
   - 單元測試焦點切換應以 `WinExist` 及函式回傳值驗證，避免依賴無桌面環境下的 `WinActive`；定位疑難問題時，以實體執行日誌 `logs/app.log` 留下的真實軌跡為準。


---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。

