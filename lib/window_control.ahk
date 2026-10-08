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
