# 後續工作（TODO）

## P1：匯出後關閉三竹新開啟的 Excel

### 背景

執行托盤「匯出熱門排行」或「匯出盤後排行」時，三竹每匯出一個 CSV 都可能呼叫一個新的 Microsoft Excel 視窗／程序。完整批次結束後會累積大量 Excel，干擾前景焦點並消耗系統資源。

### 目標

在熱門排行與盤後排行批次中，每次匯出完成後關閉該次由三竹新開啟的 Excel；批次結束或中止時，再清理本批次尚未關閉的新增 Excel。

### 安全邊界

- 批次開始前記錄既有 `EXCEL.EXE` PID 與可識別的頂層視窗，建立保護基準。
- 只處理批次開始後新增、且可合理歸因於本次三竹匯出的 Excel。
- 不得關閉批次開始前已存在的 Excel，也不得影響使用者原本開啟的活頁簿。
- 優先採用正常關閉視窗；只有在確認屬於本批次、正常關閉逾時且已記錄警告時，才考慮終止程序。
- 清理失敗不得中斷 CSV 歸檔；需記錄 PID、視窗標題、處理結果與失敗原因。
- 必須同時涵蓋正常完成、使用者按 `Esc` 中止、例外與單項重試等結束路徑。

### 建議設計

1. `CaptureExcelBaseline()`：記錄批次開始前的 Excel PID／HWND。
2. `FindNewExportExcelWindows(baseline)`：列出相較基準新增的 Excel 視窗，並排除受保護 PID。
3. `CloseNewExportExcels(baseline, timeoutMs)`：先送出正常關閉，輪詢確認；必要時依安全條件進行後續處理。
4. 在單項 CSV 已確認並完成 `CopyToDateDir` 後執行一次清理。
5. 在 `ExportPopRankAll`／`ExportAfterRankAll` 的 `finally` 區塊再次執行兜底清理。

### 驗收條件

- 熱門排行 44 項與盤後排行 36 項完整匯出後，不留下本批次新開啟的 Excel。
- 批次開始前已開啟的 Excel 與活頁簿保持開啟且內容不受影響。
- 中途按 `Esc` 或發生匯出錯誤時，仍會清理本批次新增的 Excel。
- Excel 關閉失敗時，匯出結果不被誤判為失敗，且 `logs/app.log` 有可追查紀錄。
- 無頭測試至少覆蓋 PID 基準差集、既有 PID 保護、重複清理冪等性及 finally 清理路徑；另以實機工具驗證真正的 Excel 視窗生命週期。

