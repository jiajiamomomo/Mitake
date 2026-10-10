# 後續工作（TODO）

## 已完成項目

### [x] P1：匯出後關閉三竹新開啟的 Excel (已於 2026-10-10 完成)

#### 背景與問題

執行托盤「匯出熱門排行」或「匯出盤後排行」時，三竹每匯出一個 CSV 都可能呼叫一個新的 Microsoft Excel 視窗／程序。完整批次結束後會累積大量 Excel，干擾前景焦點並消耗系統資源。

#### 實作成效與安全邊界防護

1. **白名單基準建立 (`CaptureExcelBaseline`)**：
   - 批次啟動前以 Win32 `Toolhelp32Snapshot` 高速掃描並記錄既有 `EXCEL.EXE` PID 與頂層視窗 HWND。
   - 批次開始前已開啟的 Excel 與活頁簿嚴格列入保護白名單，絕不被清理或終止。
2. **新增視窗與程序差集過濾 (`FilterNewExportExcelWindows` / `FilterNewExportExcelProcesses`)**：
   - 相較基準新增的 Excel 視窗與程序被精確辨識，並徹底隔離受保護 PID。
3. **優雅退出與超時防護 (`CloseNewExportExcels`)**：
   - 優先以 `WinClose` 發送標準關閉訊息並輪詢確認；若逾時且確認屬於本批次新開啟，則安全回收程序並記錄警告日誌。
   - 清理失敗不中斷 CSV 歸檔流程。
4. **生命週期全路徑整合**：
   - 單項匯出確認完成複製後立即清理，防止後續項目焦點被劫持。
   - 輪詢逾時準備重試前清理殘留 Excel，確保重試視窗乾淨。
   - 在 `ExportPopRankAll` 與 `ExportAfterRankAll` 的 `finally` 區塊進行兜底清理，涵蓋正常完成、`Esc` 中止、例外錯誤所有路徑。
5. **測試與驗證覆蓋**：
   - **無頭測試**：覆蓋基準建立、既有 PID 保護過濾、新增視窗過濾、清理冪等性與 `ExportRunState` 生命週期 (`157 Total, 157 Passed, 0 Failed`)。
   - **實機驗證**：透過 `tests/test_excel_cleanup.ahk` 實機啟動 Excel 進行生命週期驗證（5/5 步驟全數通過，正常關閉視窗並回收進程，既有基準不受干擾）。

---

## 待規劃項目

目前無未完成之 P1/P2 工作。後續若有新需求可於此處提出。
