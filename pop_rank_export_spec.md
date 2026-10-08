# 熱門排行全項目匯出：規格與設計說明 (Popular Ranking Export Spec)

## 一、 範圍與目標 (Scope & Objectives)
- 自動化批次匯出三竹股市「證券行情」→「熱門排行」下拉清單內之所有項目（共 **44** 項）。
- 支援主顯示器解析度 **1920x1080**（2560x1440 缺圖時記錄 WARN 日誌並中止）。
- 架構與模式作為後續「盤後排行」全項目匯出之基礎設計規範。

---

## 二、 前置條件與環境 (Prerequisites)
1. **防搶焦點機制**：三竹之資料匯出關聯程式設定指向 [bypass.bat](file:///d:/DJC/TEST/三竹/bypass.bat)，該批次檔啟動後立即結束退出，防止系統自動開啟 Excel 奪取前台焦點。
2. **匯出暫存目錄**：三竹股市預設匯出 CSV 路徑為 `D:\Program Files\MitakeGU\USER\OUT\`（例：`20261002_漲停鎖住.csv`）。
3. **專案存放目的地**：`<專案根目錄>\熱門排行\YYYYMMDD\<原始檔名>.csv`。

---

## 三、 時序與核心參數 (`ExportTiming`)

所有時序與重試參數集中定義於 `ExportTiming` 類別常數：

| 參數名稱 | 數值 | 說明 |
| :--- | :--- | :--- |
| `RefreshDelayMs` | 1500 ms | Enter 選取下拉項目後，等待三竹介面資料刷新之緩衝時間 |
| `DropOpenDelayMs` | 300 ms | 點擊下拉箭頭後，等待自繪下拉選單浮層渲染展開之延遲 |
| `KeyDelayMs` | 30 ms | 鍵盤方向鍵 (`Down` / `PgUp`) 連續發送之間隔延遲 |
| `TimeoutMs` | 10000 ms | 輪詢三竹輸出新 CSV 檔案之最長逾時時間 |
| `PollMs` | 200 ms | 輪詢輸出目錄之週期檢查間隔 |
| `MaxRetries` | 2 次 | 單一項目若未成功匯出，最多自動重試次數（連同初次共最多執行 3 次） |

---

## 四、 核心執行流程

### 1. 單一項目匯出：`TryExportPopRankItem(itemNo, dateStr)`
每個項目的完整處理工序如下：
1. **狀態防禦復原 (`ResetPopRankState`)**：
   - 確保目標視窗已取得焦點。
   - 送出 `{Esc}` 強制關閉任何前次殘留之自繪下拉浮層。
   - 將滑鼠游標移至視窗客戶端左上角空白區 `(10, 10)`，清除控制項之滑鼠停懸高亮狀態（Hover Clear）。
2. **切換並鎖定視窗 (`SwitchToPopRankWin`)**：
   - 切換至「熱門排行」視窗並最大化；若未開啟則透過主選單路徑自動開啟。
   - 延遲 `DropOpenDelayMs` (300 ms)。
3. **點擊下拉箭頭 (`FindClickImg`)**：
   - 搜尋資產圖檔 `assets/{解析度}/熱門下拉.png`（容許度 `variation := 45`）。
   - 命中後點擊展開自繪下拉選單，並延遲 `DropOpenDelayMs` (300 ms)。
4. **鍵盤導航選取**：
   - **首項歸位**：三竹自繪選單不支援標準 Win32 `{Home}` 鍵，改為發送 5 次 `Send("{PgUp}")` 向上翻頁確保游標穩定歸位至第 1 項。
   - **遞增定位**：發送 `(itemNo - 1)` 次 `Send("{Down}")`，定位至目標項目。
   - **確認選取**：發送 `Send("{Enter}")` 套用選取。
   - **解除停懸**：選取後立即將滑鼠游標移至客戶端 `(10, 10)`。
5. **等待資料刷新**：
   - 等待 `RefreshDelayMs` (1500 ms)，確保報表資料重新載入完成。
6. **點擊「資料匯出」(`ClickExportBtn`)**：
   - 記錄觸發起始時間戳記 `sinceTime := A_Now`。
   - **優先圖像辨識**：搜尋 `assets/{解析度}/資料匯出.png`（容許度 `variation := 45`），找到即點擊。
   - **座標備援機制**：若圖像比對未命中，自動讀取 `config/settings.ini` 中 `[ExportButton]` 區段之解析度座標（1920x1080 預設為 `X=1777, Y=50`）降級點擊；若未設定座標則安全中止並記錄 WARN 日誌。
   - 點擊後再次將游標移至 `(10, 10)` 避免 Hover 影響後續比對。
7. **輪詢捕捉新 CSV (`WaitNewCsv`)**：
   - 在 `outDir` 輪詢修改時間不早於 `sinceTime` 之最新 CSV 檔案。
   - 透過 `IsFileReady(csv)`（嘗試獨佔唯讀開啟）確保三竹已完全釋放寫入鎖定。
   - 逾時 `TimeoutMs` (10 秒) 或檔案未就緒則回傳失敗。
8. **歸檔複製 (`CopyToDateDir`)**：
   - 將檔案複製至 `<專案根目錄>\熱門排行\<dateStr>\<原始檔名>.csv`（保留原檔名，同名覆蓋）。

### 2. 單項重試封裝：`ExportPopRankItem(itemNo, dateStr := "")`
- 驗證序號合法性（必須為 $\ge 1$ 之整數）。
- 進入迴圈執行 `TryExportPopRankItem`，最多自動重試 `MaxRetries` (2) 次。
- 每次重試前主動調用 `ResetPopRankState()` 並插入 300 ms 間隔，確保復原至乾淨基準環境。

### 3. 批次全項目匯出：`ExportPopRankAll(showMsgBox := true)`
- 讀取設定檔之項目總數 `TotalItems`（預設為 **44**）。
- 批次啟動前取得統一日期字串 `dateStr := FormatTime(A_Now, "yyyyMMdd")`，整批共用同一個歸檔子目錄。
- 依序迴圈 `itemNo := 1 .. TotalItems` 執行單項匯出。
- 即時累計成功與失敗清單，所有執行歷程輸出至 [logs/app.log](file:///d:/DJC/TEST/三竹/logs/app.log)。
- 結束時顯示摘要訊息方塊（可透過 `showMsgBox := false` 抑制彈窗，供無頭測試與背景自動化使用）。

---

## 五、 設定檔規範 (`config/settings.ini`)

設定檔採 **UTF-16 LE with BOM** 編碼格式維護：

```ini
[PopularRanking]
ClickX_1920x1080 = 77
ClickY_1920x1080 = 80
ClickX_2560x1440 = 78
ClickY_2560x1440 = 80
ClickX = 77
ClickY = 80
TotalItems = 44
OutDir = D:\Program Files\MitakeGU\USER\OUT

[ExportButton]
ClickX_1920x1080 = 1777
ClickY_1920x1080 = 50

[Hotkey]
PopRankExportHotkey =
```

---

## 六、 進入點與操作方式

1. **系統托盤選單 (Tray Menu)**：點擊「匯出熱門排行」直接啟動批次作業。
2. **自訂全域熱鍵**：可於 `settings.ini` 之 `[Hotkey]` 設定 `PopRankExportHotkey`。
3. **實機手動測試工具**：執行 [tests/test_pop_rank_export.ahk](file:///d:/DJC/TEST/三竹/tests/test_pop_rank_export.ahk)。
   - 按 `F9`：執行單一項目手動測試（預設 Item 1）。
   - 按 `F10`：執行完整批次 44 項自動匯出測試。
   - 按 `$Esc`：強制中斷正在執行的測試流程（使用鍵盤 hook 避免與內部 `Send("{Esc}")` 重設狀態互相干擾）。

---

## 七、 測試與驗證體系

1. **無頭自動化單元測試**：[tests/test_export.ahk](file:///d:/DJC/TEST/三竹/tests/test_export.ahk)
   - 透過暫存目錄驗證 `FindNewCsv`、`WaitNewCsv`、`CopyToDateDir`、`IsFileReady`。
   - 驗證 `GetPopRankTotalItems` 預設值 (44) 與自訂讀取、`HasResAssets`、`PopRankAssets` 等純邏輯。
   - 整合於 [tests/run_tests.ahk](file:///d:/DJC/TEST/三竹/tests/run_tests.ahk) 全域測試套件。
2. **實機診斷與校正工具**：
   - [tests/diagnose_export_btn.ahk](file:///d:/DJC/TEST/三竹/tests/diagnose_export_btn.ahk)：驗證「資料匯出」圖像比對、座標計算與滑鼠平滑移動校正。
   - [tests/capture_asset.ahk](file:///d:/DJC/TEST/三竹/tests/capture_asset.ahk)：截取與更新按鈕與箭頭純淨圖檔資產。
