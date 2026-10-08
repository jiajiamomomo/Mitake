Project Path: 三竹

Source Tree:

```txt
三竹
├── ABBREVIATIONS.md
├── After Rank Export Spec.md
├── LESSONS_LEARNED.md
├── Mitake.ahk
├── README.md
├── TODO.md
├── agents.md
├── assets
│   ├── 1920x1080
│   │   ├── menu_證券行情.png
│   │   ├── 熱門下拉.png
│   │   ├── 熱門排行.png
│   │   ├── 盤後下拉L.png
│   │   ├── 盤後下拉R.png
│   │   ├── 盤後排行.png
│   │   └── 資料匯出.png
│   └── 2560x1440
│       ├── menu_證券行情.png
│       ├── 熱門下拉.png
│       ├── 熱門排行.png
│       ├── 盤後下拉L.png
│       ├── 盤後下拉R.png
│       ├── 盤後排行.png
│       └── 資料匯出.png
├── bypass.bat
├── config
│   └── settings.ini
├── lib
│   ├── export.ahk
│   ├── utils.ahk
│   └── window_control.ahk
├── pop_rank_export_spec.md
├── tests
├── 熱門排行
└── 盤後排行

```

`ABBREVIATIONS.md`:

```md
# AutoHotkey 變數與函式縮寫對照表 (Naming Abbreviations)

本專案遵循此縮寫對照表以維持命名一致性與簡潔性。

---

## 1. 核心字彙縮寫規則 (Core Words)

| 原詞 (Original) | 縮寫 (Abbreviation) | 範例說明 |
| :--- | :--- | :--- |
| Window | `Win` | `WinTitle`, `mainWin` |
| Process | `Proc` | `procName` |
| Image | `Img` | `imgPath`, `imgRes`, `imgW`, `imgH` |
| Configuration / Config | `Cfg` | `GetCfg`, `procCfg` |
| Display / Resolution | `Res` | `GetRes`, `GetAllRes`, `IsSupportedRes` |
| Primary | `Pri` | `priIdx`, `ValidatePriRes` |
| Coordinate / Coordinates | `Coord` / `Coords` | `GetResCoords` |
| Message | `Msg` | `LogMsg`, `errMsg`, `ShellMsg` |
| Default | `Def` | `defVal`, `defX`, `defY` |
| Target | `Tgt` | `tgtWin`, `tgtPath`, `tgtRes`, `tgtMon` |
| Directory | `Dir` | `logDir`, `dirPath`, `GetRootDir` |
| Hotkey | `HK` | `launchHk`, `menubarHk`, `HkLaunch` |
| Handler | `Hnd` | `MenuLaunchHnd`, `HkLaunchHnd` |
| Popular Ranking (熱門排行) | `PopRank` | `GetPopRankWinTitle`, `ClickPopRankMenu` |
| After-Market Ranking (盤後排行) | `AfterRank` | `GetAfterRankWinTitle`, `ClickAfterRankMenu` |
| Securities Quote (證券行情) | `SecQuote` | `ClickSecQuoteMenu` |
| Menu Bar | `MenuBar` | `ToggleMenuBar` |
| Mitake (三竹股市) | `Mitake` | `IsMitakeRunning`, `LaunchMitake` |

---

## 2. 函式名稱對照表 (Functions)

### `lib/utils.ahk`
| 原函式名 | 新縮短函式名 | 說明 |
| :--- | :--- | :--- |
| `EnsureIniEncoding` | `EnsureIniEnc` | 確保 INI 使用 UTF-16 LE 編碼 |
| `GetConfig` | `GetCfg` | 讀取 INI 設定檔內容 |
| `LogMessage` | `LogMsg` | 寫入執行日誌 |
| `GetProjectRootDir` | `GetRootDir` | 取得專案根目錄 |
| `GetDisplayResolution` | `GetRes` | 取得指定/主顯示器解析度資訊 |
| `GetAllDisplaysResolution` | `GetAllRes` | 取得所有顯示器解析度列表 |
| `IsSupportedDisplayResolution` | `IsSupportedRes` | 檢查解析度是否受支援 |
| `ValidatePrimaryDisplayResolution` | `ValidatePriRes` | 驗證主顯示器解析度 |

### `lib/window_control.ahk`
| 原函式名 | 新縮短函式名 | 說明 |
| :--- | :--- | :--- |
| `GetMainWindowTitle` | `GetMainWinTitle` | 取得三竹主視窗 WinTitle |
| `GetPopularRankingWindowTitle` | `GetPopRankWinTitle` | 取得「熱門排行」視窗 WinTitle |
| `GetAfterMarketRankingWindowTitle` | `GetAfterRankWinTitle` | 取得「盤後排行」視窗 WinTitle |
| `FindMitakeWindow` | `FindMitakeWin` | 尋找三竹股市相關視窗 HWND |
| `WaitForMitakeWindow` | `WaitMitakeWin` | 等待精確標題之三竹視窗出現 |
| `IsTrustedForegroundMetadata` | `IsTrustedForegroundMeta` | 判斷前景視窗是否為同程序的可信選單浮層 |
| `GetSafeForegroundContext` | `GetSafeForegroundContext` | 取得目標視窗或其自繪選單浮層的安全操作 HWND |
| `ClickClientPoint` | `ClickPoint` | 視窗客戶區座標點擊 (支援 control 與 physical) |
| `SwitchToMainWindow` | `SwitchToMainWin` | 切換至主程式視窗 |
| `IsMitakeRunning` | `IsMitakeRunning` | 檢查三竹股市是否執行中 |
| `LaunchMitakeStock` | `LaunchMitake` | 啟動或聚焦三竹股市 |
| `ActivateMitake` | `ActivateMitake` | 聚焦並最大化指定視窗 |
| `ToggleMitakeMenuBar` | `ToggleMenuBar` | 切換或開啟選單列 |
| `GetImageSize` | `GetImgSize` | 取得圖檔寬度與高度 |
| `FindAndClickImage` | `FindClickImg` | 影像搜尋並點擊中心點 |
| `GetAssetImagePath` | `GetAssetImgPath` | 取得資產圖檔路徑 |
| `GetResolutionClickCoords` | `GetResCoords` | 取得指定解析度點擊座標 |
| `ClickSecuritiesQuoteMenu` | `ClickSecQuoteMenu` | 點擊「證券行情」選單 |
| `ClickRankingMenu` | `ClickRankMenu` | 通用點擊「證券行情」下拉排行項目並等待視窗 |
| `ClickPopularRankingMenu` | `ClickPopRankMenu` | 點擊「熱門排行」選單 |
| `ClickAfterMarketRankingMenu` | `ClickAfterRankMenu` | 點擊「盤後排行」選單 |
| `SwitchToSubWindow` | `SwitchToSubWin` | 通用切換或開啟子視窗 |
| `SwitchToPopularRankingWindow` | `SwitchToPopRankWin` | 切換至「熱門排行」視窗 |
| `SwitchToAfterMarketRankingWindow` | `SwitchToAfterRankWin` | 切換至「盤後排行」視窗 |

### `lib/export.ahk`
| 原函式名 | 新縮短函式名 | 說明 |
| :--- | :--- | :--- |
| `ExportTimingConstants` | `ExportTiming` | 匯出流程時序常數 (寫死於程式) |
| `BuildDropdownNavigationPlan` | `BuildDropdownNavPlan` | 建立自繪下拉清單的按鍵導航計畫 |
| `SendDropdownKeyPulse` | `SendDropdownKeyPulse` | 以 KeyDown／KeyUp 與延遲送出單一導航鍵脈衝 |
| `ExecuteDropdownNavigation` | `ExecuteDropdownNav` | 依計畫逐鍵執行下拉清單導航 |
| `PopularRankingAssets` | `PopRankAssets` | 熱門排行匯出所需圖檔清單 |
| `GetPopularRankingTotalItems` | `GetPopRankTotalItems` | 讀取 `[PopularRanking] TotalItems` (預設 44) |
| `GetExportOutputDirectory` | `GetExportOutDir` | 讀取三竹 CSV 輸出目錄 `OutDir` |
| `GetPopularRankingDestinationRoot` | `GetPopRankDstRoot` | 取得 `<專案>\熱門排行` 目的根目錄 |
| `FindChangedCsv` | `FindNewCsv` | 尋找相較基準快照新增或內容已變更的 CSV |
| `CaptureCsvState` | `CaptureCsvState` | 建立匯出前 CSV 檔名與內容簽章快照 |
| `GetCsvSignature` | `GetCsvSignature` | 計算 CSV 修改時間、大小與內容雜湊簽章 |
| `StageExistingCsvFiles` | `StageExistingCsvs` | 批次前暫存 OUT 目錄既有 CSV，避開同名衝突 |
| `FinalizeCsvStaging` | `FinalizeCsvStage` | 恢復未被取代的 CSV 並保留同名舊版備份 |
| `IsFileReady` | `IsFileReady` | 檢查檔案是否已寫入完成 |
| `WaitForNewCsv` | `WaitNewCsv` | 輪詢等待新 CSV 出現 |
| `CopyToDateDirectory` | `CopyToDateDir` | 複製至 `YYYYMMDD` 子資料夾 (同名覆蓋) |
| `HasResolutionAssets` | `HasResAssets` | 檢查指定解析度圖檔是否齊全 |
| `ResetPopularRankingState` | `ResetPopRankState` | 重設視窗狀態 (Esc 收合選單與移開滑鼠) |
| `ClickExportButton` | `ClickExportBtn` | 點擊資料匯出 (圖像優先，退回 `[ExportButton]` 座標) |
| `TryExportPopularRankingItem` | `TryExportPopRankItem` | 單次匯出單一項目 (不含重試) |
| `ExportPopularRankingItem` | `ExportPopRankItem` | 匯出單一項目 (含重試) |
| `ExportPopularRankingAll` | `ExportPopRankAll` | 批次匯出全部項目 |
| `AfterMarketRankingAssets` | `AfterRankAssets` | 盤後排行匯出所需圖檔清單 |
| `GetAfterMarketRankingTotalItemsL` | `GetAfterRankTotalItemsL` | 讀取 `[AfterMarketRanking] TotalItemsL` (預設 5) |
| `GetAfterMarketRankingTotalItemsR` | `GetAfterRankTotalItemsR` | 讀取 `[AfterMarketRanking] TotalItemsR{itemNoL}` (依規格預設) |
| `GetAfterMarketRankingDestinationRoot` | `GetAfterRankDstRoot` | 取得 `<專案>\盤後排行` 目的根目錄 |
| `ResetAfterMarketRankingState` | `ResetAfterRankState` | 重設視窗狀態 (Esc 收合選單與移開滑鼠) |
| `TryExportAfterMarketRankingItemL` | `TryExportAfterRankItemL` | 單次選取左側分類項目 (不含重試) |
| `ExportAfterMarketRankingItemL` | `ExportAfterRankItemL` | 選取左側分類項目 (含重試) |
| `TryExportAfterMarketRankingItemR` | `TryExportAfterRankItemR` | 單次匯出右側子項目 (不含重試) |
| `ExportAfterMarketRankingItemR` | `ExportAfterRankItemR` | 匯出右側子項目 (含重試) |
| `ExportAfterMarketRankingAll` | `ExportAfterRankAll` | 批次匯出全部盤後排行項目 |

### `Mitake.ahk` (Handlers & Helpers)
| 原名稱 | 新縮短名稱 | 說明 |
| :--- | :--- | :--- |
| `RegisterHotkey` | `RegisterHk` | 註冊快捷鍵設定與日誌記錄輔助函式 |
| `ShellMessage` | `ShellMsg` | ShellHook 監聽處理常式 |
| `RunUiAction` | `RunUiAction` | 匯出期間阻擋其他互動式視窗操作 |
| `MenuLaunchHandler` | `MenuLaunchHnd` | 托盤「啟動/切換 三竹股市」處理函式 |
| `MenuToggleMenuBarHandler` | `MenuToggleBarHnd` | 托盤「切換選單列」處理函式 |
| `MenuClickSecuritiesQuoteHandler` | `MenuSecQuoteHnd` | 托盤「證券行情」處理函式 |
| `MenuClickPopularRankingHandler` | `MenuPopRankHnd` | 托盤「熱門排行」處理函式 |
| `MenuClickAfterMarketRankingHandler` | `MenuAfterRankHnd` | 托盤「盤後排行」處理函式 |
| `MenuExportPopularRankingHandler` | `MenuPopRankExportHnd` | 托盤「匯出熱門排行」處理函式 |
| `MenuExportAfterMarketRankingHandler` | `MenuAfterRankExportHnd` | 托盤「匯出盤後排行」處理函式 |
| `MenuShowResolutionHandler` | `MenuShowResHnd` | 托盤「顯示解析度」處理函式 |

```
`After Rank Export Spec.md`:

```md
# 盤後排行全項目匯出：規格與設計說明書

> 實機驗證狀態：2026-10-09 已完成 36 項完整托盤批次驗證。問題閉環記錄見 [LESSONS_LEARNED.md](LESSONS_LEARNED.md)。

## 1. 範圍與目標
- 本規格定義針對三竹股市電腦版「證券行情」→「盤後排行」功能之全項目自動化匯出作業。
- 介面包含二維階層式下拉選單：左側大分類清單（`盤後下拉L.png`）與右側子項目清單（`盤後下拉R.png`）。
- **解析度支援**：支援 **1920x1080** 與 **2560x1440**（圖檔均已備妥於 `assets/1920x1080/` 與 `assets/2560x1440/` 目錄）；於其他未支援之解析度或缺少必要圖檔時，自動寫入 WARN 日誌並中止流程。

---

## 2. 前置條件與外部環境
1. **外部關聯程式攔截**：
   - 系統關聯應用已配置指向 [`bypass.bat`](bypass.bat) 以快速關閉外部程序。
   - 三竹在觸發「資料匯出」後仍可能非同步喚醒 Excel 或第三方應用奪取前台焦點；腳本在各子項目操作起點均防禦性調用 [`SwitchToAfterRankWin()`](lib/window_control.ahk) 確保三竹視窗取得前景控制權。
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
- `KeyHoldMs` (40 ms)：每個導航鍵維持按下狀態的時間。
- `KeyDelayMs` (60 ms)：每個獨立按鍵脈衝放開後的間隔，避免自繪清單漏接連續按鍵。
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
  7. 點擊前以 `CaptureCsvState(outDir)` 擷取既有 CSV 的路徑與內容簽章基準。
  8. `ClickExportBtn()` 點擊「資料匯出」按鈕（優先圖像搜尋 `資料匯出.png`，失敗降級採用 `settings.ini` 之 `[ExportButton]` 座標），點擊後立即移開滑鼠。
  9. `WaitNewCsv(outDir, baseline)` 尋找相較基準新增或內容已改變的 CSV，並以 `IsFileReady` 與連續兩次相同簽章確認寫入完成。
  10. `CopyToDateDir(csv, GetAfterRankDstRoot(), dateStr)`：複製覆蓋至 `<專案>\盤後排行\YYYYMMDD\<原始檔名>`。

### 3.5 批次全項目匯出 (`ExportAfterRankAll`)
- **函式簽名**：`ExportAfterRankAll(showMsgBox := true)`。
- **前置驗證**：
  - 檢驗主顯示器解析度（支援 1920x1080 與 2560x1440）與該解析度下之必備圖檔（`盤後下拉L.png`、`盤後下拉R.png`、`資料匯出.png`）。
  - 若解析度不符或圖檔缺失，記錄 WARN 日誌並中止（`aborted := true`）。
- **日期目錄決定**：批次開始時決定一次 `dateStr := FormatTime(A_Now, "yyyyMMdd")`，整批共用。
- **既有 CSV 衝突隔離**：批次開始前暫存 OUT 目錄既有 CSV；結束時恢復未被取代的檔案，同名舊版保留於 `logs\out-backups\`，避免三竹拒絕覆寫後觸發同項重試。
- **巢狀執行與失敗熔斷**：
  - 外迴圈走訪分類 `itemNoL := 1..TotalItemsL` (5)。
  - 若外層分類 `itemNoL` 選取失敗：實施**立即熔斷 (Circuit Breaking)**，跳過該分類底下的所有子項目，並將其全部子項目（如 `L1-R1` ~ `L1-R10`）一次性記錄至失敗清單，避免級聯式的盲目重試。
  - 內迴圈走訪所屬子項目 `itemNoR := 1..TotalItemsR{L}`。
- **摘要回報**：
  - 全程記錄於 `logs/app.log`。
  - 依 `showMsgBox` 決定是否彈出最終統計摘要（成功數 / 總數，失敗項目清單）。
  - 同一時間僅允許一個熱門排行或盤後排行批次；執行期間按 `Esc` 可要求在安全檢查點中止。

---

## 4. 設定檔結構 (`config/settings.ini`，UTF-16 LE)

```ini
[AfterMarketRanking]
ClickX_1920x1080 = 78
ClickY_1920x1080 = 110
ClickX_2560x1440 = 78
ClickY_2560x1440 = 110
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
  - 「匯出盤後排行」由 `MenuAfterRankExportHnd` 啟動批次匯出。
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

```
`LESSONS_LEARNED.md`:

```md
# 實機驗證 Lessons Learned

## 2026-10-09：熱門排行與盤後排行完整匯出驗證

驗證環境為 Windows 11、主顯示器 `2560x1440`、AutoHotkey v2。托盤的「切換至 熱門排行」、「切換至 盤後排行」、「匯出熱門排行」與「匯出盤後排行」均已完成實機驗證；熱門排行 44 項與盤後排行 36 項皆可完整執行。

### 1. 展開自繪選單後，前景 HWND 不再是主視窗

- **症狀**：第一層「證券行情」可成功點擊，但第二層「熱門排行／盤後排行」無法搜尋或點擊。
- **證據**：`logs/app.log` 顯示第一層圖像辨識成功，隨即出現「目標視窗未在前景」並拒絕第二次操作。
- **根因**：三竹展開自繪選單後，前景 HWND 會切換到同程序的無標題或同 RootOwner 浮層。只接受主視窗 HWND 的安全檢查會誤判此狀態。
- **修正**：以 `GetSafeForegroundContext` 驗證目標本身或可信的同程序浮層；ImageSearch 的 Client 範圍與實體點擊座標必須以實際前景浮層為準。
- **不可破壞的不變條件**：選單展開後不得再次 `WinActivate`／`WinMaximize` 主視窗，否則浮層會被關閉；不同程序或其他具名三竹子視窗仍必須拒絕。

### 2. 自繪下拉清單會漏接過快的連續方向鍵

- **症狀**：前兩項可選取，第 3 項起持續停在第 2 項。
- **根因**：快速連續 `SendInput` 時，自繪清單只處理第一個 `{Down}`，後續按鍵遭忽略。
- **修正**：以 `BuildDropdownNavPlan` 建立確定的導航序列，再由 `SendDropdownKeyPulse` 使用 `SendEvent` 分別送出 KeyDown、停留 40 ms、KeyUp 及間隔 60 ms。
- **歸位策略**：熱門排行使用 5 次 `{PgUp}`；盤後排行使用 `{Home}` 加 5 次 `{PgUp}` 雙重保險，之後才送出 `(itemNo - 1)` 個獨立 `{Down}`。
- **診斷要求**：每項操作需記錄 `PgUp×N`、`Down×N`，讓日誌可直接核對目標序號與實際導航計畫。

### 3. OUT 目錄已有同名 CSV 時，三竹可能不重新寫入

- **症狀**：選單已正確向下移動，但每個項目仍會被點擊匯出三次才進入下一項。
- **證據**：每次點擊後均完整等待 10 秒，`WaitNewCsv` 找不到新增或變更檔案，隨後進入兩次重試。
- **根因**：`USER\OUT` 已有同名 CSV 時，三竹可能只開啟既有檔案而不覆寫；這不是檔案時間精度問題，增加輪詢時間或重試次數無法解決。
- **修正**：批次開始前由 `StageExistingCsvs` 暫存 OUT 頂層既有 CSV；結束或異常中止時由 `FinalizeCsvStage` 恢復未被取代的檔案。
- **資料安全**：新匯出檔保留在 OUT；同名舊版不刪除，保留於 `logs\out-backups\`；無衝突舊檔自動恢復。

## 維護準則

1. 實機問題先依 `logs/app.log` 判斷失敗階段：視窗焦點、選單導航、匯出點擊、CSV 偵測不可混為同一類重試。
2. 重試只處理暫時性失敗，不可用來遮蔽確定性的狀態衝突；例如同名檔存在必須先隔離，而不是重複點擊。
3. 無頭測試驗證決策邏輯與檔案生命週期；真實 HWND、滑鼠、鍵盤與自繪 UI 行為仍須由獨立實機工具或托盤流程驗證。
4. 任何涉及既有 CSV 的處理都必須可復原，不直接刪除使用者資料。
5. 熱門排行與盤後排行共用相同底層導航、焦點與檔案隔離原語，修正其中一條流程時必須同步回歸另一條流程。

## 回歸保護

- `Test_TrustedForegroundMeta`：驗證同 RootOwner／同程序無標題浮層可操作，其他程序與具名子視窗必須拒絕。
- `Test_DropdownNavigationPlan`：驗證第 N 項確實產生 `N-1` 個獨立 `{Down}`，並保留熱門與盤後排行各自的歸位策略。
- `Test_CsvStagingAvoidsExistingNameConflict`：驗證既有 CSV 可暫存、無衝突檔可恢復、同名舊版可保留且新檔不被覆蓋。
- 2026-10-09 無頭回歸結果：`136 Total, 136 Passed, 0 Failed`；實機驗證補足背景 Session 無法測試的 HWND、滑鼠、鍵盤及自繪 UI 行為。

## 已知後續工作

- 三竹每匯出一個 CSV 仍可能另外呼叫 Excel。後續需依 [TODO.md](TODO.md) 實作「只關閉本批次新增 Excel」的安全清理流程，不得影響批次開始前既有的 Excel 與活頁簿。

```
`Mitake.ahk`:

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

; 通用 WinTitle 維持部分比對；三竹相關視窗一律由 FindMitakeWin 進行程序與標題精確匹配
SetTitleMatchMode(2)
DetectHiddenWindows(false)

#Include lib\utils.ahk
#Include lib\window_control.ahk
#Include lib\export.ahk

; 初始化腳本與系統托盤 (Tray)
A_IconTip := "三竹股市 AutoHotkey 控制專案"
A_TrayMenu.Add() ; 分隔線
A_TrayMenu.Add("啟動/切換 三竹股市", MenuLaunchHnd)
A_TrayMenu.Add("切換至 熱門排行", MenuPopRankHnd)
A_TrayMenu.Add("切換至 盤後排行", MenuAfterRankHnd)
A_TrayMenu.Add("匯出熱門排行", MenuPopRankExportHnd)
A_TrayMenu.Add("匯出盤後排行", MenuAfterRankExportHnd)
A_TrayMenu.Add("顯示系統解析度", MenuShowResHnd)
A_TrayMenu.Default := "啟動/切換 三竹股市"

; 註冊 ShellHook 監聽視窗切換與焦點事件，只自動最大化精確識別的三竹股市視窗
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), ShellMsg)

ShellMsg(wParam, lParam, *) {
    ; HSHELL_WINDOWACTIVATED = 4, HSHELL_RUDEAPPACTIVATED = 32772 (0x8004)
    if (wParam == 4 || wParam == 32772) {
        try {
            proc := WinGetProcessName(lParam)
            winTitle := WinGetTitle(lParam)
            procCfg := GetCfg("App", "ProcessName", "三竹股市.exe")
            if ShouldMaximizeMitakeWin(proc, winTitle, procCfg) && WinGetMinMax(lParam) != 1 {
                WinMaximize(lParam)
            }
        }
    }
}

RunUiAction(desc, handler) {
    if IsExportRunActive() {
        LogMsg(Format("忽略「{1}」：目前正在執行匯出作業", desc), "WARN")
        return false
    }
    return handler.Call()
}

#HotIf IsExportRunActive()
$Esc:: RequestExportCancel()
#HotIf

; 註冊快捷鍵輔助函式
RegisterHk(cfgKey, defKey, desc, handler) {
    hk := GetCfg("Hotkey", cfgKey, defKey)
    if (hk != "") {
        try {
            Hotkey(hk, handler)
            LogMsg(Format("已成功設定{1}快捷鍵: {2}", desc, hk), "INFO")
        } catch as err {
            LogMsg(Format("綁定{1}快捷鍵 [{2}] 失敗: {3}", desc, hk, err.Message), "WARN")
        }
    }
}

; 快捷鍵與功能對應表
hkDefs := [
    {cfg: "LaunchHotkey",             def: "^!m", desc: "啟動",     hnd: MenuLaunchHnd},
    {cfg: "MenuBarHotkey",            def: "^!b", desc: "選單列",   hnd: MenuToggleBarHnd},
    {cfg: "SecuritiesQuoteHotkey",    def: "",    desc: "證券行情", hnd: MenuSecQuoteHnd},
    {cfg: "PopularRankingHotkey",     def: "",    desc: "熱門排行", hnd: MenuPopRankHnd},
    {cfg: "AfterMarketRankingHotkey", def: "",    desc: "盤後排行", hnd: MenuAfterRankHnd},
    {cfg: "PopRankExportHotkey",      def: "",    desc: "匯出熱門排行", hnd: (*) => ExportPopRankAll()},
    {cfg: "AfterRankExportHotkey",    def: "",    desc: "匯出盤後排行", hnd: (*) => ExportAfterRankAll()}
]

for item in hkDefs {
    RegisterHk(item.cfg, item.def, item.desc, item.hnd)
}

mainRes := GetRes()
LogMsg(Format("三竹股市 AutoHotkey 控制腳本載入完成。主顯示器解析度: {1}", mainRes.str), "INFO")

; 執行主程序：啟動或切換至三竹股市
LaunchMitake()

; 托盤選單處理函式 (保持命名兼容性)
MenuLaunchHnd(*)   => RunUiAction("啟動/切換 三竹股市", LaunchMitake)
MenuToggleBarHnd(*) => RunUiAction("切換選單列", ToggleMenuBar)
MenuSecQuoteHnd(*)  => RunUiAction("證券行情", ClickSecQuoteMenu)
MenuPopRankHnd(*)   => RunUiAction("熱門排行", SwitchToPopRankWin)
MenuAfterRankHnd(*)  => RunUiAction("盤後排行", SwitchToAfterRankWin)
MenuAfterRankExportHnd(*) => ExportAfterRankAll()
MenuPopRankExportHnd(*)   => ExportPopRankAll()

MenuShowResHnd(*) {
    if IsExportRunActive() {
        LogMsg("匯出作業進行中，暫不顯示解析度視窗", "WARN")
        return false
    }
    displays := GetAllRes()
    info := ""
    for idx, d in displays {
        info .= Format("顯示器 #{1}: {2} ({3}x{4}) {5}`n", idx, d.str, d.width, d.height, d.isPrimary ? "[主顯示器]" : "")
    }
    MsgBox(info, "系統顯示器解析度資訊", "Iconi")
    return true
}

```
`README.md`:

```md
# Mitake 三竹股市自動化

使用 AutoHotkey v2 操作「三竹股市電腦版」，自動開啟／切換視窗，並批次匯出「熱門排行」與「盤後排行」CSV。

## 環境需求

- Windows 11
- AutoHotkey v2：`C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`
- 三竹股市電腦版：預設 `D:\Program Files\MitakeGU\三竹股市.exe`
- 主顯示器解析度必須為 `1920x1080` 或 `2560x1440`

## 快速開始

1. 確認 [config/settings.ini](config/settings.ini) 中的程式路徑、匯出目錄與解析度座標。
2. 執行 `Mitake.ahk`。
3. 由系統托盤選擇「匯出熱門排行」或「匯出盤後排行」。
4. 匯出執行期間可按 `Esc` 要求安全中止；同一時間只允許一個匯出作業。
5. 結果會寫入 `熱門排行\YYYYMMDD\` 或 `盤後排行\YYYYMMDD\`，執行紀錄位於 `logs\app.log`。

批次開始前，腳本會暫存三竹 `USER\OUT` 中既有的 CSV，避免三竹因同名檔已存在而拒絕重新輸出。未被本次輸出取代的檔案會在結束時恢復；同名舊版會保留在 `logs\out-backups\` 供復原。

> 執行期間請勿操作三竹視窗、滑鼠或鍵盤。腳本不執行下單，但會實際控制桌面與點擊三竹介面。

## 測試

```powershell
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$p = Start-Process -FilePath "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" `
  -ArgumentList '/ErrorStdOut', 'tests\run_tests.ahk' `
  -NoNewWindow -PassThru -Wait
exit $p.ExitCode
```

`tests/run_tests.ahk` 僅執行無頭單元測試，不會點擊真實桌面。需要實機驗證時，另行執行：

- `tests/test_pop_rank_export.ahk`
- `tests/test_after_rank_export.ahk`
- `tests/test_coords_click.ahk`
- `tests/diagnose_export_btn.ahk`

## 後續工作

- [ ] 匯出每個新 CSV 後，安全關閉本批次由三竹新開啟的 Excel；不得關閉使用者原本已開啟的 Excel。詳見 [TODO.md](TODO.md)。

## 文件

- [熱門排行匯出規格](pop_rank_export_spec.md)
- [盤後排行匯出規格](After%20Rank%20Export%20Spec.md)
- [實機驗證 Lessons Learned](LESSONS_LEARNED.md)
- [後續工作](TODO.md)
- [命名縮寫表](ABBREVIATIONS.md)
- [開發與自動化注意事項](agents.md)

```
`TODO.md`:

```md
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


```
`agents.md`:

```md
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

## 專案結構 (Directory Structure)

```text
三竹/
├── README.md                 # 專案初始化與說明文件
├── AGENTS.md                 # 專案 AI Agent 指引與規範文件
├── ABBREVIATIONS.md          # 變數與函式命名縮寫對照表
├── LESSONS_LEARNED.md        # 實機驗證問題、根因、修正與維護準則
├── TODO.md                   # 後續功能、風險邊界與驗收條件
├── pop_rank_export_spec.md   # 熱門排行匯出規格與設計共識文件
├── After Rank Export Spec.md # 盤後排行匯出規格與設計說明書
├── prompt.md                 # AI 提詞與專案程式碼快照 (code2prompt 產生)
├── Mitake.ahk                # 主程式進入點 (Main entry)
├── assets/                   # 圖像辨識與圖資目錄 (支援 1920x1080 / 2560x1440)
│   ├── 1920x1080/            # 1920x1080 解析度圖檔 (下拉箭頭、選單、資料匯出等)
│   └── 2560x1440/            # 2560x1440 解析度圖檔 (下拉箭頭、選單、資料匯出等)
├── config/                   # 設定檔目錄
│   └── settings.ini          # 專案參數與設定檔 (UTF-16 LE)
├── lib/                      # 模組與函式庫 (功能模組)
│   ├── window_control.ahk    # 三竹股市視窗控制與圖像搜尋模組
│   ├── export.ahk            # 熱門排行/盤後排行匯出模組 (CSV 輪詢與複製)
│   └── utils.ahk             # 通用工具函式 (Log、編碼維護、解析度取得等)
├── tests/                    # 測試與驗證目錄 (TDD 測試案例、實機工具與 Test Runner)
│   ├── run_tests.ahk         # 自動化測試執行器入口 (無頭測試回歸閘門)
│   ├── test_utils.ahk        # utils.ahk 單元測試集
│   ├── test_window_control.ahk # window_control.ahk 單元測試集
│   ├── test_export.ahk       # export.ahk 無頭單元測試集 (暫存目錄測試)
│   ├── test_pop_rank_export.ahk # 熱門排行匯出手動實機驗證腳本
│   ├── test_after_rank_export.ahk # 盤後排行匯出手動實機驗證腳本
│   ├── test_coords_click.ahk # 實機座標校正與 ToolTip 浮動標籤提示工具
│   ├── capture_asset.ahk     # 介面資產截圖輔助腳本
│   ├── diagnose_export_btn.ahk # 資料匯出按鈕點擊診斷腳本
│   └── helpers/              # 測試輔助模組 (斷言庫)
│       └── assert.ahk
├── bypass.bat                # 三竹匯出後呼叫之關聯程式 (立即結束，阻止 Excel 開啟)
├── logs/                     # 執行日誌輸出 (app.log 等)
├── 熱門排行/                 # "熱門排行"所有項目匯出檔 (YYYYMMDD 子資料夾)
└── 盤後排行/                 # "盤後排行"所有項目匯出檔 (YYYYMMDD 子資料夾)
```

---

## 核心功能規劃 (Roadmap & Feature List)

- [x] **視窗啟動與鎖定**：偵測「三竹股市電腦版」是否已開啟，若否則自動啟動。
- [x] **熱門排行**：對「證劵行情」→「熱門排行」的所有項目均執行匯出檔案。詳參 `pop_rank_export_spec.md`。
- [x] **盤後排行**：對「證劵行情」→「盤後排行」的所有項目均執行匯出檔案。詳參 `After Rank Export Spec.md`。
- [ ] **匯出後 Excel 清理**：每個 CSV 匯出完成後關閉本批次由三竹新開啟的 Excel，並保護批次開始前已存在的 Excel。詳參 `TODO.md`。

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
   - 跨模組重構識別碼時，務必建立專案級縮寫對照表（[ABBREVIATIONS.md](ABBREVIATIONS.md)），底層模組、主程式與測試集同步更新，並以 `run_tests.ahk` 作為全域回歸閘門驗證 0 錯誤。
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
   - **解決方案**：改用多次（如 5 次）`{PgUp}` 向上翻頁作為首項歸位機制，再向下按 `{Down}` 遞增定位（盤後排行可加 `{Home}` 作雙重保險）。每個導航鍵必須透過 `SendEvent` 分別送出 KeyDown、短暫停留、KeyUp 與按鍵間隔；不可用過快的連續 `SendInput`，否則自繪清單可能只接到第一個 `{Down}`，使第 3 項之後持續停在第 2 項。
14. **滑鼠停懸 (Hover) 狀態干擾與純淨影像裁切準則 (Tight Cropping)**：
   - **Hover 色偏陷阱**：滑鼠點擊下拉箭頭或按鈕後若游標停留在原地，元件會進入 Hover 高亮狀態（底色、邊框或反鋸齒陰影變更），導致後續搜尋原始未停懸圖檔時引發連鎖式匹配失敗。
   - **防護措施**：點擊任何按鈕或確認選取後，立即將游標移至視窗角落空白區（如 `(10, 10)`）解除 Hover 狀態。
   - **圖檔純淨度**：截取資產圖檔時嚴禁包含周圍易隨視窗狀態或主題色變更的外圍邊界（如標題列藍條、外部黑邊），應僅保留按鈕核心圖示（如 24x30 純圖示），確保各狀態下最高的辨識穩定度。
15. **自動化批次重試之乾淨狀態復原 (Clean State Reset)**：
   - 當單一項目執行失敗進入重試循環時，若前一次殘留的自繪下拉浮層仍呈展開狀態，直接重新點擊會點在浮層上遮擋底層控制項，引發連鎖失敗。
   - **解決方案**：在每次進入重試或單項操作開頭，必須呼叫狀態復原常式（`ResetPopRankState` / `ResetAfterRankState`）：送出 `{Esc}` 強制關閉可能殘留的自繪浮層，並移開游標，確保每次重試均處於乾淨的基準環境。
16. **關聯程式外部焦點搶奪防禦 (External Focus Theft Defense)**：
   - **現象**：三竹在點擊「資料匯出」後會呼叫系統關聯應用，即便配置 `bypass.bat` 攔截，系統或背景進程仍可能非同步喚醒 Excel 或第三方應用奪取前台焦點。
   - **陷阱**：在後續子項目操作中，若單純依賴圖像搜尋座標發送滑鼠或鍵盤事件，事件會直接打在被搶走的外部視窗上，導致連鎖操作落空。
   - **解決方案**：在子項目操作與下拉展開的每道工序起點，必須將視窗聚焦邏輯（`SwitchToSubWin` / `ActivateMitake`）作為第一道防線防禦性奪回焦點，確保前台控制權始終鎖定於三竹子視窗。
17. **二維階層批次之失敗級聯隔離與熔斷 (Hierarchical Failure Cascading & Circuit Breaking)**：
   - **現象**：盤後排行等功能屬於 $L \times R$ 的巢狀階層結構（5 個分類 $\times$ 4~10 個子項目，共 36 項）。若外層分類 $L$ 選取失敗（如動畫渲染延遲或自繪下拉未命中），若未進行架構隔離，內層迴圈仍會盲目執行該分類底下的所有子項目，導致每個子項目均經歷完整的重試與逾時輪詢，造成長達數分鐘的無效阻塞。
   - **解決方案**：外層分類 $L$ 在重試耗盡失敗時應實施立即熔斷（Circuit Breaking），跳過內層迴圈，並將所屬預期子項目（如 `L1-R1` ~ `L1-R10`）一次性記錄至失敗清單後繼續下一分類，兼顧批次處理效能與統計報表精確度。
18. **匯出 OUT 目錄同名檔衝突隔離**：
   - 三竹遇到 OUT 目錄已有同名 CSV 時，可能只開啟既有檔而不重新寫入。若以檔案變更作為成功判定，流程會逾時並重複點擊同一項目。
   - 批次開始前必須以 `StageExistingCsvs` 將頂層既有 CSV 暫存至可復原備份；結束或異常時以 `FinalizeCsvStage` 恢復未被取代的檔案，同名舊版保留備份，不可直接刪除。

### 五、 測試架構與實機驗證工具隔離 (Test Architecture & Tooling)

19. **資料驅動測試套件重構 (Data-Driven Test Suite Pattern)**：
   - 多解析度、多資產與多座標的驗證若逐條複製貼上斷言，會導致測試代碼膨脹且難以擴展。
   - 解決方案：改採資料驅動測試結構，以案例陣列（`cases := [{...}]`）配合迴圈動態檢驗，不僅提升測試可讀性與擴展性，也能輸出更具語意化的動態失敗除錯訊息。
20. **無頭自動化測試與手動實機驗證工具之架構隔離**：
   - **無頭自動化測試**：`tests/run_tests.ahk` 作為持續整合與版本回歸閘門，必須保持純淨、快速且無阻斷式彈窗；業務函式應提供 UI 抑制參數（`showMsgBox := false`）。
   - **手動實機驗證工具**：涉及真實桌面焦點切換、滑鼠軌跡與確認彈窗的實機校正需求，應獨立建置專用腳本（`tests/test_coords_click.ahk`），搭配平滑游標移動（`MouseMove(x, y, 10)`）與 `ToolTip` 浮動標籤提示目標名稱與落點座標，兼顧除錯直觀性而不干擾全域測試。
21. **背景 Session 與互動式桌面隔離限制 (Session Isolation & UIPI)**：
   - 命令列終端（PowerShell / 背景 Task）受限於 Windows Session 隔離機制，無法直接枚舉或控制真實使用者互動桌面上的 GUI 視窗（`WinGetList` / `WinActive` 會回傳 0）。
   - 單元測試焦點切換應以 `WinExist` 及函式回傳值驗證，避免依賴無桌面環境下的 `WinActive`；定位疑難問題時，以實體執行日誌 `logs/app.log` 留下的真實軌跡為準。

### 六、 實機驗證結論

- 2026-10-09 已完成熱門排行 44 項與盤後排行 36 項的完整托盤批次驗證。
- 自繪選單前景 HWND、導航按鍵節流及 OUT 同名 CSV 衝突的完整症狀、證據、根因與修正紀錄，統一維護於 [LESSONS_LEARNED.md](LESSONS_LEARNED.md)。

---

## 注意事項與免責聲明 (Disclaimer)

1. 本專案僅供個人自動化操作輔助與技術研究使用。
2. 涉及股票看盤與交易相關操作時，請務必謹慎確認腳本邏輯，避免誤觸下單或操作錯誤。

```
`bypass.bat`:

```bat
@echo off
:: 這個腳本被三竹呼叫後會直接閃退，藉此阻止 Excel 自動開啟
:: 最新生成的 CSV 檔案仍會順利保存在 MitakeGU\USER\OUT\ 資料夾中

exit

```
`config\settings.ini`:

```ini
[App]
Path = D:\Program Files\MitakeGU\三竹股市.exe
ProcessName = 三竹股市.exe
WinTitle = 三竹股市
MainWinTitle = 三竹股市
PopularRankingWinTitle = 熱門排行
AfterMarketRankingWinTitle = 盤後排行
Timeout = 15

[Hotkey]
LaunchHotkey = ^!m
MenuBarHotkey = ^!b
SecuritiesQuoteHotkey = 
PopularRankingHotkey = 
AfterMarketRankingHotkey = 
PopRankExportHotkey = 
AfterRankExportHotkey = 

[MenuBar]
TriggerMode = click
TriggerKey = {Alt}
ClickX_1920x1080 = 35
ClickY_1920x1080 = 45
ClickX_2560x1440 = 35
ClickY_2560x1440 = 45

[SecuritiesQuote]
ClickX_1920x1080 = 337
ClickY_1920x1080 = 15
ClickX_2560x1440 = 337
ClickY_2560x1440 = 14

[PopularRanking]
ClickX_1920x1080 = 77
ClickY_1920x1080 = 80
ClickX_2560x1440 = 78
ClickY_2560x1440 = 80
TotalItems = 44
OutDir = D:\Program Files\MitakeGU\USER\OUT

[AfterMarketRanking]
ClickX_1920x1080 = 78
ClickY_1920x1080 = 110
ClickX_2560x1440 = 78
ClickY_2560x1440 = 110
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
```
`lib\export.ahk`:

```ahk
#Requires AutoHotkey v2.0

; =============================================================================
; 匯出模組：對「熱門排行」各項目執行「資料匯出」並將 CSV 複製至專案目錄
; 三竹匯出後呼叫的關聯程式由 bypass.bat 立即結束，CSV 會留在 USER\OUT\ 目錄
; =============================================================================

/**
 * 匯出流程時序常數 (依設計共識直接寫在程式內，非 settings.ini 配置)
 */
class ExportTiming {
    static RefreshDelayMs := 1500   ; Enter 選取項目後等待資料刷新
    static DropOpenDelayMs := 300   ; 點擊下拉箭頭後等待清單展開
    static KeyHoldMs := 40          ; 自繪清單需辨識完整的按下／放開事件
    static KeyDelayMs := 60         ; 每次按鍵脈衝放開後的間隔
    static TimeoutMs := 10000       ; 輪詢匯出 CSV 之逾時
    static PollMs := 200            ; 輪詢間隔
    static MaxRetries := 2          ; 單一項目失敗後最多重試次數
}

class ExportRunState {
    static Busy := false
    static CancelRequested := false
    static Kind := ""
}

/**
 * 建立自繪下拉清單的鍵盤導航計畫。
 * 每個 Down 都保留為獨立脈衝，避免 SendInput 合併或三竹忽略連續快速按鍵。
 */
BuildDropdownNavPlan(itemNo, includeHome := false) {
    plan := []
    if includeHome
        plan.Push("Home")
    Loop 5
        plan.Push("PgUp")
    Loop itemNo - 1
        plan.Push("Down")
    plan.Push("Enter")
    return plan
}

SendDropdownKeyPulse(keyName) {
    SendEvent("{" keyName " down}")
    Sleep(ExportTiming.KeyHoldMs)
    SendEvent("{" keyName " up}")
    Sleep(ExportTiming.KeyDelayMs)
}

ExecuteDropdownNav(itemNo, includeHome := false) {
    plan := BuildDropdownNavPlan(itemNo, includeHome)
    for keyName in plan {
        if IsExportCancelled()
            return false
        SendDropdownKeyPulse(keyName)
    }
    return true
}

IsExportRunActive() => ExportRunState.Busy
IsExportCancelled() => ExportRunState.CancelRequested

SetExportUiEnabled(enabled) {
    for itemName in ["啟動/切換 三竹股市", "切換至 熱門排行", "切換至 盤後排行", "匯出熱門排行", "匯出盤後排行"] {
        try enabled ? A_TrayMenu.Enable(itemName) : A_TrayMenu.Disable(itemName)
    }
}

BeginExportRun(kind, showMsgBox := true) {
    if ExportRunState.Busy {
        msg := Format("無法啟動{1}：目前正在執行{2}", kind, ExportRunState.Kind)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "匯出作業進行中", "Icon!")
        return false
    }
    ExportRunState.Busy := true
    ExportRunState.CancelRequested := false
    ExportRunState.Kind := kind
    SetExportUiEnabled(false)
    return true
}

RequestExportCancel() {
    if !ExportRunState.Busy
        return false
    ExportRunState.CancelRequested := true
    LogMsg(Format("使用者要求中止{1}", ExportRunState.Kind), "WARN")
    return true
}

EndExportRun() {
    SetExportUiEnabled(true)
    ExportRunState.Busy := false
    ExportRunState.CancelRequested := false
    ExportRunState.Kind := ""
}

/**
 * 熱門排行匯出所需之圖檔 (須存在於 assets/{解析度}/)
 */
PopRankAssets() => ["熱門下拉.png", "資料匯出.png"]

/**
 * 取得「熱門排行」下拉清單項目總數
 * @returns {Integer} 項目總數 (settings.ini [PopularRanking] TotalItems，預設 44)
 */
GetPopRankTotalItems() {
    val := GetCfg("PopularRanking", "TotalItems", "44")
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : 44
}

/**
 * 取得三竹匯出 CSV 之輸出目錄
 * @param {String} section INI 區段名稱 (例: "PopularRanking")
 * @returns {String} 輸出目錄 (預設 D:\Program Files\MitakeGU\USER\OUT)
 */
GetExportOutDir(section) {
    return RTrim(GetCfg(section, "OutDir", "D:\Program Files\MitakeGU\USER\OUT"), "\")
}

/**
 * 取得熱門排行匯出檔之專案目的根目錄
 * @returns {String} <專案根目錄>\熱門排行
 */
GetPopRankDstRoot() {
    return GetRootDir() "\熱門排行"
}

/**
 * 取得 CSV 的修改時間、大小與內容雜湊簽章
 * @param {String} path CSV 完整路徑
 * @returns {String} 簽章，讀取失敗則回傳空字串
 */
GetCsvSignature(path) {
    try {
        raw := FileRead(path, "RAW")
        hash := 2166136261
        Loop raw.Size {
            hash := ((hash ^ NumGet(raw, A_Index - 1, "UChar")) * 16777619) & 0xFFFFFFFF
        }
        return FileGetTime(path, "M") "|" raw.Size "|" hash
    } catch {
        return ""
    }
}

CaptureCsvState(outDir) {
    state := Map()
    state.CaseSense := false
    if !DirExist(outDir)
        return state
    Loop Files, outDir "\*.csv" {
        sig := GetCsvSignature(A_LoopFileFullPath)
        if (sig != "")
            state[A_LoopFileFullPath] := sig
    }
    return state
}

/**
 * 批次前將 OUT 目錄既有 CSV 移至可復原備份，避免三竹遇到同名檔時不重新寫入。
 * @returns {Object} {outDir, stageDir, names}
 */
StageExistingCsvs(outDir, kind, backupRoot := "") {
    state := {outDir: outDir, stageDir: "", names: []}
    if !DirExist(outDir)
        return state

    existing := []
    Loop Files, outDir "\*.csv"
        existing.Push(A_LoopFileFullPath)
    if (existing.Length == 0)
        return state

    if (backupRoot == "")
        backupRoot := GetRootDir() "\logs\out-backups"
    safeKind := RegExReplace(kind, "[\\/:*?`"<>|]", "_")
    stageDir := backupRoot "\" FormatTime(A_Now, "yyyyMMdd_HHmmss") "_" safeKind "_" DllCall("GetCurrentProcessId") "_" A_TickCount
    DirCreate(stageDir)
    state.stageDir := stageDir

    try {
        for src in existing {
            SplitPath(src, &fileName)
            FileMove(src, stageDir "\" fileName)
            state.names.Push(fileName)
        }
    } catch as err {
        FinalizeCsvStage(state)
        throw Error(Format("暫存既有 CSV 失敗：{1}", err.Message))
    }

    LogMsg(Format("{1}：已暫存 OUT 目錄既有 CSV 共 {2} 個至 {3}", kind, state.names.Length, stageDir), "INFO")
    return state
}

/**
 * 批次結束後恢復未被新輸出取代的 CSV；同名舊檔保留於備份目錄。
 * @returns {Integer} 保留於備份目錄的同名舊檔數量
 */
FinalizeCsvStage(state) {
    if !IsObject(state) || state.stageDir == "" || !DirExist(state.stageDir)
        return 0

    conflicts := 0
    for fileName in state.names {
        staged := state.stageDir "\" fileName
        if !FileExist(staged)
            continue
        target := state.outDir "\" fileName
        if FileExist(target) {
            conflicts++
            continue
        }
        try FileMove(staged, target)
        catch as err {
            conflicts++
            LogMsg(Format("恢復暫存 CSV 失敗 ({1} → {2}): {3}", staged, target, err.Message), "ERROR")
        }
    }

    hasRemaining := false
    Loop Files, state.stageDir "\*.csv" {
        hasRemaining := true
        break
    }
    if !hasRemaining {
        try DirDelete(state.stageDir)
    } else {
        LogMsg(Format("同名舊 CSV 已保留於備份目錄：{1}", state.stageDir), "INFO")
    }
    return conflicts
}

/**
 * 尋找相較於基準快照新增或內容已變更的最新 CSV
 * 相容舊測試與工具傳入 YYYYMMDDHH24MISS 時間字串。
 * @param {String} outDir 輸出目錄
 * @param {Map|String} sinceOrBaseline CSV 基準快照或起始時間
 * @returns {String} CSV 完整路徑，找不到則回傳空字串
 */
FindNewCsv(outDir, sinceOrBaseline) {
    if !DirExist(outDir)
        return ""
    useBaseline := Type(sinceOrBaseline) == "Map"
    newest := "", newestTime := "", newestCreated := ""
    Loop Files, outDir "\*.csv" {
        t := A_LoopFileTimeModified
        created := A_LoopFileTimeCreated
        isCandidate := false
        if useBaseline {
            sig := GetCsvSignature(A_LoopFileFullPath)
            isCandidate := sig != "" && (!sinceOrBaseline.Has(A_LoopFileFullPath) || sinceOrBaseline[A_LoopFileFullPath] != sig)
        } else {
            isCandidate := t >= sinceOrBaseline
        }
        if (isCandidate && (newest == "" || t > newestTime || (t == newestTime && created > newestCreated))) {
            newest := A_LoopFileFullPath
            newestTime := t
            newestCreated := created
        }
    }
    return newest
}

/**
 * 判斷檔案是否已寫入完成 (可被獨佔開啟)
 * @param {String} path 檔案路徑
 * @returns {Boolean}
 */
IsFileReady(path) {
    try {
        f := FileOpen(path, "r -rwd")
        if !f
            return false
        f.Close()
        return true
    } catch {
        return false
    }
}

/**
 * 輪詢輸出目錄直到出現新的 CSV 且寫入完成，或逾時
 * @param {String} outDir 輸出目錄
 * @param {Map|String} sinceOrBaseline CSV 基準快照或相容用起始時間
 * @param {Integer} timeoutMs 逾時毫秒
 * @param {Integer} pollMs 輪詢間隔毫秒
 * @returns {String} CSV 完整路徑，逾時則回傳空字串
 */
WaitNewCsv(outDir, sinceOrBaseline, timeoutMs := 10000, pollMs := 200) {
    deadline := A_TickCount + timeoutMs
    lastPath := "", lastSig := "", stableCount := 0
    Loop {
        if IsExportCancelled()
            return ""
        csv := FindNewCsv(outDir, sinceOrBaseline)
        if (csv != "" && IsFileReady(csv)) {
            sig := GetCsvSignature(csv)
            if (csv == lastPath && sig != "" && sig == lastSig) {
                stableCount++
                if (stableCount >= 2)
                    return csv
            } else {
                lastPath := csv
                lastSig := sig
                stableCount := 1
            }
        }
        if (A_TickCount >= deadline)
            return ""
        Sleep(pollMs)
    }
}

/**
 * 將檔案複製至 dstRoot\dateStr\ (保留原檔名，同名覆蓋)
 * @param {String} src 來源檔案
 * @param {String} dstRoot 目的根目錄
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 目的檔完整路徑，失敗則回傳空字串
 */
CopyToDateDir(src, dstRoot, dateStr) {
    if !FileExist(src)
        return ""
    SplitPath(src, &fileName)
    dstDir := dstRoot "\" dateStr
    try {
        if !DirExist(dstDir)
            DirCreate(dstDir)
        dst := dstDir "\" fileName
        FileCopy(src, dst, true)
        return dst
    } catch as err {
        LogMsg(Format("複製匯出檔失敗 ({1} → {2}): {3}", src, dstDir, err.Message), "ERROR")
        return ""
    }
}

/**
 * 檢查指定解析度目錄下的圖檔是否齊全 (不使用跨解析度備援)
 * @param {Array} names 圖檔名稱清單
 * @param {String} resStr 解析度字串，預設為主顯示器解析度
 * @returns {Boolean}
 */
HasResAssets(names, resStr := "") {
    if (resStr == "")
        resStr := GetRes(0).str
    for name in names {
        if !FileExist(GetRootDir() "\assets\" resStr "\" name)
            return false
    }
    return true
}

/**
 * 重設「熱門排行」視窗狀態：
 * 送出 Esc 鍵關閉殘留下拉選單，並將滑鼠游標移至左上角空白區以清除按鈕 Hover 高亮狀態
 * @param {String|Integer} tgtWin 目標視窗 (預設抓取「熱門排行」)
 */
ResetPopRankState(tgtWin := "") {
    winTitle := (tgtWin != "") ? tgtWin : GetPopRankWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if (hwnd) {
        if (!WinActive(hwnd)) {
            WinActivate(hwnd)
            Sleep(50)
        }
        Send("{Esc}")
        Sleep(100)
        oldMouse := CoordMode("Mouse", "Client")
        MouseMove(10, 10, 0)
        CoordMode("Mouse", oldMouse)
        Sleep(50)
    }
}

/**
 * 點擊「資料匯出」按鈕：優先圖像辨識，失敗時退回 settings.ini [ExportButton] 之解析度座標
 * 若該解析度未設定座標 (0,0) 則不盲點，回傳 false
 * @param {String} winTitle 目標視窗
 * @param {Object} res 主顯示器解析度物件 (GetRes)
 * @returns {Boolean} 是否已點擊
 */
ClickExportBtn(winTitle, res) {
    exportImg := GetRootDir() "\assets\" res.str "\資料匯出.png"
    if FindClickImg(exportImg, 0, 0, res.width, res.height, 45, winTitle, true).found
        return true

    coords := GetResCoords("ExportButton", 0, 0, res.str)
    if (coords.x <= 0 || coords.y <= 0) {
        LogMsg(Format("資料匯出：圖像未比對到且 [ExportButton] 未設定 {1} 座標", res.str), "WARN")
        return false
    }
    if !ClickPoint(coords.x, coords.y, winTitle, false)
        return false
    LogMsg(Format("資料匯出：圖像未比對到，降級採用解析度 [{1}] 座標點擊 (X:{2}, Y:{3})", res.str, coords.x, coords.y), "WARN")
    return true
}

/**
 * 執行單次「熱門排行」單一項目匯出 (不含重試)
 * @param {Integer} itemNo 項目序號 (1 起算)
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 複製後的目的檔路徑，失敗則回傳空字串
 */
TryExportPopRankItem(itemNo, dateStr) {
    res := GetRes(0)
    winTitle := GetPopRankWinTitle()

    ; 0. 操作前重設狀態 (收合殘留下拉選單並移開滑鼠清除 Hover)
    ResetPopRankState(winTitle)

    ; 1. 切換至「熱門排行」視窗並最大化 (未開啟則自動開啟)
    if !SwitchToPopRankWin() {
        LogMsg(Format("熱門排行 #{1}：無法切換至熱門排行視窗", itemNo), "WARN")
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊下拉箭頭 (variation 設為 45 提升容許度)
    dropImg := GetRootDir() "\assets\" res.str "\熱門下拉.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("熱門排行 #{1}：找不到下拉箭頭", itemNo), "WARN")
        ResetPopRankState(winTitle)
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. PageUp × 5 次回首項 → 獨立 Down 脈衝 × (itemNo-1) → Enter
    LogMsg(Format("熱門排行 #{1}：下拉導航 PgUp×5、Down×{2}", itemNo, itemNo - 1), "INFO")
    if !ExecuteDropdownNav(itemNo)
        return ""

    ; 選取後立即移開滑鼠，避免游標停在按鈕上方造成 Hover 影響或干擾畫面
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)

    ; 7. 點擊資料匯出 (記錄觸發時間以辨識新產生的 CSV；圖像辨識失敗時退回 settings.ini 座標)
    outDir := GetExportOutDir("PopularRanking")
    baseline := CaptureCsvState(outDir)
    if !ClickExportBtn(winTitle, res) {
        LogMsg(Format("熱門排行 #{1}：找不到資料匯出按鈕", itemNo), "WARN")
        ResetPopRankState(winTitle)
        return ""
    }

    ; 點擊後再次移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 8. 輪詢輸出目錄取得新 CSV
    csv := WaitNewCsv(outDir, baseline, ExportTiming.TimeoutMs, ExportTiming.PollMs)
    if (csv == "") {
        if IsExportCancelled()
            return ""
        LogMsg(Format("熱門排行 #{1}：{2} 毫秒內未在 {3} 偵測到新 CSV", itemNo, ExportTiming.TimeoutMs, outDir), "WARN")
        ResetPopRankState(winTitle)
        return ""
    }

    ; 9. 複製至 熱門排行\YYYYMMDD\
    dst := CopyToDateDir(csv, GetPopRankDstRoot(), dateStr)
    if (dst != "")
        LogMsg(Format("熱門排行 #{1}：已匯出 {2}", itemNo, dst), "INFO")
    return dst
}

/**
 * 匯出「熱門排行」單一項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNo 項目序號 (1 起算)
 * @param {String} dateStr 日期子資料夾名稱 (預設為今日 YYYYMMDD)
 * @returns {Boolean} 是否成功
 */
ExportPopRankItem(itemNo, dateStr := "") {
    total := GetPopRankTotalItems()
    if (!IsInteger(itemNo) || itemNo < 1 || itemNo > total) {
        LogMsg(Format("熱門排行匯出：項目序號無效 ({1})", itemNo), "ERROR")
        return false
    }
    if (dateStr == "")
        dateStr := FormatTime(A_Now, "yyyyMMdd")

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("熱門排行 #{1}：第 {2} 次重試，先進行狀態重設", itemNo, A_Index - 1), "WARN")
            ResetPopRankState()
            Sleep(300)
        }
        try {
            if (TryExportPopRankItem(itemNo, dateStr) != "")
                return true
        } catch as err {
            LogMsg(Format("熱門排行 #{1}：執行異常 {2}", itemNo, err.Message), "ERROR")
        }
    }
    LogMsg(Format("熱門排行 #{1}：重試 {2} 次後仍失敗", itemNo, ExportTiming.MaxRetries), "ERROR")
    ResetPopRankState()
    return false
}

/**
 * 批次匯出「熱門排行」全部項目 (1..TotalItems)
 * @param {Boolean} showMsgBox 完成或中止時是否彈出提示視窗 (無頭測試時設為 false)
 * @returns {Object} {total: Integer, ok: Array, failed: Array, aborted: Boolean}
 */
ExportPopRankAll(showMsgBox := true) {
    total := GetPopRankTotalItems()
    if !BeginExportRun("熱門排行匯出", showMsgBox)
        return {total: total, ok: [], failed: [], aborted: true}
    stageState := ""
    try {
        stageState := StageExistingCsvs(GetExportOutDir("PopularRanking"), "熱門排行")
        return RunExportPopRankAll(showMsgBox)
    } catch as err {
        msg := Format("熱門排行匯出中止：{1}", err.Message)
        LogMsg(msg, "ERROR")
        if showMsgBox
            MsgBox(msg, "熱門排行匯出", "Icon!")
        return {total: total, ok: [], failed: [], aborted: true}
    } finally {
        if IsObject(stageState)
            FinalizeCsvStage(stageState)
        EndExportRun()
    }
}

RunExportPopRankAll(showMsgBox := true) {
    total := GetPopRankTotalItems()
    result := {total: total, ok: [], failed: [], aborted: false}

    ; 前置檢查：解析度與該解析度之圖檔
    res := GetRes(0)
    if !ValidatePriRes(showMsgBox) || !HasResAssets(PopRankAssets(), res.str) {
        msg := Format("熱門排行匯出中止：解析度 {1} 缺少圖檔 (assets\{1}\熱門下拉.png、資料匯出.png) 或不支援", res.str)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "熱門排行匯出", "Icon!")
        result.aborted := true
        return result
    }

    dateStr := FormatTime(A_Now, "yyyyMMdd")
    LogMsg(Format("熱門排行匯出開始：共 {1} 項，目的資料夾 {2}\{3}", total, GetPopRankDstRoot(), dateStr), "INFO")

    Loop total {
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        ok := ExportPopRankItem(A_Index, dateStr)
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        if ok
            result.ok.Push(A_Index)
        else
            result.failed.Push(A_Index)
    }

    failedStr := ""
    for n in result.failed
        failedStr .= (failedStr == "" ? "" : ", ") n
    summary := Format("熱門排行匯出{1}：成功 {2} / {3} 項{4}", result.aborted ? "已中止" : "完成", result.ok.Length, total
        , result.failed.Length ? "`n失敗項目：" failedStr : "")
    LogMsg(StrReplace(summary, "`n", "；"), result.aborted || result.failed.Length ? "WARN" : "INFO")
    if showMsgBox
        MsgBox(summary, "熱門排行匯出", result.aborted || result.failed.Length ? "Icon!" : "Iconi")
    return result
}

; =============================================================================
; 盤後排行匯出函式群 (左側分類 5 項，各分類所屬子項目數量不一)
; =============================================================================

/**
 * 盤後排行匯出所需之圖檔 (須存在於 assets/{解析度}/)
 */
AfterRankAssets() => ["盤後下拉L.png", "盤後下拉R.png", "資料匯出.png"]

/**
 * 取得「盤後排行」左側下拉清單項目總數
 * @returns {Integer} 項目總數 (settings.ini [AfterMarketRanking] TotalItemsL，預設 5)
 */
GetAfterRankTotalItemsL() {
    val := GetCfg("AfterMarketRanking", "TotalItemsL", "5")
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : 5
}

/**
 * 取得「盤後排行」指定左側項目對應之右側下拉清單項目總數
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Integer} 項目總數 (settings.ini [AfterMarketRanking] TotalItemsR{itemNoL}，預設依規格對照)
 */
GetAfterRankTotalItemsR(itemNoL := 1) {
    static defCounts := Map(1, 10, 2, 10, 3, 4, 4, 8, 5, 4)
    defVal := defCounts.Has(itemNoL) ? String(defCounts[itemNoL]) : "10"
    val := GetCfg("AfterMarketRanking", "TotalItemsR" itemNoL, defVal)
    return IsInteger(val) && Integer(val) > 0 ? Integer(val) : Integer(defVal)
}

/**
 * 取得盤後排行匯出檔之專案目的根目錄
 * @returns {String} <專案根目錄>\盤後排行
 */
GetAfterRankDstRoot() {
    return GetRootDir() "\盤後排行"
}

/**
 * 重設「盤後排行」視窗狀態：
 * 送出 Esc 鍵關閉殘留下拉選單，並將滑鼠游標移至左上角空白區以清除按鈕 Hover 高亮狀態
 * @param {String|Integer} tgtWin 目標視窗 (預設抓取「盤後排行」)
 */
ResetAfterRankState(tgtWin := "") {
    winTitle := (tgtWin != "") ? tgtWin : GetAfterRankWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if (hwnd) {
        if (!WinActive(hwnd)) {
            WinActivate(hwnd)
            Sleep(50)
        }
        Send("{Esc}")
        Sleep(100)
        oldMouse := CoordMode("Mouse", "Client")
        MouseMove(10, 10, 0)
        CoordMode("Mouse", oldMouse)
        Sleep(50)
    }
}

/**
 * 執行單次「盤後排行」左側下拉項目選取 (不含重試)
 * 1. SwitchToAfterRankWin()
 * 2. FindClickImg("盤後下拉L.png")
 * 3. Send("{Home}") + PgUp 批次歸位
 * 4. Send("{Down}") × (itemNoL - 1)
 * 5. Send("{Enter}")
 * 6. Sleep 等待資料刷新
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Boolean} 是否選取成功
 */
TryExportAfterRankItemL(itemNoL) {
    res := GetRes(0)
    winTitle := GetAfterRankWinTitle()

    ; 0. 操作前重設狀態 (收合殘留下拉選單並移開滑鼠清除 Hover)
    ResetAfterRankState(winTitle)

    ; 1. 切換至「盤後排行」視窗並最大化 (未開啟則自動開啟)
    if !SwitchToAfterRankWin() {
        LogMsg(Format("盤後排行 L#{1}：無法切換至盤後排行視窗", itemNoL), "WARN")
        return false
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊左側下拉箭頭 (搜尋整個工作區，variation 設為 45)
    dropImg := GetRootDir() "\assets\" res.str "\盤後下拉L.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("盤後排行 L#{1}：找不到左側下拉箭頭 (盤後下拉L.png)", itemNoL), "WARN")
        ResetAfterRankState(winTitle)
        return false
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. 首項歸位 (Home + PgUp 批次防護) → 獨立 Down 脈衝 → Enter
    LogMsg(Format("盤後排行 L#{1}：下拉導航 Home、PgUp×5、Down×{2}", itemNoL, itemNoL - 1), "INFO")
    if !ExecuteDropdownNav(itemNoL, true)
        return false

    ; 選取後立即移開滑鼠，避免游標停在按鈕上方造成 Hover 影響
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)
    LogMsg(Format("盤後排行 L#{1}：選取完成", itemNoL), "INFO")
    return true
}

/**
 * 選取「盤後排行」左側下拉項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNoL 左側項目序號 (1 起算)
 * @returns {Boolean} 是否成功
 */
ExportAfterRankItemL(itemNoL) {
    if (!IsInteger(itemNoL) || itemNoL < 1 || itemNoL > GetAfterRankTotalItemsL()) {
        LogMsg(Format("盤後排行 L 選取：項目序號無效 ({1})", itemNoL), "ERROR")
        return false
    }

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("盤後排行 L#{1}：第 {2} 次重試，先進行狀態重設", itemNoL, A_Index - 1), "WARN")
            ResetAfterRankState()
            Sleep(300)
        }
        try {
            if TryExportAfterRankItemL(itemNoL)
                return true
        } catch as err {
            LogMsg(Format("盤後排行 L#{1}：執行異常 {2}", itemNoL, err.Message), "ERROR")
        }
    }
    LogMsg(Format("盤後排行 L#{1}：重試 {2} 次後仍失敗", itemNoL, ExportTiming.MaxRetries), "ERROR")
    ResetAfterRankState()
    return false
}

/**
 * 執行單次「盤後排行」右側下拉項目匯出 (不含重試)
 * 1. 確保切換至「盤後排行」視窗 (防止被 Excel 等程式搶走焦點)
 * 2. FindClickImg("盤後下拉R.png")
 * 3. Send("{Home}") + PgUp 批次歸位
 * 4. Send("{Down}") × (itemNoR - 1)
 * 5. Send("{Enter}")
 * 6. Sleep 等待資料刷新
 * 7. 擷取 CSV 基準快照 → FindClickImg("資料匯出.png")
 * 8. 輪詢 OutDir 尋找相較快照新增或內容已變更的 CSV
 * 9. CopyToDateDir(csv, <專案>\盤後排行, dateStr)
 * @param {Integer} itemNoR 右側項目序號 (1 起算)
 * @param {Integer} itemNoL 所屬左側項目序號 (供日誌記錄，選用)
 * @param {String} dateStr 日期子資料夾名稱 (YYYYMMDD)
 * @returns {String} 複製後的目的檔路徑，失敗則回傳空字串
 */
TryExportAfterRankItemR(itemNoR, itemNoL := 0, dateStr := "") {
    res := GetRes(0)
    winTitle := GetAfterRankWinTitle()
    tag := (itemNoL > 0) ? Format("L#{1}-R#{2}", itemNoL, itemNoR) : Format("R#{1}", itemNoR)

    ; 0. 操作前重設狀態
    ResetAfterRankState(winTitle)

    ; 1. 切換至「盤後排行」視窗 (若 Excel 或其他程式搶焦點則切回)
    if !SwitchToAfterRankWin() {
        LogMsg(Format("盤後排行 {1}：無法切換至盤後排行視窗", tag), "WARN")
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 2. 點擊右側下拉箭頭 (搜尋整個工作區，variation 設為 45)
    dropImg := GetRootDir() "\assets\" res.str "\盤後下拉R.png"
    if !FindClickImg(dropImg, 0, 0, res.width, res.height, 45, winTitle, true).found {
        LogMsg(Format("盤後排行 {1}：找不到右側下拉箭頭 (盤後下拉R.png)", tag), "WARN")
        ResetAfterRankState(winTitle)
        return ""
    }
    Sleep(ExportTiming.DropOpenDelayMs)

    ; 3~5. 首項歸位 (Home + PgUp 批次防護) → 獨立 Down 脈衝 → Enter
    LogMsg(Format("盤後排行 {1}：下拉導航 Home、PgUp×5、Down×{2}", tag, itemNoR - 1), "INFO")
    if !ExecuteDropdownNav(itemNoR, true)
        return ""

    ; 選取後立即移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)

    ; 7. 點擊資料匯出
    outDir := GetExportOutDir("AfterMarketRanking")
    baseline := CaptureCsvState(outDir)
    if !ClickExportBtn(winTitle, res) {
        LogMsg(Format("盤後排行 {1}：找不到資料匯出按鈕", tag), "WARN")
        ResetAfterRankState(winTitle)
        return ""
    }

    ; 點擊後再次移開滑鼠
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 8. 輪詢輸出目錄取得新 CSV
    csv := WaitNewCsv(outDir, baseline, ExportTiming.TimeoutMs, ExportTiming.PollMs)
    if (csv == "") {
        if IsExportCancelled()
            return ""
        LogMsg(Format("盤後排行 {1}：{2} 毫秒內未在 {3} 偵測到新 CSV", tag, ExportTiming.TimeoutMs, outDir), "WARN")
        ResetAfterRankState(winTitle)
        return ""
    }

    ; 9. 複製至 盤後排行\YYYYMMDD\
    dst := CopyToDateDir(csv, GetAfterRankDstRoot(), dateStr)
    if (dst != "")
        LogMsg(Format("盤後排行 {1}：已匯出 {2}", tag, dst), "INFO")
    return dst
}

/**
 * 匯出「盤後排行」右側單一項目 (失敗自動重試最多 ExportTiming.MaxRetries 次)
 * @param {Integer} itemNoR 右側項目序號 (1 起算)
 * @param {Integer} itemNoL 所屬左側項目序號 (供日誌記錄，選用)
 * @param {String} dateStr 日期子資料夾名稱 (預設為今日 YYYYMMDD)
 * @returns {Boolean} 是否成功
 */
ExportAfterRankItemR(itemNoR, itemNoL := 0, dateStr := "") {
    tag := (itemNoL > 0) ? Format("L#{1}-R#{2}", itemNoL, itemNoR) : Format("R#{1}", itemNoR)
    if (!IsInteger(itemNoL) || itemNoL < 0 || itemNoL > GetAfterRankTotalItemsL()) {
        LogMsg(Format("盤後排行匯出：左側項目序號無效 ({1})", itemNoL), "ERROR")
        return false
    }
    maxR := (IsInteger(itemNoL) && itemNoL >= 1 && itemNoL <= GetAfterRankTotalItemsL())
        ? GetAfterRankTotalItemsR(itemNoL) : 10
    if (!IsInteger(itemNoR) || itemNoR < 1 || itemNoR > maxR) {
        LogMsg(Format("盤後排行匯出：項目序號無效 ({1})", tag), "ERROR")
        return false
    }
    if (dateStr == "")
        dateStr := FormatTime(A_Now, "yyyyMMdd")

    Loop ExportTiming.MaxRetries + 1 {
        if IsExportCancelled()
            return false
        if (A_Index > 1) {
            LogMsg(Format("盤後排行 {1}：第 {2} 次重試，先進行狀態重設", tag, A_Index - 1), "WARN")
            ResetAfterRankState()
            Sleep(300)
        }
        try {
            if (TryExportAfterRankItemR(itemNoR, itemNoL, dateStr) != "")
                return true
        } catch as err {
            LogMsg(Format("盤後排行 {1}：執行異常 {2}", tag, err.Message), "ERROR")
        }
    }
    LogMsg(Format("盤後排行 {1}：重試 {2} 次後仍失敗", tag, ExportTiming.MaxRetries), "ERROR")
    ResetAfterRankState()
    return false
}

/**
 * 批次匯出「盤後排行」全部項目 (所有 L 與各 L 對應之所有 R)
 * @param {Boolean} showMsgBox 完成或中止時是否彈出提示視窗 (無頭測試時設為 false)
 * @returns {Object} {total: Integer, ok: Array, failed: Array, aborted: Boolean}
 */
ExportAfterRankAll(showMsgBox := true) {
    totalL := GetAfterRankTotalItemsL()
    totalItems := 0
    Loop totalL
        totalItems += GetAfterRankTotalItemsR(A_Index)
    if !BeginExportRun("盤後排行匯出", showMsgBox)
        return {total: totalItems, ok: [], failed: [], aborted: true}
    stageState := ""
    try {
        stageState := StageExistingCsvs(GetExportOutDir("AfterMarketRanking"), "盤後排行")
        return RunExportAfterRankAll(showMsgBox)
    } catch as err {
        msg := Format("盤後排行匯出中止：{1}", err.Message)
        LogMsg(msg, "ERROR")
        if showMsgBox
            MsgBox(msg, "盤後排行匯出", "Icon!")
        return {total: totalItems, ok: [], failed: [], aborted: true}
    } finally {
        if IsObject(stageState)
            FinalizeCsvStage(stageState)
        EndExportRun()
    }
}

RunExportAfterRankAll(showMsgBox := true) {
    totalL := GetAfterRankTotalItemsL()
    totalItems := 0
    Loop totalL
        totalItems += GetAfterRankTotalItemsR(A_Index)
    result := {total: totalItems, ok: [], failed: [], aborted: false}

    ; 前置檢查：主顯示器解析度與該解析度圖檔是否齊全 (支援 1920x1080 與 2560x1440)
    res := GetRes(0)
    if !ValidatePriRes(showMsgBox) || !HasResAssets(AfterRankAssets(), res.str) {
        msg := Format("盤後排行匯出中止：解析度 {1} 缺少圖檔 (assets\{1}\盤後下拉L.png、盤後下拉R.png、資料匯出.png) 或不支援", res.str)
        LogMsg(msg, "WARN")
        if showMsgBox
            MsgBox(msg, "盤後排行匯出", "Icon!")
        result.aborted := true
        return result
    }

    dateStr := FormatTime(A_Now, "yyyyMMdd")
    LogMsg(Format("盤後排行匯出開始：共 {1} 項，目的資料夾 {2}\{3}", totalItems, GetAfterRankDstRoot(), dateStr), "INFO")

    Loop totalL {
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        itemNoL := A_Index
        totalR := GetAfterRankTotalItemsR(itemNoL)
        LogMsg(Format("盤後排行：開始處理左側分類 #{1} (共 {2} 個子項目)", itemNoL, totalR), "INFO")

        leftOk := ExportAfterRankItemL(itemNoL)
        if IsExportCancelled() {
            result.aborted := true
            break
        }
        if !leftOk {
            LogMsg(Format("盤後排行：左側分類 #{1} 選取失敗，跳過所屬 {2} 個子項目", itemNoL, totalR), "ERROR")
            Loop totalR {
                result.failed.Push(Format("L{1}-R{2}", itemNoL, A_Index))
            }
            continue
        }

        Loop totalR {
            if IsExportCancelled() {
                result.aborted := true
                break
            }
            itemNoR := A_Index
            tag := Format("L{1}-R{2}", itemNoL, itemNoR)
            rightOk := ExportAfterRankItemR(itemNoR, itemNoL, dateStr)
            if IsExportCancelled() {
                result.aborted := true
                break
            }
            if rightOk
                result.ok.Push(tag)
            else
                result.failed.Push(tag)
        }
    }

    failedStr := ""
    for k in result.failed
        failedStr .= (failedStr == "" ? "" : ", ") k
    summary := Format("盤後排行匯出{1}：成功 {2} / {3} 項{4}", result.aborted ? "已中止" : "完成", result.ok.Length, result.total
        , result.failed.Length ? "`n失敗項目：" failedStr : "")
    LogMsg(StrReplace(summary, "`n", "；"), result.aborted || result.failed.Length ? "WARN" : "INFO")
    if showMsgBox
        MsgBox(summary, "盤後排行匯出", result.aborted || result.failed.Length ? "Icon!" : "Iconi")
    return result
}

```
`lib\utils.ahk`:

```ahk
#Requires AutoHotkey v2.0

/**
 * 確保 INI 設定檔使用 UTF-16 LE 編碼，以支援 Windows API (GetPrivateProfileStringW) 正確讀取中文
 * @param {String} iniPath INI 檔案路徑
 * @returns {Boolean} 編碼正確或轉換成功時回傳 true
 */
EnsureIniEnc(iniPath) {
    if !FileExist(iniPath)
        return false
    tmpPath := ""
    try {
        rawBuf := FileRead(iniPath, "RAW")
        if rawBuf.Size >= 2 && NumGet(rawBuf, 0, "UChar") == 0xFF && NumGet(rawBuf, 1, "UChar") == 0xFE {
            return true ; 已經是 UTF-16 LE (BOM: FF FE)
        }

        hasUtf8Bom := rawBuf.Size >= 3
            && NumGet(rawBuf, 0, "UChar") == 0xEF
            && NumGet(rawBuf, 1, "UChar") == 0xBB
            && NumGet(rawBuf, 2, "UChar") == 0xBF
        validUtf8 := hasUtf8Bom || rawBuf.Size == 0
        if (!validUtf8 && rawBuf.Size > 0) {
            validUtf8 := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0x8
                , "Ptr", rawBuf.Ptr, "Int", rawBuf.Size, "Ptr", 0, "Int", 0) > 0
        }
        content := FileRead(iniPath, validUtf8 ? "UTF-8" : "CP0")

        tmpPath := iniPath ".tmp-" DllCall("GetCurrentProcessId") "-" A_TickCount
        f := FileOpen(tmpPath, "w", "UTF-16")
        if !f
            throw Error("無法建立暫存設定檔")
        f.Write(content)
        f.Close()

        verifyBuf := FileRead(tmpPath, "RAW")
        if (verifyBuf.Size < 2 || NumGet(verifyBuf, 0, "UChar") != 0xFF || NumGet(verifyBuf, 1, "UChar") != 0xFE)
            throw Error("暫存設定檔缺少 UTF-16 LE BOM")

        MOVEFILE_REPLACE_EXISTING := 0x1
        MOVEFILE_WRITE_THROUGH := 0x8
        if !DllCall("MoveFileExW", "Str", tmpPath, "Str", iniPath
            , "UInt", MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH, "Int")
            throw OSError(A_LastError, "MoveFileExW")
        return true
    } catch as err {
        if (tmpPath != "" && FileExist(tmpPath)) {
            try FileDelete(tmpPath)
        }
        LogMsg(Format("設定檔編碼轉換失敗 [{1}]: {2}", iniPath, err.Message), "ERROR")
        return false
    }
}

/**
 * 取得專案根目錄路徑
 * @returns {String} 專案根目錄絕對路徑
 */
GetRootDir() {
    static rootDir := ""
    if (rootDir != "")
        return rootDir
    
    dir := A_ScriptDir
    Loop 5 {
        if (FileExist(dir "\Mitake.ahk") || FileExist(dir "\config\settings.ini") || FileExist(dir "\assets")) {
            rootDir := dir
            return rootDir
        }
        SplitPath(dir, , &parent)
        if (parent == dir || parent == "")
            break
        dir := parent
    }
    rootDir := A_ScriptDir
    return rootDir
}

/**
 * 取得設定檔內容
 * @param {String} section 區段名稱
 * @param {String} key 鍵名
 * @param {String} defVal 預設值
 * @returns {String} 設定值
 */
GetCfg(section, key, defVal := "") {
    static iniPath := ""
    if (iniPath == "") {
        iniPath := GetRootDir() "\config\settings.ini"
    }
    if !FileExist(iniPath) {
        return defVal
    }
    if !EnsureIniEnc(iniPath)
        return defVal
    try {
        val := IniRead(iniPath, section, key, defVal)
        return val != "" ? val : defVal
    } catch {
        return defVal
    }
}

/**
 * 記錄執行日誌
 * @param {String} msg 訊息內容
 * @param {String} level 日誌等級 (INFO, WARN, ERROR)
 */
LogMsg(msg, level := "INFO") {
    static logDir := ""
    static logFile := ""
    if (logDir == "") {
        logDir := GetRootDir() "\logs"
        logFile := logDir "\app.log"
    }
    
    if !DirExist(logDir) {
        DirCreate(logDir)
    }
    
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    logLine := Format("[{1}] [{2}] {3}`n", timestamp, level, msg)
    
    try {
        FileAppend(logLine, logFile, "`n UTF-8")
    }
    OutputDebug(logLine)
}

/**
 * 讀取顯示器解析度與邊界資訊
 * @param {Integer} monNum 顯示器編號 (0 代表主顯示器，1..N 代表指定顯示器)
 * @returns {Object} 包含 width, height, left, top, right, bottom, isPrimary, str 的物件
 */
GetRes(monNum := 0) {
    priIdx := MonitorGetPrimary()
    tgtMon := (monNum == 0) ? priIdx : monNum
    
    if MonitorGet(tgtMon, &left, &top, &right, &bottom) {
        w := right - left
        h := bottom - top
        return {
            width: w,
            height: h,
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            isPrimary: (tgtMon == priIdx),
            str: Format("{1}x{2}", w, h)
        }
    } else {
        return {
            width: 0,
            height: 0,
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            isPrimary: false,
            str: "0x0"
        }
    }
}

/**
 * 取得所有顯示器的解析度資訊列表
 * @returns {Array} 顯示器資訊物件陣列
 */
GetAllRes() {
    count := MonitorGetCount()
    displays := []
    
    Loop count {
        displays.Push(GetRes(A_Index))
    }
    
    return displays
}

/**
 * 檢查指定的解析度字串是否為允許的解析度之一
 * @param {String} resStr 解析度字串 (例: "1920x1080")
 * @param {Array} allowedRes 支援的解析度清單 (預設為 ["1920x1080", "2560x1440"])
 * @returns {Boolean} 是否支援
 */
IsSupportedRes(resStr, allowedRes := "") {
    if (allowedRes == "") {
        allowedRes := ["1920x1080", "2560x1440"]
    }
    for item in allowedRes {
        if (item == resStr) {
            return true
        }
    }
    return false
}

/**
 * 驗證目前主顯示器的解析度是否符合系統需求
 * @param {Boolean} showMsgBox 是否在解析度不符合時彈出提示視窗 (預設為 true)
 * @returns {Boolean} 符合需求傳回 true，否則傳回 false
 */
ValidatePriRes(showMsgBox := true) {
    res := GetRes(0) ; 0 為主顯示器
    if IsSupportedRes(res.str) {
        return true
    }
    
    errMsg := Format("顯示器解析度錯誤：主顯示器解析度為 {1}。`n本軟體僅於主顯示器解析度為 1920x1080 或 2560x1440 時繼續執行。", res.str)
    LogMsg(errMsg, "ERROR")
    
    if (showMsgBox) {
        MsgBox(errMsg, "顯示器解析度錯誤", "Icon!")
    }
    return false
}

```
`lib\window_control.ahk`:

```ahk
#Requires AutoHotkey v2.0

/**
 * 取得三竹股市主程式視窗之 WinTitle
 * @returns {String} 主程式視窗 WinTitle (預設: "三竹股市")
 */
GetMainWinTitle() {
    return GetCfg("App", "MainWinTitle", GetCfg("App", "WinTitle", "三竹股市"))
}

/**
 * 取得「熱門排行」視窗之 WinTitle
 * @returns {String} 熱門排行視窗 WinTitle (預設: "熱門排行")
 */
GetPopRankWinTitle() {
    return GetCfg("App", "PopularRankingWinTitle", "熱門排行")
}

/**
 * 取得「盤後排行」視窗之 WinTitle
 * @returns {String} 盤後排行視窗 WinTitle (預設: "盤後排行")
 */
GetAfterRankWinTitle() {
    return GetCfg("App", "AfterMarketRankingWinTitle", "盤後排行")
}

/**
 * 判斷三竹股市視窗是否應自動最大化
 * @param {String} procName 視窗所屬程序名稱
 * @param {String} winTitle 視窗標題
 * @param {String} cfgProcName 設定檔中的三竹股市程序名稱
 * @returns {Boolean} 程序符合且標題精確等於已知三竹視窗時回傳 true
 */
ShouldMaximizeMitakeWin(procName, winTitle, cfgProcName) {
    isMitakeProc := procName == cfgProcName
        || procName == "三竹股市.exe"
        || InStr(procName, "三竹")
    if !isMitakeProc
        return false
    for knownTitle in [GetMainWinTitle(), GetPopRankWinTitle(), GetAfterRankWinTitle()] {
        if (winTitle == knownTitle)
            return true
    }
    return false
}

/**
 * 尋找三竹股市相關視窗 HWND (支援標題精確匹配與進程名稱備援)
 * @param {String} winTitle 視窗標題 (預設為空，代表主程式視窗)
 * @returns {Integer} 視窗 HWND (若未找到則回傳 0)
 */
FindMitakeWin(winTitle := "") {
    mainTitle := GetMainWinTitle()
    tgtTitle := (winTitle != "") ? winTitle : mainTitle
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")

    try {
        for hwnd in WinGetList("ahk_exe " procName) {
            if (WinGetTitle(hwnd) == tgtTitle)
                return hwnd
        }
    }
    return 0
}

/**
 * 輪詢等待指定的三竹精確標題視窗出現
 * @param {String} winTitle 目標精確標題
 * @param {Number} timeout 等待秒數
 * @returns {Integer} 視窗 HWND，逾時回傳 0
 */
WaitMitakeWin(winTitle, timeout := 5) {
    deadline := A_TickCount + Round(timeout * 1000)
    Loop {
        hwnd := FindMitakeWin(winTitle)
        if hwnd
            return hwnd
        if (A_TickCount >= deadline)
            return 0
        Sleep(100)
    }
}

/**
 * 判斷前景視窗中繼資料是否屬於目標視窗的安全暫時性操作環境。
 * 三竹展開自繪選單後，前景 HWND 會從主視窗切換至同程序的無標題浮層；
 * 此時座標與 ImageSearch 的 Client 原點也隨浮層切換，不能重新激活主視窗。
 */
IsTrustedForegroundMeta(targetPid, activePid, targetRoot, activeRoot, activeTitle) {
    if (!targetPid || targetPid != activePid)
        return false
    return (targetRoot && targetRoot == activeRoot) || Trim(activeTitle) == ""
}

/**
 * 取得可安全接受滑鼠與影像操作的目前前景 HWND。
 * 只接受目標本身，或同程序且具相同 RootOwner／無標題的暫時性選單浮層。
 */
GetSafeForegroundContext(targetHwnd, &contextHwnd) {
    contextHwnd := 0
    if !targetHwnd || !WinExist(targetHwnd)
        return false

    activeHwnd := DllCall("user32\GetForegroundWindow", "Ptr")
    if !activeHwnd
        return false
    if (activeHwnd == targetHwnd) {
        contextHwnd := targetHwnd
        return true
    }

    try {
        targetPid := WinGetPID(targetHwnd)
        activePid := WinGetPID(activeHwnd)
        targetRoot := DllCall("user32\GetAncestor", "Ptr", targetHwnd, "UInt", 3, "Ptr") ; GA_ROOTOWNER
        activeRoot := DllCall("user32\GetAncestor", "Ptr", activeHwnd, "UInt", 3, "Ptr")
        activeTitle := WinGetTitle(activeHwnd)
        if IsTrustedForegroundMeta(targetPid, activePid, targetRoot, activeRoot, activeTitle) {
            contextHwnd := activeHwnd
            return true
        }
    }
    return false
}

/**
 * 執行視窗客戶區座標點擊 (支援 control 與 physical 兩種點擊方式)
 * @param {Integer} clickX X 座標
 * @param {Integer} clickY Y 座標
 * @param {String|Integer} tgtWin 目標視窗 WinTitle 或 HWND (預設主視窗)
 * @param {Boolean} shouldActivate 是否先激活視窗 (實體滑鼠點擊時適用)
 */
ClickPoint(clickX, clickY, tgtWin := "", shouldActivate := false) {
    target := (tgtWin != "") ? tgtWin : GetMainWinTitle()
    clickMethod := GetCfg("App", "ClickMethod", "physical")

    if (!IsNumber(clickX) || !IsNumber(clickY) || clickX <= 0 || clickY <= 0) {
        LogMsg(Format("拒絕無效點擊座標 (X:{1}, Y:{2})", clickX, clickY), "WARN")
        return false
    }
    hwnd := Type(target) == "Integer" ? WinExist(target) : FindMitakeWin(target)
    if !hwnd {
        LogMsg(Format("拒絕點擊：目標視窗不存在 [{1}]", target), "WARN")
        return false
    }

    try {
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), hwnd)
            return true
        }
        if shouldActivate {
            if !ActivateMitake(hwnd)
                return false
        } else if !GetSafeForegroundContext(hwnd, &contextHwnd) {
            LogMsg(Format("拒絕實體點擊：目標視窗或其選單浮層未在前景 (HWND: {1})", hwnd), "WARN")
            return false
        }
        oldMouse := CoordMode("Mouse", "Client")
        try {
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
        } finally {
            CoordMode("Mouse", oldMouse)
        }
        return true
    } catch as err {
        LogMsg(Format("點擊失敗 (HWND: {1}, X:{2}, Y:{3}): {4}", hwnd, clickX, clickY, err.Message), "WARN")
        return false
    }
}

/**
 * 切換至三竹股市主程式視窗 (WinTitle: "三竹股市") 並置於最前台與最大化
 * 僅主程式視窗具備 menu bar，點擊 menu bar 前應先調用本函式切換到主程式視窗
 * @param {Integer} timeout 等待視窗就緒之超時秒數 (預設 3 秒)
 * @returns {Boolean} 切換是否成功
 */
SwitchToMainWin(timeout := 3) {
    mainWinTitle := GetMainWinTitle()
    hwnd := FindMitakeWin(mainWinTitle)
    
    if !hwnd {
        LogMsg(Format("切換主程式視窗失敗：未偵測到主程式視窗 [{1}]", mainWinTitle), "WARN")
        return false
    }
    
    if !ActivateMitake(hwnd, timeout)
        return false
    
    if WinWaitActive(hwnd, , timeout) {
        LogMsg(Format("已成功切換至主程式視窗: {1}", mainWinTitle), "INFO")
        return true
    }
    return false
}

/**
 * 檢查三竹股市是否正在執行
 * @returns {Boolean} 是否在執行中
 */
IsMitakeRunning() {
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    return (FindMitakeWin() || ProcessExist(procName)) ? true : false
}

/**
 * 啟動並定位「三竹股市電腦版」
 * @param {String} customPath 可選的自訂執行檔路徑
 * @returns {Boolean} 啟動或聚焦是否成功
 */
LaunchMitake(customPath := "") {
    ; 0. 驗證主顯示器解析度 (僅支援 1920x1080 或 2560x1440)
    if !ValidatePriRes(true) {
        return false
    }

    mainWinTitle := GetMainWinTitle()
    procName := GetCfg("App", "ProcessName", "三竹股市.exe")
    timeoutStr := GetCfg("App", "Timeout", "15")
    timeout := IsInteger(timeoutStr) && Integer(timeoutStr) > 0 ? Integer(timeoutStr) : 15

    ; 1. 若主程式視窗已經存在，切換至主程式視窗並最大化
    if FindMitakeWin(mainWinTitle) {
        LogMsg("三竹股市已在執行中，正在切換至主程式視窗...", "INFO")
        return SwitchToMainWin()
    } else if ProcessExist(procName) {
        LogMsg("檢測到三竹股市程序運作中，等待主程式視窗出現...", "INFO")
        if WaitMitakeWin(mainWinTitle, 10) {
            return SwitchToMainWin()
        }
    }

    ; 2. 確定執行檔路徑
    tgtPath := customPath != "" ? customPath : GetCfg("App", "Path", "D:\Program Files\MitakeGU\三竹股市.exe")

    if !FileExist(tgtPath) {
        errMsg := Format("找不到三竹股市執行檔: {1}", tgtPath)
        LogMsg(errMsg, "ERROR")
        MsgBox(errMsg "`n請確認安裝路徑或至 config/settings.ini 設定。", "錯誤", "Icon!")
        return false
    }

    ; 3. 執行程式
    LogMsg(Format("正在啟動三竹股市: {1}", tgtPath), "INFO")
    SplitPath(tgtPath, &fileName, &dirPath)
    
    try {
        Run(tgtPath, dirPath)
    } catch as err {
        LogMsg(Format("啟動失敗: {1}", err.Message), "ERROR")
        MsgBox(Format("無法啟動三竹股市：{1}", err.Message), "啟動失敗", "Icon!")
        return false
    }

    ; 4. 等待主程式視窗開啟 (同時兼容主標題或程序名稱)
    if WaitMitakeWin(mainWinTitle, timeout) {
        LogMsg("三竹股市主程式視窗已成功啟動。", "INFO")
        Sleep(500)
        return SwitchToMainWin()
    } else {
        LogMsg(Format("啟動三竹股市超時 ({1} 秒內未偵測到主程式視窗)。", timeout), "WARN")
        return false
    }
}

/**
 * 聚焦並將指定視窗或三竹股市主視窗最大化
 * 若視窗處於最小化狀態則先還原；若已最大化則避免重覆最大化以防下拉選單被強制關閉
 * @param {Integer|String} target 視窗 HWND 或 WinTitle (0 代表預設主程式視窗)
 * @returns {Boolean} 是否成功激活
 */
ActivateMitake(target := 0, timeout := 1) {
    mainWinTitle := GetMainWinTitle()
    tgtWin := (target != 0) ? target : mainWinTitle
    hwnd := Type(target) == "Integer" && target != 0 ? WinExist(target) : FindMitakeWin(tgtWin)
    
    if !hwnd {
        return false
    }
    
    ; 1. 若視窗處於最小化，先還原以確保正常顯示於桌面
    minMax := WinGetMinMax(hwnd)
    if (minMax == -1) {
        WinRestore(hwnd)
        Sleep(50)
    }
    
    ; 2. 將視窗定位到主顯示器，避免以主顯示器圖資操作副螢幕視窗
    pri := GetRes(0)
    try {
        WinGetPos(&winX, &winY, &winW, &winH, hwnd)
        centerX := winX + winW // 2
        centerY := winY + winH // 2
        onPrimary := centerX >= pri.left && centerX < pri.right && centerY >= pri.top && centerY < pri.bottom
        if !onPrimary {
            if (WinGetMinMax(hwnd) == 1)
                WinRestore(hwnd)
            WinMove(pri.left + 10, pri.top + 10, , , hwnd)
            Sleep(50)
        }
    } catch as err {
        LogMsg(Format("定位視窗至主顯示器失敗 (HWND: {1}): {2}", hwnd, err.Message), "WARN")
        return false
    }

    ; 3. 設置前景焦點鎖定許可並激活視窗
    DllCall("user32\AllowSetForegroundWindow", "Int", -1)
    DllCall("user32\SetForegroundWindow", "Ptr", hwnd)
    WinActivate(hwnd)

    if !WinWaitActive(hwnd, , timeout) {
        LogMsg(Format("無法取得目標視窗前景焦點 (HWND: {1})", hwnd), "WARN")
        return false
    }
    
    ; 4. 若未處於最大化狀態，再進行最大化，避免重覆最大化關閉已展開的選單
    if (WinGetMinMax(hwnd) != 1) {
        WinMaximize(hwnd)
    }
    
    LogMsg(Format("已將視窗 [{1}] (HWND: {2}) 切換至最前台並最大化。", tgtWin, hwnd), "INFO")
    return true
}

/**
 * 切換或開啟「三竹股市電腦版」選單列 (Menu Bar)
 * 由於三竹股市電腦版採用自訂 GUI 介面，非標準 Win32 選單列，
 * 本函式支援聚焦視窗後傳送選單快捷鍵、相對座標點擊或圖像辨識定位點擊。
 * @returns {Boolean} 執行是否成功
 */
ToggleMenuBar() {
    mainWinTitle := GetMainWinTitle()
    
    if !FindMitakeWin(mainWinTitle) && !IsMitakeRunning() {
        LogMsg("切換選單列失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ; 僅主程式視窗有 menu bar，切換至主程式視窗
    if !SwitchToMainWin() {
        return false
    }
    
    ; 讀取設定檔中的觸發模式 (key, click, image)
    mode := GetCfg("MenuBar", "TriggerMode", "click")
    
    if (mode == "image") {
        res := GetRes(0)
        imgPath := GetAssetImgPath("menu.png", res.str)
        if !FileExist(imgPath) {
            customPath := GetCfg("MenuBar", "ImagePath", "")
            imgPath := (customPath != "") ? GetRootDir() "\" customPath : imgPath
        }
        imgRes := FindClickImg(imgPath, 0, 0, 1200, 400, 30, mainWinTitle)
        if imgRes.found {
            return true
        }
        
        ; 影像辨識退回預設座標點擊
        coords := GetResCoords("MenuBar")
        if !ClickPoint(coords.x, coords.y, mainWinTitle, true)
            return false
        LogMsg(Format("圖像搜尋未找到，降級採用解析度 [{1}] 座標點擊 (X:{2}, Y:{3})", res.str, coords.x, coords.y), "WARN")
        return true
    } else if (mode == "click") {
        ; 模擬點擊選單按鈕 (依解析度由 settings.ini 讀取)
        res := GetRes(0)
        coords := GetResCoords("MenuBar")
        if !ClickPoint(coords.x, coords.y, mainWinTitle, true)
            return false
        LogMsg(Format("已對三竹股市視窗進行選單點擊 (解析度: {1}, X:{2}, Y:{3})", res.str, coords.x, coords.y), "INFO")
    } else {
        ; 傳送選單按鍵 (預設傳送 Alt 鍵)
        triggerKey := GetCfg("MenuBar", "TriggerKey", "{Alt}")
        Send(triggerKey)
        LogMsg(Format("已發送選單列快捷鍵: {1}", triggerKey), "INFO")
    }
    
    return true
}

/**
 * 取得圖像寬度與高度
 * @param {String} imgPath 圖像路徑
 * @param {VarRef} width 傳出寬度
 * @param {VarRef} height 傳出高度
 */
GetImgSize(imgPath, &width, &height) {
    width := 20, height := 20
    if !FileExist(imgPath)
        return
    try {
        g := Gui()
        pic := g.Add("Pic",, imgPath)
        ControlGetPos(,, &w, &h, pic.Hwnd)
        g.Destroy()
        if (w > 0 && h > 0) {
            width := w
            height := h
        }
    } catch {
        width := 20, height := 20
    }
}

/**
 * 透過 ImageSearch 尋找目標圖像按鈕並點擊圖案中心點
 * @param {String} imgPath 圖像檔案路徑
 * @param {Integer} winX1 搜尋區域左上 X
 * @param {Integer} winY1 搜尋區域左上 Y
 * @param {Integer} winX2 搜尋區域右下 X
 * @param {Integer} winY2 搜尋區域右下 Y
 * @param {Integer} variation 色彩容許度 (0-255)
 * @param {String} tgtWin 指定目標視窗 (若未指定則使用主程式視窗)
 * @param {Boolean} shouldActivate 是否先激活視窗 (搜尋已展開之選單時應設為 false 以免關閉選單)
 * @returns {Object} {found: Boolean, x: Integer, y: Integer}
 */
FindClickImg(imgPath, winX1 := 0, winY1 := 0, winX2 := 1200, winY2 := 400, variation := 30, tgtWin := "", shouldActivate := true) {
    if !FileExist(imgPath) {
        LogMsg(Format("找不到搜尋圖像檔案: {1}", imgPath), "WARN")
        return {found: false, x: 0, y: 0}
    }
    
    winTitle := (tgtWin != "") ? tgtWin : GetMainWinTitle()
    hwnd := Type(winTitle) == "Integer" ? WinExist(winTitle) : FindMitakeWin(winTitle)
    if !hwnd {
        return {found: false, x: 0, y: 0}
    }
    
    contextHwnd := hwnd
    if (shouldActivate && !WinActive(hwnd)) {
        if !ActivateMitake(hwnd)
            return {found: false, x: 0, y: 0}
        contextHwnd := hwnd
    } else if (!shouldActivate && !GetSafeForegroundContext(hwnd, &contextHwnd)) {
        LogMsg(Format("取消圖像搜尋：目標視窗或其選單浮層未在前景 (HWND: {1})", hwnd), "WARN")
        return {found: false, x: 0, y: 0}
    }

    try {
        WinGetClientPos(, , &clientW, &clientH, contextHwnd)
        winX2 := Min(winX2, clientW - 1)
        winY2 := Min(winY2, clientH - 1)
    } catch as err {
        LogMsg(Format("取得圖像搜尋客戶區失敗 (HWND: {1}): {2}", hwnd, err.Message), "WARN")
        return {found: false, x: 0, y: 0}
    }
    
    oldPixel := CoordMode("Pixel", "Client")
    
    try {
        searchSpec := Format("*{} {}", variation, imgPath)
        
        if ImageSearch(&foundX, &foundY, winX1, winY1, winX2, winY2, searchSpec) {
            GetImgSize(imgPath, &imgW, &imgH)
            targetX := foundX + (imgW // 2)
            targetY := foundY + (imgH // 2)
            
            if !ClickPoint(targetX, targetY, hwnd, false) {
                CoordMode("Pixel", oldPixel)
                return {found: false, x: 0, y: 0}
            }
            clickMethod := GetCfg("App", "ClickMethod", "physical")
            
            LogMsg(Format("圖像辨識成功 ({1})，圖案尺寸({2}x{3})，已用[{4}]點擊中心座標 ({5}, {6})", imgPath, imgW, imgH, clickMethod, targetX, targetY), "INFO")
            
            CoordMode("Pixel", oldPixel)
            return {found: true, x: targetX, y: targetY}
        }
    } catch as err {
        LogMsg(Format("ImageSearch 執行異常: {1}", err.Message), "WARN")
    }
    
    CoordMode("Pixel", oldPixel)
    LogMsg(Format("圖像辨識未找到匹配項目: {1}", imgPath), "WARN")
    return {found: false, x: 0, y: 0}
}

/**
 * 取得指定資產圖檔的路徑，優先匹配當前主顯示器解析度 (或指定解析度)
 * @param {String} assetName 圖檔名稱 (如 "menu_證券行情.png" 或 "盤後排行.png")
 * @param {String} tgtRes 可選的目標解析度 (例: "2560x1440" 或 "1920x1080")，預設抓取主顯示器解析度
 * @returns {String} 解析後的圖檔完整路徑
 */
GetAssetImgPath(assetName, tgtRes := "") {
    if !InStr(assetName, ".") {
        assetName .= ".png"
    }
    if (tgtRes == "") {
        res := GetRes(0)
        tgtRes := res.str
    }
    
    rootDir := GetRootDir()
    
    ; 1. 優先匹配 assets/{解析度}/{檔名} (例如 assets/2560x1440/盤後排行.png)
    p1 := rootDir "\assets\" tgtRes "\" assetName
    if FileExist(p1)
        return p1
        
    ; 2. 匹配向下相容命名 assets/{檔名無副檔名}_{解析度}.png
    nameNoExt := SubStr(assetName, 1, InStr(assetName, ".", , -1) - 1)
    p2 := rootDir "\assets\" nameNoExt "_" tgtRes ".png"
    if FileExist(p2)
        return p2
        
    ; 嚴禁跨解析度使用圖檔；若不存在則傳回該解析度的預期路徑供呼叫端安全失敗
    return p1
}

/**
 * 取得指定區段在指定解析度 (或當前主顯示器解析度) 下的降級點擊座標
 * 優先讀取 ClickX_{Resolution} / ClickY_{Resolution} (例如 ClickX_1920x1080, ClickX_2560x1440)，
 * 亦支援 {Resolution}_ClickX / {Resolution}_ClickY 命名格式；若未設定則回傳傳入之中性預設值。
 * @param {String} section INI 區段名稱 (例: "SecuritiesQuote", "PopularRanking", "AfterMarketRanking")
 * @param {Integer} defX 備用 X 座標預設值
 * @param {Integer} defY 備用 Y 座標預設值
 * @param {String} tgtRes 可選的目標解析度字串 (例: "1920x1080" 或 "2560x1440")，預設抓取主顯示器解析度
 * @returns {Object} {x: Integer, y: Integer}
 */
GetResCoords(section, defX := 0, defY := 0, tgtRes := "") {
    if (tgtRes == "") {
        res := GetRes(0)
        tgtRes := res.str
    }
    
    ; 1. 優先嘗試讀取 ClickX_{解析度} 或 {解析度}_ClickX
    valX := GetCfg(section, "ClickX_" tgtRes, "")
    if (valX == "") {
        valX := GetCfg(section, tgtRes "_ClickX", "")
    }
    
    valY := GetCfg(section, "ClickY_" tgtRes, "")
    if (valY == "") {
        valY := GetCfg(section, tgtRes "_ClickY", "")
    }
    
    x := (valX != "" && IsInteger(valX)) ? Integer(valX) : Integer(defX)
    y := (valY != "" && IsInteger(valY)) ? Integer(valY) : Integer(defY)
    return {x: x, y: y}
}

/**
 * 點擊「三竹股市」選單列的「證券行情」項目
 * 僅主程式視窗具備 menu bar，點擊前應先切換到主程式視窗 (WinTitle: "三竹股市")
 * 參照 assets/{resolution}/menu_證券行情.png 進行圖像辨識定位與點擊
 * @returns {Boolean} 點擊是否成功
 */
ClickSecQuoteMenu() {
    mainWinTitle := GetMainWinTitle()
    
    ; 點擊 menu bar「證券行情」前應先切換到主程式視窗
    if !SwitchToMainWin() {
        LogMsg("點擊證券行情失敗：無法切換至主程式視窗", "WARN")
        return false
    }
    
    Sleep(200) ; 確保切換至主程式視窗並渲染就緒
    
    res := GetRes(0)
    imgPath := GetAssetImgPath("menu_證券行情.png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 500 : 350
    
    imgRes := FindClickImg(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    if imgRes.found {
        LogMsg("已成功透過圖像辨識點擊「證券行情」。", "INFO")
        return true
    } else {
        ; 影像搜尋若未比對成功，降級採用 settings.ini 當前解析度的相對座標點擊
        coords := GetResCoords("SecuritiesQuote")
        if !ClickPoint(coords.x, coords.y, mainWinTitle, false)
            return false
        LogMsg(Format("圖像辨識點擊「證券行情」未比對到 ({1})，降級採用解析度 [{2}] 座標點擊 (X:{3}, Y:{4})", imgPath, res.str, coords.x, coords.y), "WARN")
        return true
    }
}

/**
 * 通用點擊「證券行情」下拉選單之排行項目並可選等待新視窗
 * 點擊座標依據 settings.ini 中對應解析度設定自動讀取
 * @param {String} itemName 項目名稱 (例: "熱門排行"、"盤後排行")
 * @param {String} section INI 區段名稱 (例: "PopularRanking"、"AfterMarketRanking")
 * @param {String} tgtWinTitle 目標新視窗標題
 * @param {Boolean} waitNewWindow 是否等待新視窗出現
 * @param {Integer} timeout 等待超時秒數
 * @returns {Boolean} 點擊是否成功
 */
ClickRankMenu(itemName, section, tgtWinTitle, waitNewWindow := true, timeout := 5) {
    ; 1. 點擊 menu bar 前應先切換到主程式視窗並點擊「證券行情」
    if !ClickSecQuoteMenu() {
        LogMsg(Format("點擊{1}失敗：開啟證券行情選單未成功", itemName), "WARN")
        return false
    }
    
    Sleep(300) ; 等待選單展開
    
    ; 2. 尋找與點擊目標項目 (shouldActivate 設為 false，避免關閉已展開的下拉選單)
    mainWinTitle := GetMainWinTitle()
    res := GetRes(0)
    imgPath := GetAssetImgPath(itemName ".png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 750 : 500
    
    imgRes := FindClickImg(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    clicked := false
    if imgRes.found {
        LogMsg(Format("已成功透過圖像辨識點擊「{1}」。", itemName), "INFO")
        clicked := true
    } else {
        coords := GetResCoords(section)
        if !ClickPoint(coords.x, coords.y, mainWinTitle, false)
            return false
        LogMsg(Format("圖像辨識點擊「{1}」未比對到 ({2})，降級採用解析度 [{3}] 座標點擊 (X:{4}, Y:{5})", itemName, imgPath, res.str, coords.x, coords.y), "WARN")
        clicked := true
    }
    
    ; 3. 點擊後等待新視窗出現
    if (clicked && waitNewWindow) {
        hwnd := WaitMitakeWin(tgtWinTitle, timeout)
        if hwnd {
            if !ActivateMitake(hwnd)
                return false
            LogMsg(Format("已偵測到「{1}」新視窗 ({2}) 並最大化顯示", itemName, tgtWinTitle), "INFO")
        } else {
            LogMsg(Format("等待「{1}」新視窗 ({2}) 出現超時 ({3} 秒)", itemName, tgtWinTitle, timeout), "WARN")
            return false
        }
    }
    
    return clicked
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「熱門排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "熱門排行"
 * 參照 assets/{resolution}/熱門排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「熱門排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickPopRankMenu(waitNewWindow := true, timeout := 5) {
    return ClickRankMenu("熱門排行", "PopularRanking", GetPopRankWinTitle(), waitNewWindow, timeout)
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「盤後排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "盤後排行"
 * 參照 assets/{resolution}/盤後排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「盤後排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickAfterRankMenu(waitNewWindow := true, timeout := 5) {
    return ClickRankMenu("盤後排行", "AfterMarketRanking", GetAfterRankWinTitle(), waitNewWindow, timeout)
}

/**
 * 切換至子視窗或點擊選單開啟新視窗
 * @param {String} winTitle 子視窗 WinTitle
 * @param {String} itemName 子視窗項目名稱
 * @param {Func} openFunc 未開啟時調用的開啟函式
 * @param {Integer} timeout 等待超時秒數
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToSubWin(winTitle, itemName, openFunc, timeout := 5) {
    hwnd := FindMitakeWin(winTitle)
    if hwnd {
        if !ActivateMitake(hwnd)
            return false
        LogMsg(Format("已切換至現有的「{1}」視窗: {2}", itemName, winTitle), "INFO")
        return true
    }
    
    LogMsg(Format("「{1}」視窗尚未開啟，切換至主程式點擊選單開啟...", itemName), "INFO")
    return openFunc(true, timeout)
}

/**
 * 切換至「熱門排行」視窗 (WinTitle: "熱門排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToPopRankWin(timeout := 5) {
    return SwitchToSubWin(GetPopRankWinTitle(), "熱門排行", ClickPopRankMenu, timeout)
}

/**
 * 切換至「盤後排行」視窗 (WinTitle: "盤後排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToAfterRankWin(timeout := 5) {
    return SwitchToSubWin(GetAfterRankWinTitle(), "盤後排行", ClickAfterRankMenu, timeout)
}

```
`pop_rank_export_spec.md`:

```md
# 熱門排行全項目匯出：規格與設計說明 (Popular Ranking Export Spec)

> 實機驗證狀態：2026-10-09 已完成 44 項完整托盤批次驗證。問題閉環記錄見 [LESSONS_LEARNED.md](LESSONS_LEARNED.md)。

## 一、 範圍與目標 (Scope & Objectives)
- 自動化批次匯出三竹股市「證券行情」→「熱門排行」下拉清單內之所有項目（共 **44** 項）。
- 支援主顯示器解析度 **1920x1080** 與 **2560x1440**；其他解析度或缺少該解析度必要圖檔時記錄 WARN 日誌並中止。
- 架構與模式作為後續「盤後排行」全項目匯出之基礎設計規範。

---

## 二、 前置條件與環境 (Prerequisites)
1. **防搶焦點機制**：三竹之資料匯出關聯程式設定指向 [bypass.bat](bypass.bat)，該批次檔啟動後立即結束退出，防止系統自動開啟 Excel 奪取前台焦點。
2. **匯出暫存目錄**：三竹股市預設匯出 CSV 路徑為 `D:\Program Files\MitakeGU\USER\OUT\`（例：`20261002_漲停鎖住.csv`）。
3. **專案存放目的地**：`<專案根目錄>\熱門排行\YYYYMMDD\<原始檔名>.csv`。

---

## 三、 時序與核心參數 (`ExportTiming`)

所有時序與重試參數集中定義於 `ExportTiming` 類別常數：

| 參數名稱 | 數值 | 說明 |
| :--- | :--- | :--- |
| `RefreshDelayMs` | 1500 ms | Enter 選取下拉項目後，等待三竹介面資料刷新之緩衝時間 |
| `DropOpenDelayMs` | 300 ms | 點擊下拉箭頭後，等待自繪下拉選單浮層渲染展開之延遲 |
| `KeyHoldMs` | 40 ms | 每個導航鍵維持按下狀態的時間，確保自繪清單收到 KeyDown／KeyUp |
| `KeyDelayMs` | 60 ms | 每個獨立按鍵脈衝放開後的間隔 |
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
   - **首項歸位**：三竹自繪選單不支援標準 Win32 `{Home}` 鍵，改為發送 5 個獨立 `{PgUp}` 按鍵脈衝，確保游標穩定歸位至第 1 項。
   - **遞增定位**：發送 `(itemNo - 1)` 個具明確 KeyDown、停留、KeyUp 與間隔的 `{Down}` 脈衝，避免快速 `SendInput` 被自繪清單忽略而停在第 2 項。
   - **確認選取**：以相同按鍵脈衝方式發送 `{Enter}` 套用選取。
   - **解除停懸**：選取後立即將滑鼠游標移至客戶端 `(10, 10)`。
5. **等待資料刷新**：
   - 等待 `RefreshDelayMs` (1500 ms)，確保報表資料重新載入完成。
6. **點擊「資料匯出」(`ClickExportBtn`)**：
   - 點擊前以 `CaptureCsvState(outDir)` 擷取既有 CSV 的路徑與內容簽章基準。
   - **優先圖像辨識**：搜尋 `assets/{解析度}/資料匯出.png`（容許度 `variation := 45`），找到即點擊。
   - **座標備援機制**：若圖像比對未命中，自動讀取 `config/settings.ini` 中 `[ExportButton]` 區段之解析度座標（1920x1080 預設為 `X=1777, Y=50`）降級點擊；若未設定座標則安全中止並記錄 WARN 日誌。
   - 點擊後再次將游標移至 `(10, 10)` 避免 Hover 影響後續比對。
7. **輪詢捕捉新 CSV (`WaitNewCsv`)**：
   - 在 `outDir` 尋找相較基準新增或內容已改變的 CSV，避免同一秒內覆寫舊檔造成漏判。
   - 透過 `IsFileReady(csv)`（嘗試獨佔唯讀開啟）及連續兩次相同簽章，確認三竹已完成寫入。
   - 逾時 `TimeoutMs` (10 秒) 或檔案未就緒則回傳失敗。
8. **歸檔複製 (`CopyToDateDir`)**：
   - 將檔案複製至 `<專案根目錄>\熱門排行\<dateStr>\<原始檔名>.csv`（保留原檔名，同名覆蓋）。

### 2. 單項重試封裝：`ExportPopRankItem(itemNo, dateStr := "")`
- 驗證序號合法性（必須為 $\ge 1$ 之整數）。
- 進入迴圈執行 `TryExportPopRankItem`，最多自動重試 `MaxRetries` (2) 次。
- 每次重試前主動調用 `ResetPopRankState()` 並插入 300 ms 間隔，確保復原至乾淨基準環境。

### 3. 批次全項目匯出：`ExportPopRankAll(showMsgBox := true)`
- 讀取設定檔之項目總數 `TotalItems`（預設為 **44**）。
- 批次開始前以 `StageExistingCsvs` 暫存 OUT 目錄既有 CSV，避免三竹因同名檔已存在而不重新寫入，造成逾時後重複點擊同一項目。
- 批次啟動前取得統一日期字串 `dateStr := FormatTime(A_Now, "yyyyMMdd")`，整批共用同一個歸檔子目錄。
- 依序迴圈 `itemNo := 1 .. TotalItems` 執行單項匯出。
- 同一時間僅允許一個批次匯出；執行期間按 `Esc` 可要求在安全檢查點中止。
- 即時累計成功與失敗清單，所有執行歷程輸出至 [logs/app.log](logs/app.log)。
- 結束時顯示摘要訊息方塊（可透過 `showMsgBox := false` 抑制彈窗，供無頭測試與背景自動化使用）。
- 批次結束或異常中止時以 `FinalizeCsvStage` 恢復未被取代的檔案；同名舊版保留於 `logs\out-backups\`，不直接刪除。

---

## 五、 設定檔規範 (`config/settings.ini`)

設定檔採 **UTF-16 LE with BOM** 編碼格式維護：

```ini
[PopularRanking]
ClickX_1920x1080 = 77
ClickY_1920x1080 = 80
ClickX_2560x1440 = 78
ClickY_2560x1440 = 80
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
3. **實機手動測試工具**：執行 [tests/test_pop_rank_export.ahk](tests/test_pop_rank_export.ahk)。
   - 按 `F9`：執行單一項目手動測試（預設 Item 1）。
   - 按 `F10`：執行完整批次 44 項自動匯出測試。
   - 按 `$Esc`：強制中斷正在執行的測試流程（使用鍵盤 hook 避免與內部 `Send("{Esc}")` 重設狀態互相干擾）。

---

## 七、 測試與驗證體系

1. **無頭自動化單元測試**：[tests/test_export.ahk](tests/test_export.ahk)
   - 透過暫存目錄驗證 `FindNewCsv`、`WaitNewCsv`、`CopyToDateDir`、`IsFileReady`。
   - 驗證 `GetPopRankTotalItems` 預設值 (44) 與自訂讀取、`HasResAssets`、`PopRankAssets` 等純邏輯。
   - 整合於 [tests/run_tests.ahk](tests/run_tests.ahk) 全域測試套件。
2. **實機診斷與校正工具**：
   - [tests/diagnose_export_btn.ahk](tests/diagnose_export_btn.ahk)：驗證「資料匯出」圖像比對、座標計算與滑鼠平滑移動校正。
   - [tests/capture_asset.ahk](tests/capture_asset.ahk)：截取與更新按鈕與箭頭純淨圖檔資產。

```