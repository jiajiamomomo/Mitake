# 盤後排行全項目匯出：規格與設計說明書

## 1. 範圍與目標
- 本規格定義針對三竹股市電腦版「證券行情」→「盤後排行」功能之全項目自動化匯出作業。
- 介面包含二維階層式下拉選單：左側大分類清單（`盤後下拉L.png`）與右側子項目清單（`盤後下拉R.png`）。
- **解析度支援**：支援 **1920x1080** 與 **2560x1440**（圖檔均已備妥於 `assets/1920x1080/` 與 `assets/2560x1440/` 目錄）；於其他未支援之解析度或缺少必要圖檔時，自動寫入 WARN 日誌並中止流程。

---

## 2. 前置條件與外部環境
1. **外部關聯程式攔截**：
   - 系統關聯應用已配置指向 [`bypass.bat`](file:///d:/DJC/TEST/三竹/bypass.bat) 以快速關閉外部程序。
   - 三竹在觸發「資料匯出」後仍可能非同步喚醒 Excel 或第三方應用奪取前台焦點；腳本在各子項目操作起點均防禦性調用 [`SwitchToAfterRankWin()`](file:///d:/DJC/TEST/三竹/lib/window_control.ahk) 確保三竹視窗取得前景控制權。
2. **輸出路徑**：
   - 三竹匯出原始 CSV 預設輸出至 `D:\Program Files\MitakeGU\USER\OUT\`（例：`20261002_外資買超.csv`）。
3. **二維分類項目結構**：
   - 左側下拉清單（`盤後下拉L.png`）固定 5 個大分類。
   - 右側下拉清單（`盤後下拉R.png`）之子項目數量依分類而異（共 36 項）：

| 分類序號 (L) | 中文項目 | 英文縮寫 | 完整英文對照 | 右側子項目數量 (R) |
| :---: | :--- | :---: | :--- | :---: |
| 1 | 法人動向 | INST | Institutional Flows / Activity | 10 |
| 2 | 資券當沖 | M&DT | Margin & Day Trading | 10 |
| 3 | 證券借貸 | SBL | Securities Borrowing & Lending | 4 |
| 4 | 經營指標 | FIN / KPI | Financials / Metrics | 8 |
| 5 | 布局配置 | ALLOC | Asset Allocation / Strategy | 4 |

---

## 3. 模組設計 (`lib/export.ahk`)

### 3.1 時序與流程常數 (`ExportTiming`)
程式內建寫死之時序配置（避免非必要配置膨脹）：
- `RefreshDelayMs` (1500 ms)：Enter 選取項目後等待介面資料刷新。
- `DropOpenDelayMs` (300 ms)：點擊下拉箭頭後等待清單浮層展開渲染。
- `KeyDelayMs` (30 ms)：方向鍵導航之按鍵間隔。
- `TimeoutMs` (10000 ms)：輪詢 OUT 目錄取得新 CSV 檔案之逾時上限。
- `PollMs` (200 ms)：輪詢檔案存在與讀取鎖定之檢查間隔。
- `MaxRetries` (2 次)：單一項目失敗時之最多重試次數。

### 3.2 視窗狀態復原常式 (`ResetAfterRankState`)
- 目標視窗：`GetAfterRankWinTitle()`（預設 "盤後排行"）。
- 送出 `{Esc}` 鍵強制關閉任何展開中之自繪浮動選單。
- 將滑鼠游標移至視窗客戶區角落 `(10, 10)`，清除按鈕之 Hover 高亮狀態。

### 3.3 左側分類項目選取 (`ExportAfterRankItemL`)
- **函式簽名**：`ExportAfterRankItemL(itemNoL)`（失敗自動重試最多 2 次，重試前執行 `ResetAfterRankState()`）。
- **單次流程 (`TryExportAfterRankItemL`)**：
  1. `ResetAfterRankState()` 重設視窗狀態。
  2. `SwitchToAfterRankWin()`：切換至「盤後排行」視窗並最大化。
  3. `FindClickImg("盤後下拉L.png", ...)`：於全客戶區搜尋左側下拉箭頭（色彩容許度 variation 45）並點擊。
  4. 等待 300 ms 浮層展開。
  5. 鍵盤導航歸位：發送 `{Home}`，並連續發送 5 次 `{PgUp}`（防護自繪清單忽略 Home 缺陷），確保游標歸至首項。
  6. 發送 `{Down}` × `(itemNoL - 1)` 移至目標分類。
  7. 發送 `{Enter}` 選取，並將滑鼠移至 `(10, 10)` 清除 Hover。
  8. 等待 1500 ms 介面刷新資料。

### 3.4 右側子項目匯出 (`ExportAfterRankItemR`)
- **函式簽名**：`ExportAfterRankItemR(itemNoR, itemNoL := 0, dateStr := "")`（失敗自動重試最多 2 次）。
- **單次流程 (`TryExportAfterRankItemR`)**：
  1. `ResetAfterRankState()` 重設視窗狀態。
  2. `SwitchToAfterRankWin()`：防禦性奪回視窗焦點（避免外部 Excel 搶焦點）。
  3. `FindClickImg("盤後下拉R.png", ...)`：搜尋右側下拉箭頭並點擊。
  4. 等待 300 ms 浮層展開。
  5. 鍵盤導航歸位：發送 `{Home}` + 連續 5 次 `{PgUp}`，隨後發送 `{Down}` × `(itemNoR - 1)`，最後 `{Enter}` 確認選取。
  6. 滑鼠移至 `(10, 10)` 清除 Hover，等待 1500 ms 介面刷新。
  7. 記錄觸發時間 `sinceTime := A_Now`。
  8. `ClickExportBtn()` 點擊「資料匯出」按鈕（優先圖像搜尋 `資料匯出.png`，失敗降級採用 `settings.ini` 之 `[ExportButton]` 座標），點擊後立即移開滑鼠。
  9. `WaitNewCsv(outDir, sinceTime)` 輪詢 OUT 目錄尋找新產生的 CSV 且確認檔案寫入完成（`IsFileReady`）。
  10. `CopyToDateDir(csv, GetAfterRankDstRoot(), dateStr)`：複製覆蓋至 `<專案>\盤後排行\YYYYMMDD\<原始檔名>`。

### 3.5 批次全項目匯出 (`ExportAfterRankAll`)
- **函式簽名**：`ExportAfterRankAll(showMsgBox := true)`。
- **前置驗證**：
  - 檢驗主顯示器解析度（支援 1920x1080 與 2560x1440）與該解析度下之必備圖檔（`盤後下拉L.png`、`盤後下拉R.png`、`資料匯出.png`）。
  - 若解析度不符或圖檔缺失，記錄 WARN 日誌並中止（`aborted := true`）。
- **日期目錄決定**：批次開始時決定一次 `dateStr := FormatTime(A_Now, "yyyyMMdd")`，整批共用。
- **巢狀執行與失敗熔斷**：
  - 外迴圈走訪分類 `itemNoL := 1..TotalItemsL` (5)。
  - 若外層分類 `itemNoL` 選取失敗：實施**立即熔斷 (Circuit Breaking)**，跳過該分類底下的所有子項目，並將其全部子項目（如 `L1-R1` ~ `L1-R10`）一次性記錄至失敗清單，避免級聯式的盲目重試。
  - 內迴圈走訪所屬子項目 `itemNoR := 1..TotalItemsR{L}`。
- **摘要回報**：
  - 全程記錄於 `logs/app.log`。
  - 依 `showMsgBox` 決定是否彈出最終統計摘要（成功數 / 總數，失敗項目清單）。

---

## 4. 設定檔結構 (`config/settings.ini`，UTF-16 LE)

```ini
[AfterMarketRanking]
ClickX_1920x1080 = 78
ClickY_1920x1080 = 110
ClickX_2560x1440 = 78
ClickY_2560x1440 = 110
ClickX = 78
ClickY = 110
TotalItemsL = 5
TotalItemsR1 = 10
TotalItemsR2 = 10
TotalItemsR3 = 4
TotalItemsR4 = 8
TotalItemsR5 = 4
OutDir = D:\Program Files\MitakeGU\USER\OUT

[ExportButton]
ClickX_1920x1080 = 1777
ClickY_1920x1080 = 50

[Hotkey]
AfterRankExportHotkey = 
```

---

## 5. 進入點整合 (`Mitake.ahk`)
- **系統托盤選單 (Tray Menu)**：
  - 加入「匯出盤後排行」（`A_TrayMenu.Add("匯出盤後排行", (*) => ExportAfterRankAll())`）。
- **快捷鍵表驅動註冊**：
  - 註冊項：`{cfg: "AfterRankExportHotkey", def: "", desc: "匯出盤後排行", hnd: (*) => ExportAfterRankAll()}`。

---

## 6. 測試與驗證

1. **無頭自動化測試 (`tests/test_export.ahk` / `tests/run_tests.ahk`)**：
   - 驗證 `GetAfterRankTotalItemsL()` 預設值與設定檔讀取（5）。
   - 驗證 `GetAfterRankTotalItemsR(1..5)` 各分類數量（10, 10, 4, 8, 4）。
   - 驗證 `GetAfterRankDstRoot()` 目的目錄。
   - 驗證 `AfterRankAssets()` 圖資清單與多解析度存在性檢查。
   - 驗證 `FindNewCsv`、`WaitNewCsv` 與 `CopyToDateDir` 之純邏輯隔離測試。
2. **手動實機驗證工具 (`tests/test_after_rank_export.ahk`)**：
   - 支援安全緊急中止熱鍵：`$Esc`。
   - 參數彈性：
     - `0` 或 `all`：執行全項目批次匯出。
     - `L R` / `L,R` / `L-R`：執行特定分類下的指定子項目（例如 `1,3` 執行分類 1 之子項目 3）。
     - `L`（1~5）：執行指定分類下的所有子項目（例如 `2` 執行分類 2 的所有 10 項）。
     - 未帶參數時彈出互動式 `InputBox` 供使用者輸入。
