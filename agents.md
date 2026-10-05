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

---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。

