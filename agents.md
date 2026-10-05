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

1. **檔案編碼診斷原則**：
   - 遇到可疑的文字或設定檔編碼異常時，優先檢查開頭的二進位標頭 (Magic Bytes / BOM)：`[System.IO.File]::ReadAllBytes(...)`，切勿僅依賴終端機輸出文字猜測。
   - `FF FE` 為 UTF-16 LE；`EF BB BF` 為 UTF-8 with BOM。
2. **INI 設定檔編碼限制**：
   - Windows API (`GetPrivateProfileStringW` / AHK `IniRead`) 讀取中文時僅正確支援 **UTF-16 LE (含 BOM)** 或 ANSI。若儲存為無 BOM 的 UTF-8，Windows API 會將其視為 ANSI (CP950) 解析導致亂碼。因此 `config/settings.ini` 須維持由 `EnsureIniEncoding()` 所維護的 UTF-16 LE 格式。
3. **PowerShell 與 CLI 語法注意事項**：
   - 每次在 PowerShell 執行指令前，需確保 `[Console]::OutputEncoding` 設為 UTF-8 以免 stdout 顯示亂碼。
   - 在 PowerShell 中，Jujutsu 的修訂符號 `@` 為關鍵字，必須以引號包裹（如 `jj bookmark set main -r "@"`）。
   - AutoHotkey64.exe 為 GUI 程序，若需等待執行完畢並捕捉 ExitCode，應使用 `Start-Process -FilePath ... -ArgumentList ... -NoNewWindow -PassThru -Wait`。
   - PowerShell 不支援 Bash Heredoc (`<< 'EOF'`)，應使用 Here-String (`@' ... '@`)。
4. **多解析度座標適配**：
   - 三竹股市在 1920x1080 與 2560x1440 解析度下 UI 座標不同，設定檔應分別以 `ClickX_{Resolution}` 與 `ClickY_{Resolution}` 記錄，並配合 `GetResolutionClickCoords()` 進行回退相容。
5. **下拉選單與視窗焦點干擾（Popup Menu Dismissal）**：
   - 點擊「證券行情」等展開下拉選單後，若後續搜尋子項目時再次呼叫 `WinActivate` 或 `WinMaximize`，系統會發送視窗啟用/重繪訊息而**立刻強制關閉已展開的下拉選單**，導致子項目（如「熱門排行」、「盤後排行」）圖像辨識永遠失敗。
   - 解決方案：搜尋已展開的選單項目時應停用視窗啟用邏輯（`shouldActivate := false`），且若視窗已處於作用中（`WinActive`）或最大化時，切勿重複執行啟用或最大化。
6. **Windows 最小化視窗解除與前台鎖定（ASFW）**：
   - 在 Windows 10/11 中，對處於最小化（`WinGetMinMax == -1`）的視窗單純呼叫 `WinActivate` 無法可靠地將其還原（常只在工作列閃爍）。
   - 解決方案：必須先檢測並呼叫 `WinRestore(hwnd)`，並配合 `DllCall("user32\AllowSetForegroundWindow", "Int", -1)` 與 `DllCall("user32\SetForegroundWindow", "Ptr", hwnd)` 突破前台鎖定，再進行激活與最大化。
7. **同進程多視窗之標題精確匹配**：
   - 「三竹股市」主程式視窗與新開啟的子視窗（「熱門排行」、「盤後排行」）屬於同一程序（`三竹股市.exe`），若僅以 `ahk_exe 三竹股市.exe` 當作 WinTitle，AHK 會抓到 Z 軸最頂層的視窗（可能是沒有選單列的子視窗）。
   - 解決方案：必須以標題明確區分（如 `"三竹股市"`、`"熱門排行"`、`"盤後排行"`），或結合標題與進程名稱匹配（`WinTitle " ahk_exe " ProcessName`）。
8. **背景 Session 與互動式桌面隔離（Session Isolation & UIPI）**：
   - 命令列終端（PowerShell / 背景工作）受限於 Windows Session 隔離機制，無法直接枚舉或控制真實使用者互動桌面上的 GUI 視窗（`WinGetList` / `WinActive` 會回傳 0）。
   - 撰寫單元測試時，測試焦點切換應以 `WinExist` 及函式回傳值驗證，避免依賴無桌面環境下的 `WinActive`；定位疑難問題時，以實體執行日誌 `logs/app.log` 留下的真實軌跡為準。
9. **AHK GUI 腳本之常駐特性（Persistence）**：
   - AHK v2 腳本一旦建立了 `Gui()` 物件，該腳本預設會變為常駐進程，除非在結尾明確呼叫 `ExitApp()`，否則命令列等待會持續掛起。
10. **AHK CLI 測試執行器之主控台輸出捕捉（Console Output Redirection）**：
   - `AutoHotkey64.exe` 本身為 Windows GUI 應用程式（`SUBSYSTEM_WINDOWS`），預設未附加主控台輸出緩衝區；即使使用 `FileAppend("...", "*")`，直接在命令列執行也不會將 stdout 列印至主控台。
   - 解決方案：執行測試腳本時務必附加 `/ErrorStdOut` 參數，在 PowerShell 中使用調用運算子 `& "path"` 或經由管線重定向（`cmd /c '"..." /ErrorStdOut tests\run_tests.ahk | findstr "^"'`），方能即時獲取測試進度與摘要。
11. **階層式自繪選單之過渡展開延遲（Dropdown Animation Latency）**：
   - 三竹股市為自繪式介面，點擊第一層主選單（如「證券行情」）後，下拉選單展開渲染需要時間（約 200~300ms）。
   - 若在點擊主選單後立即執行子選單項目（如「熱門排行」）之 `ImageSearch`，會因視覺元件尚未渲染完成而比對失敗並誤觸座標備援；因此在兩層點擊之間必須插入適當的緩衝延遲（如 `Sleep(300)`）。
12. **AHK v2 CLI 動態腳本執行限制（無 `/e` 參數）**：
   - AHK v2 命令列不支援如 Python / Node.js 的 `/e` 或 `-e` 參數，若傳入 `/e` 會被 AHK 視為欲執行的腳本檔案路徑（導致報錯 `Script file not found`）。
   - 解決方案：若需透過 CLI 動態執行腳本字串而不落地檔案，需將腳本透過管道傳入標準輸入，並指定 `*` 參數（例如：`@' ... '@ | & "AutoHotkey64.exe" /ErrorStdOut *`）。
13. **GUI 彈窗函式與單元測試解耦（Headless / Test Friendly）**：
   - 涉及阻斷式使用者互動（如 `MsgBox` 警告）的業務函式，若未解耦直接納入單元測試，會導致測試程序遭彈窗阻塞掛起。
   - 解決方案：函式應提供抑制或控制 UI 彈窗的參數（如 `showMsgBox := true`），單元測試時傳入 `false` 僅驗證狀態回傳值與日誌記錄。
14. **多顯示器虛擬桌面座標系統之邊界計算**：
   - 在多螢幕環境中，若副螢幕位於主螢幕左方或上方，其邊界座標可能為負數（如 `Left = -1920, Top = 0, Right = 0, Bottom = 1080`）。
   - 解決方案：計算解析度時切勿將 `Right` / `Bottom` 直接當作寬高，必須使用差值計算：`Width := Right - Left`、`Height := Bottom - Top`。
15. **AHK v2 靜態檢查特性下的 TDD 骨架先行原則（Stub Skeleton）**：
   - AHK v2 於載入期即對調用函式進行語法與宣告檢查。若在 TDD 紅燈階段直接測試完全未宣告的函式，會引發載入期致命錯誤（`Call to nonexistent function`）而中斷整個測試執行器，無法產生完整測試報告。
   - 解決方案：實踐 TDD 時，建議先宣告該函式的空白骨架（Stub，如回傳預設空值或 false），再執行紅燈測試驗證斷言失敗。
16. **AHK v2 邏輯運算子短路求值與回傳型態（Short-Circuit Operator Return Value Coercion）**：
   - 在 AutoHotkey v2 中，邏輯運算子 `||` 與 `&&` 具備短路求值特性，並直接回傳求值所命中的運算元本身（Truthy/Falsy Operand），而非強制轉為布林值 `true` / `false`。
   - 例如：`WinExist(winTitle) || ProcessExist(procName)` 當有視窗或程序存在時，會回傳整數控制代碼 (HWND 如 `0x104b2`) 或程序 PID (如 `5420`)。
   - 若呼叫端或單元測試進行嚴格比較（如 `result == true`），由於 AHK v2 中的 `true` 等同於整數 `1`，`5420 == 1` 將評估為 `false`，導致測試斷言失敗。
   - 解決方案：宣告回傳值為布林值（`@returns {Boolean}`）的函式，必須使用三元運算子 `(condition) ? true : false` 或 `!(...)` 明確強制收斂為布林值。
17. **CLI 命令路徑之環境變數無關性（PATH Independence）**：
   - 在 Windows PowerShell、背景 Task 或 CI/CD 環境中，AutoHotkey 通常未預設加入系統全域 PATH，直接呼叫 `AutoHotkey64.exe` 會引發 `CommandNotFoundException` (Exit Code 1)。
   - 解決方案：所有與 AutoHotkey 相關之 CLI 指令，務必一律使用完整路徑（如 `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"`）執行。


---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。

