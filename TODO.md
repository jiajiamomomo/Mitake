# 後續工作（TODO）

## 已完成項目

### [x] P1：匯出後依批次基準清理新增的 Excel (已於 2026-10-10 完成)

#### 背景與問題

執行托盤「匯出熱門排行」或「匯出盤後排行」時，三竹每匯出一個 CSV 都可能呼叫一個新的 Microsoft Excel 視窗／程序。完整批次結束後會累積大量 Excel，干擾前景焦點並消耗系統資源。

#### 實作成效與安全邊界防護

1. **白名單基準建立 (`CaptureExcelBaseline`)**：
   - 批次啟動前以 Win32 `Toolhelp32Snapshot` 高速掃描並記錄既有 `EXCEL.EXE` PID 與頂層視窗 HWND。
   - 批次開始前已存在的 Excel PID 與頂層 HWND 列入保護基準；後續在同一既有 PID 開啟的新視窗也會因 PID 保護而略過。
2. **新增視窗與程序差集過濾 (`FilterNewExportExcelWindows` / `FilterNewExportExcelProcesses`)**：
   - 以 PID／HWND 差集找出相較基準新增的 Excel，排除受保護 PID／HWND。
3. **優雅退出與超時防護 (`CloseNewExportExcels`)**：
   - 以 `WinClose` 發送標準關閉訊息並輪詢確認；若逾時，保留程序並記錄警告日誌，避免反覆強制結束造成 Excel 安全模式詢問。符合該詢問時自動選「否」。
   - 清理失敗不中斷 CSV 歸檔流程。
4. **生命週期全路徑整合**：
   - 單項匯出確認完成複製後立即清理，防止後續項目焦點被劫持。
   - 輪詢逾時準備重試前清理殘留 Excel，確保重試視窗乾淨。
   - 在 `ExportPopRankAll` 與 `ExportAfterRankAll` 的 `finally` 區塊進行兜底清理，涵蓋正常完成、`Esc` 中止、例外錯誤所有路徑。
5. **測試與驗證覆蓋**：
   - **無頭測試**：覆蓋基準建立、既有 PID 保護過濾、新增視窗過濾、清理冪等性、安全模式詢問辨識、CSV 共享讀取與 `ExportRunState` 生命週期 (`163 Total, 163 Passed, 0 Failed`)。
   - **實機驗證**：透過 `tests/test_excel_cleanup.ahk` 實機啟動 Excel 進行生命週期驗證（5/5 步驟全數通過，正常關閉視窗並回收進程，既有基準不受干擾）。

**已知邊界**：差集無法辨識新增 Excel 的啟動來源；批次期間若使用者或其他程式另開 Excel，也可能被清理。執行批次時請勿另開 Excel。手動單項驗證未經 `BeginExportRun` 建立批次基準，僅會在複製完成時擷取當下基準，無法比照完整批次清理先前開啟的 Excel。

**再次實機驗證（2026-10-19）**：熱門排行 44/44、盤後排行 36/36；CSV 等待逾時 0 次、Excel 視窗消失競態警告 0 組、正常關閉逾時 0 次。盤後排行 L#5 有一次前景焦點失敗，第一次重試即恢復。詳細數據見 `LESSONS_LEARNED.md`。

---

## 待規劃項目

目前無未完成之 P1/P2 工作。後續若有新需求可於此處提出。
