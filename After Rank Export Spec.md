# 盤後排行全項目匯出：設計共識

## 範圍
- 「盤後排行」大致沿用「熱門排行」架構，部分有不同（盤後下拉L/R.png 已備）。
- 僅支援 **1920x1080**；2560x1440 缺圖時寫 WARN 日誌並中止。

## 前置條件（已就緒）
- 關聯程式已指向 [bypass.bat](file:///d:/DJC/TEST/三竹/bypass.bat)，但三竹仍會開啟EXCEL →  Excel 仍會搶焦點。
- 左邊的下拉清單 '盤後下拉L.png' 共有5個項目:法人動向、資券當沖、證券借貨、經營指標、布局配置。
- 右邊的下拉清單 '盤後下拉R.png' 項目數量不一。

| 中文項目 | 英文縮寫 | 完整英文對照 | 右邊清單數量 |
| :--- | :--- | :--- | :--- |
| 法人動向 | INST | Institutional Flows / Activity | 10 |
| 資券當沖 | M&DT | Margin & Day Trading | 10 |
| 證券借貸 | SBL | Securities Borrowing & Lending | 4 |
| 經營指標 | FIN / KPI | Financials / Metrics | 8 |
| 布局配置 | ALLOC | Asset Allocation / Strategy | 4 |

- 三竹會把匯出檔寫到 `D:\Program Files\MitakeGU\USER\OUT\`（例：`20261002_外資買超.csv`）。

## 模組 `lib/export.ahk`

### `ExportAfterRankItemL(itemNoL)`：單一項目
1. `SwitchToAfterRankWin()`：切換到「盤後排行」並最大化
2. `FindClickImg("盤後下拉L.png")`：搜尋範圍為整個工作區
3. `Send("{Home}")`
4. `Send("{Down}")` × (itemNoL − 1)
5. `Send("{Enter}")`
6. `Sleep`，等資料刷新（寫死在程式中）

任何一步失敗 → 整個 `ExportAfterRankItemL` 最多重試 **2 次**。

### `ExportAfterRankItemR(itemNoR)`：單一項目
2. `FindClickImg("盤後下拉R.png")`：搜尋範圍為整個工作區
3. `Send("{Home}")`
4. `Send("{Down}")` × (itemNoR − 1)
5. `Send("{Enter}")`
6. `Sleep`，等資料刷新（寫死在程式中）
7. 記錄觸發時間 → `FindClickImg("資料匯出.png")`
8. 輪詢 OutDir，找出比觸發時間新的 CSV（逾時與輪詢間隔都寫死在程式中）
9. `CopyToDateDir(csv, <專案>\盤後排行)` → `盤後排行\YYYYMMDD\<原始檔名>`，同名就覆蓋

任何一步失敗 → 整個 `ExportAfterRankItemR` 最多重試 **2 次**。

### `ExportAfterRankAll(showMsgBox := true)`：批次
- 外迴圈跑 `itemNoL := 1..TotalItemsL`
- 內迴圈跑 `itemNoR := 1..TotalItemsR`
- 日期資料夾在批次開始時決定一次（`A_Now`），整批共用
- 所有步驟都寫進 `logs/app.log`
- 完成後跳出 MsgBox 摘要（`showMsgBox := false` 時不跳，供無頭測試使用）

### 純函式（無頭單元測試）
- `FindNewCsv(outDir, sinceTime)`：找出最新且晚於 `sinceTime` 的 CSV，找不到則回傳 `""`
- `CopyToDateDir(src, dstRoot, dateStr)`：視需要建立 `dstRoot\dateStr\`，再以覆蓋模式複製

## 設定（`settings.ini`，UTF-16 LE）
```ini
[AfterMarketRanking]
TotalItemsL = 5
TotalItemsR1 = 10
TotalItemsR2 = 10
TotalItemsR3 = 4
TotalItemsR4 = 8
TotalItemsR5 = 4
OutDir = D:\Program Files\MitakeGU\USER\OUT

[Hotkey]
AfterRankExportHotkey =
```
延遲、逾時、重試次數都寫死在程式中。

## 進入點
- 托盤選單「匯出盤後排行」，加上熱鍵 `AfterRankExportHotkey`（預設留空），沿用現有的表驅動註冊方式。

## 測試
- `tests/test_export.ahk`：用暫存目錄測 `FindNewCsv`、`CopyToDateDir`，以及讀取 `TotalItems` 的預設值，並加入 `run_tests.ahk`。
- 手動實機驗證腳本：`tests/test_after_rank_export.ahk`（實際點擊，可只跑單一項目或整批）。
- 更新 `ABBREVIATIONS.md` 與 AGENTS.md 的 Roadmap 及目錄結構。
