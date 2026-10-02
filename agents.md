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

---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。
