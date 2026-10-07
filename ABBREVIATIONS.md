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
| `PopularRankingAssets` | `PopRankAssets` | 熱門排行匯出所需圖檔清單 |
| `GetPopularRankingTotalItems` | `GetPopRankTotalItems` | 讀取 `[PopularRanking] TotalItems` (預設 25) |
| `GetExportOutputDirectory` | `GetExportOutDir` | 讀取三竹 CSV 輸出目錄 `OutDir` |
| `GetPopularRankingDestinationRoot` | `GetPopRankDstRoot` | 取得 `<專案>\熱門排行` 目的根目錄 |
| `FindNewestCsvSince` | `FindNewCsv` | 尋找不早於指定時間的最新 CSV |
| `IsFileReady` | `IsFileReady` | 檢查檔案是否已寫入完成 |
| `WaitForNewCsv` | `WaitNewCsv` | 輪詢等待新 CSV 出現 |
| `CopyToDateDirectory` | `CopyToDateDir` | 複製至 `YYYYMMDD` 子資料夾 (同名覆蓋) |
| `HasResolutionAssets` | `HasResAssets` | 檢查指定解析度圖檔是否齊全 |
| `ResetPopularRankingState` | `ResetPopRankState` | 重設視窗狀態 (Esc 收合選單與移開滑鼠) |
| `ClickExportButton` | `ClickExportBtn` | 點擊資料匯出 (圖像優先，退回 `[ExportButton]` 座標) |
| `TryExportPopularRankingItem` | `TryExportPopRankItem` | 單次匯出單一項目 (不含重試) |
| `ExportPopularRankingItem` | `ExportPopRankItem` | 匯出單一項目 (含重試) |
| `ExportPopularRankingAll` | `ExportPopRankAll` | 批次匯出全部項目 |

### `Mitake.ahk` (Handlers & Helpers)
| 原名稱 | 新縮短名稱 | 說明 |
| :--- | :--- | :--- |
| `RegisterHotkey` | `RegisterHk` | 註冊快捷鍵設定與日誌記錄輔助函式 |
| `ShellMessage` | `ShellMsg` | ShellHook 監聽處理常式 |
| `MenuLaunchHandler` | `MenuLaunchHnd` | 托盤「啟動/切換 三竹股市」處理函式 |
| `MenuToggleMenuBarHandler` | `MenuToggleBarHnd` | 托盤「切換選單列」處理函式 |
| `MenuClickSecuritiesQuoteHandler` | `MenuSecQuoteHnd` | 托盤「證券行情」處理函式 |
| `MenuClickPopularRankingHandler` | `MenuPopRankHnd` | 托盤「熱門排行」處理函式 |
| `MenuClickAfterMarketRankingHandler` | `MenuAfterRankHnd` | 托盤「盤後排行」處理函式 |
| `MenuShowResolutionHandler` | `MenuShowResHnd` | 托盤「顯示解析度」處理函式 |
| `HotkeyLaunchHandler` | `HkLaunchHnd` | 快捷鍵啟動處理函式 |
| `HotkeyMenuBarHandler` | `HkMenuBarHnd` | 快捷鍵選單列處理函式 |
| `HotkeySecuritiesQuoteHandler` | `HkSecQuoteHnd` | 快捷鍵證券行情處理函式 |
| `HotkeyPopularRankingHandler` | `HkPopRankHnd` | 快捷鍵熱門排行處理函式 |
| `HotkeyAfterMarketRankingHandler` | `HkAfterRankHnd` | 快捷鍵盤後排行處理函式 |
