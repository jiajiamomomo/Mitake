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
    static KeyDelayMs := 30         ; 方向鍵之間的間隔
    static TimeoutMs := 10000       ; 輪詢匯出 CSV 之逾時
    static PollMs := 200            ; 輪詢間隔
    static MaxRetries := 2          ; 單一項目失敗後最多重試次數
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
 * 在輸出目錄中尋找修改時間不早於 sinceTime 的最新 CSV
 * @param {String} outDir 輸出目錄
 * @param {String} sinceTime 起始時間 (YYYYMMDDHH24MISS)
 * @returns {String} CSV 完整路徑，找不到則回傳空字串
 */
FindNewCsv(outDir, sinceTime) {
    if !DirExist(outDir)
        return ""
    newest := "", newestTime := ""
    Loop Files, outDir "\*.csv" {
        t := A_LoopFileTimeModified
        if (t >= sinceTime && (newest == "" || t > newestTime)) {
            newest := A_LoopFileFullPath
            newestTime := t
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
 * @param {String} sinceTime 起始時間 (YYYYMMDDHH24MISS)
 * @param {Integer} timeoutMs 逾時毫秒
 * @param {Integer} pollMs 輪詢間隔毫秒
 * @returns {String} CSV 完整路徑，逾時則回傳空字串
 */
WaitNewCsv(outDir, sinceTime, timeoutMs := 10000, pollMs := 200) {
    deadline := A_TickCount + timeoutMs
    Loop {
        csv := FindNewCsv(outDir, sinceTime)
        if (csv != "" && IsFileReady(csv))
            return csv
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
    if (coords.x == 0 && coords.y == 0) {
        LogMsg(Format("資料匯出：圖像未比對到且 [ExportButton] 未設定 {1} 座標", res.str), "WARN")
        return false
    }
    ClickPoint(coords.x, coords.y, winTitle, false)
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

    ; 3~5. PageUp × 5 次回首項 → Down × (itemNo-1) → Enter
    Loop 5 {
        Send("{PgUp}")
        Sleep(ExportTiming.KeyDelayMs)
    }
    Loop itemNo - 1 {
        Send("{Down}")
        Sleep(ExportTiming.KeyDelayMs)
    }
    Sleep(ExportTiming.KeyDelayMs)
    Send("{Enter}")

    ; 選取後立即移開滑鼠，避免游標停在按鈕上方造成 Hover 影響或干擾畫面
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)

    ; 6. 等待資料刷新
    Sleep(ExportTiming.RefreshDelayMs)

    ; 7. 點擊資料匯出 (記錄觸發時間以辨識新產生的 CSV；圖像辨識失敗時退回 settings.ini 座標)
    sinceTime := A_Now
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
    outDir := GetExportOutDir("PopularRanking")
    csv := WaitNewCsv(outDir, sinceTime, ExportTiming.TimeoutMs, ExportTiming.PollMs)
    if (csv == "") {
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
    if (!IsInteger(itemNo) || itemNo < 1) {
        LogMsg(Format("熱門排行匯出：項目序號無效 ({1})", itemNo), "ERROR")
        return false
    }
    if (dateStr == "")
        dateStr := FormatTime(A_Now, "yyyyMMdd")

    Loop ExportTiming.MaxRetries + 1 {
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
        if ExportPopRankItem(A_Index, dateStr)
            result.ok.Push(A_Index)
        else
            result.failed.Push(A_Index)
    }

    failedStr := ""
    for n in result.failed
        failedStr .= (failedStr == "" ? "" : ", ") n
    summary := Format("熱門排行匯出完成：成功 {1} / {2} 項{3}", result.ok.Length, total
        , result.failed.Length ? "`n失敗項目：" failedStr : "")
    LogMsg(StrReplace(summary, "`n", "；"), result.failed.Length ? "WARN" : "INFO")
    if showMsgBox
        MsgBox(summary, "熱門排行匯出", result.failed.Length ? "Icon!" : "Iconi")
    return result
}
