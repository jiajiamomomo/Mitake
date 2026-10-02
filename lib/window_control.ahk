#Requires AutoHotkey v2.0

/**
 * 取得三竹股市主程式視窗之 WinTitle
 * @returns {String} 主程式視窗 WinTitle (預設: "三竹股市")
 */
GetMainWindowTitle() {
    return GetConfig("App", "MainWinTitle", GetConfig("App", "WinTitle", "三竹股市"))
}

/**
 * 取得「熱門排行」視窗之 WinTitle
 * @returns {String} 熱門排行視窗 WinTitle (預設: "熱門排行")
 */
GetPopularRankingWindowTitle() {
    return GetConfig("App", "PopularRankingWinTitle", "熱門排行")
}

/**
 * 取得「盤後排行」視窗之 WinTitle
 * @returns {String} 盤後排行視窗 WinTitle (預設: "盤後排行")
 */
GetAfterMarketRankingWindowTitle() {
    return GetConfig("App", "AfterMarketRankingWinTitle", "盤後排行")
}

/**
 * 切換至三竹股市主程式視窗 (WinTitle: "三竹股市") 並置於最前台與最大化
 * 僅主程式視窗具備 menu bar，點擊 menu bar 前應先調用本函式切換到主程式視窗
 * @param {Integer} timeout 等待視窗就緒之超時秒數 (預設 3 秒)
 * @returns {Boolean} 切換是否成功
 */
SwitchToMainWindow(timeout := 3) {
    mainWinTitle := GetMainWindowTitle()
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    hwnd := WinExist(mainWinTitle) ? WinExist(mainWinTitle) : WinExist("ahk_exe " procName)
    
    if !hwnd {
        LogMessage(Format("切換主程式視窗失敗：未偵測到主程式視窗 [{1}]", mainWinTitle), "WARN")
        return false
    }
    
    ActivateMitake(hwnd)
    
    if WinWaitActive(hwnd, , timeout) {
        LogMessage(Format("已成功切換至主程式視窗: {1}", mainWinTitle), "INFO")
        return true
    } else {
        return WinExist(hwnd) ? true : false
    }
}

/**
 * 檢查三竹股市是否正在執行
 * @returns {Boolean} 是否在執行中
 */
IsMitakeRunning() {
    mainTitle := GetMainWindowTitle()
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    
    return (WinExist(mainTitle) || WinExist("ahk_exe " procName) || ProcessExist(procName)) ? true : false
}

/**
 * 啟動並定位「三竹股市電腦版」
 * @param {String} customPath 可選的自訂執行檔路徑
 * @returns {Boolean} 啟動或聚焦是否成功
 */
LaunchMitakeStock(customPath := "") {
    ; 0. 驗證主顯示器解析度 (僅支援 1920x1080 或 2560x1440)
    if !ValidatePrimaryDisplayResolution(true) {
        return false
    }

    mainWinTitle := GetMainWindowTitle()
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    timeoutStr := GetConfig("App", "Timeout", "15")
    timeout := Integer(timeoutStr)

    ; 1. 若主程式視窗已經存在，切換至主程式視窗並最大化
    if WinExist(mainWinTitle) || WinExist("ahk_exe " procName) {
        LogMessage("三竹股市已在執行中，正在切換至主程式視窗...", "INFO")
        return SwitchToMainWindow()
    } else if ProcessExist(procName) {
        LogMessage("檢測到三竹股市程序運作中，等待主程式視窗出現...", "INFO")
        if WinWait(mainWinTitle, , 5) || WinWait("ahk_exe " procName, , 5) {
            return SwitchToMainWindow()
        }
    }

    ; 2. 確定執行檔路徑
    targetPath := customPath != "" ? customPath : GetConfig("App", "Path", "D:\Program Files\MitakeGU\三竹股市.exe")

    if !FileExist(targetPath) {
        errMsg := Format("找不到三竹股市執行檔: {1}", targetPath)
        LogMessage(errMsg, "ERROR")
        MsgBox(errMsg "`n請確認安裝路徑或至 config/settings.ini 設定。", "錯誤", "Icon!")
        return false
    }

    ; 3. 執行程式
    LogMessage(Format("正在啟動三竹股市: {1}", targetPath), "INFO")
    SplitPath(targetPath, &fileName, &dirPath)
    
    try {
        Run(targetPath, dirPath)
    } catch as err {
        LogMessage(Format("啟動失敗: {1}", err.Message), "ERROR")
        MsgBox(Format("無法啟動三竹股市：{1}", err.Message), "啟動失敗", "Icon!")
        return false
    }

    ; 4. 等待主程式視窗開啟 (同時兼容主標題或程序名稱)
    if WinWait(mainWinTitle, , timeout) || WinWait("ahk_exe " procName, , timeout) {
        LogMessage("三竹股市主程式視窗已成功啟動。", "INFO")
        Sleep(500)
        return SwitchToMainWindow()
    } else {
        LogMessage(Format("啟動三竹股市超時 ({1} 秒內未偵測到主程式視窗)。", timeout), "WARN")
        return false
    }
}

/**
 * 聚焦並將指定視窗或三竹股市主視窗最大化
 * 若視窗處於最小化狀態則先還原；若已最大化則避免重覆最大化以防下拉選單被強制關閉
 * @param {Integer|String} target 視窗 HWND 或 WinTitle (0 代表預設主程式視窗)
 * @returns {Boolean} 是否成功激活
 */
ActivateMitake(target := 0) {
    mainWinTitle := GetMainWindowTitle()
    targetWin := (target != 0) ? target : mainWinTitle
    hwnd := WinExist(targetWin)
    if !hwnd {
        procName := GetConfig("App", "ProcessName", "三竹股市.exe")
        hwnd := WinExist("ahk_exe " procName)
    }
    
    if !hwnd {
        return false
    }
    
    ; 1. 若視窗處於最小化，先還原以確保正常顯示於桌面
    minMax := WinGetMinMax(hwnd)
    if (minMax == -1) {
        WinRestore(hwnd)
        Sleep(50)
    }
    
    ; 2. 設置前景焦點鎖定許可並激活視窗
    DllCall("user32\AllowSetForegroundWindow", "Int", -1)
    DllCall("user32\SetForegroundWindow", "Ptr", hwnd)
    WinActivate(hwnd)
    
    ; 3. 若未處於最大化狀態，再進行最大化，避免重覆最大化關閉已展開的選單
    if (WinGetMinMax(hwnd) != 1) {
        WinMaximize(hwnd)
    }
    
    LogMessage(Format("已將視窗 [{1}] (HWND: {2}) 切換至最前台並最大化。", targetWin, hwnd), "INFO")
    return true
}

/**
 * 切換或開啟「三竹股市電腦版」選單列 (Menu Bar)
 * 由於三竹股市電腦版採用自訂 GUI 介面，非標準 Win32 選單列，
 * 本函式支援聚焦視窗後傳送選單快捷鍵、相對座標點擊或圖像辨識定位點擊。
 * @returns {Boolean} 執行是否成功
 */
ToggleMitakeMenuBar() {
    mainWinTitle := GetMainWindowTitle()
    
    if !WinExist(mainWinTitle) && !IsMitakeRunning() {
        LogMessage("切換選單列失敗：三竹股市未開啟", "WARN")
        return false
    }
    
    ; 僅主程式視窗有 menu bar，切換至主程式視窗
    if !SwitchToMainWindow() {
        return false
    }
    
    ; 讀取設定檔中的觸發模式 (key, click, image)
    mode := GetConfig("MenuBar", "TriggerMode", "click")
    clickMethod := GetConfig("App", "ClickMethod", "physical")
    
    if (mode == "image") {
        res := GetDisplayResolution(0)
        imgPath := Format("assets/{1}/menu.png", res.str)
        if !FileExist(imgPath) {
            imgPath := Format("assets/menu_{1}.png", res.str)
        }
        if !FileExist(imgPath) {
            imgPath := GetConfig("MenuBar", "ImagePath", "assets/1920x1080/menu.png")
        }
        imgRes := FindAndClickImage(imgPath, 0, 0, 1200, 400, 30, mainWinTitle)
        if imgRes.found {
            return true
        } else {
            ; 影像辨識退回預設座標點擊
            clickX := Integer(GetConfig("MenuBar", "ClickX", "35"))
            clickY := Integer(GetConfig("MenuBar", "ClickY", "45"))
            if (clickMethod == "control") {
                ControlClick(Format("X{1} Y{2}", clickX, clickY), mainWinTitle)
            } else {
                oldMouse := CoordMode("Mouse", "Client")
                WinActivate(mainWinTitle)
                MouseMove(clickX, clickY, 0)
                Click(clickX, clickY)
                CoordMode("Mouse", oldMouse)
            }
            LogMessage(Format("圖像搜尋未找到，降級採用座標點擊 (X:{1}, Y:{2})", clickX, clickY), "WARN")
            return true
        }
    } else if (mode == "click") {
        ; 模擬點擊選單按鈕 (預設座標可由 settings.ini 自訂)
        clickX := Integer(GetConfig("MenuBar", "ClickX", "35"))
        clickY := Integer(GetConfig("MenuBar", "ClickY", "45"))
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), mainWinTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            WinActivate(mainWinTitle)
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("已對三竹股市視窗進行選單點擊 (X:{1}, Y:{2})", clickX, clickY), "INFO")
    } else {
        ; 傳送選單按鍵 (預設傳送 Alt 鍵)
        triggerKey := GetConfig("MenuBar", "TriggerKey", "{Alt}")
        Send(triggerKey)
        LogMessage(Format("已發送選單列快捷鍵: {1}", triggerKey), "INFO")
    }
    
    return true
}

/**
 * 取得圖像寬度與高度
 * @param {String} imagePath 圖像路徑
 * @param {VarRef} width 傳出寬度
 * @param {VarRef} height 傳出高度
 */
GetImageSize(imagePath, &width, &height) {
    width := 20, height := 20
    if !FileExist(imagePath)
        return
    try {
        g := Gui()
        pic := g.Add("Pic",, imagePath)
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
 * @param {String} imagePath 圖像檔案路徑
 * @param {Integer} winX1 搜尋區域左上 X
 * @param {Integer} winY1 搜尋區域左上 Y
 * @param {Integer} winX2 搜尋區域右下 X
 * @param {Integer} winY2 搜尋區域右下 Y
 * @param {Integer} variation 色彩容許度 (0-255)
 * @param {String} targetWin 指定目標視窗 (若未指定則使用主程式視窗)
 * @param {Boolean} shouldActivate 是否先激活視窗 (搜尋已展開之選單時應設為 false 以免關閉選單)
 * @returns {Object} {found: Boolean, x: Integer, y: Integer}
 */
FindAndClickImage(imagePath, winX1 := 0, winY1 := 0, winX2 := 1200, winY2 := 400, variation := 30, targetWin := "", shouldActivate := true) {
    if !FileExist(imagePath) {
        LogMessage(Format("找不到搜尋圖像檔案: {1}", imagePath), "WARN")
        return {found: false, x: 0, y: 0}
    }
    
    winTitle := (targetWin != "") ? targetWin : GetMainWindowTitle()
    hwnd := WinExist(winTitle)
    if !hwnd {
        procName := GetConfig("App", "ProcessName", "三竹股市.exe")
        hwnd := WinExist("ahk_exe " procName)
    }
    if !hwnd {
        return {found: false, x: 0, y: 0}
    }
    
    if (shouldActivate && !WinActive(hwnd)) {
        ActivateMitake(hwnd)
    }
    
    oldPixel := CoordMode("Pixel", "Client")
    oldMouse := CoordMode("Mouse", "Client")
    
    try {
        searchSpec := Format("*{} {}", variation, imagePath)
        
        if ImageSearch(&foundX, &foundY, winX1, winY1, winX2, winY2, searchSpec) {
            GetImageSize(imagePath, &imgW, &imgH)
            targetX := foundX + (imgW // 2)
            targetY := foundY + (imgH // 2)
            
            clickMethod := GetConfig("App", "ClickMethod", "physical")
            
            if (clickMethod == "control") {
                ControlClick(Format("X{} Y{}", targetX, targetY), hwnd)
            } else {
                ; 實體滑鼠移動與點擊 (自訂繪製視窗必備)
                if (shouldActivate && !WinActive(hwnd)) {
                    WinActivate(hwnd)
                }
                MouseMove(targetX, targetY, 0)
                Click(targetX, targetY)
            }
            
            LogMessage(Format("圖像辨識成功 ({1})，圖案尺寸({2}x{3})，已用[{4}]點擊中心座標 ({5}, {6})", imagePath, imgW, imgH, clickMethod, targetX, targetY), "INFO")
            
            CoordMode("Pixel", oldPixel)
            CoordMode("Mouse", oldMouse)
            return {found: true, x: targetX, y: targetY}
        }
    } catch as err {
        LogMessage(Format("ImageSearch 執行異常: {1}", err.Message), "WARN")
    }
    
    CoordMode("Pixel", oldPixel)
    CoordMode("Mouse", oldMouse)
    LogMessage(Format("圖像辨識未找到匹配項目: {1}", imagePath), "WARN")
    return {found: false, x: 0, y: 0}
}

/**
 * 取得專案根目錄路徑
 * @returns {String} 專案根目錄絕對路徑
 */
GetProjectRootDir() {
    static rootDir := ""
    if (rootDir != "")
        return rootDir
    
    dir := A_ScriptDir
    Loop 5 {
        if FileExist(dir "\assets") && (FileExist(dir "\Mitake.ahk") || FileExist(dir "\config\settings.ini")) {
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
 * 取得指定資產圖檔的路徑，優先匹配當前主顯示器解析度 (或指定解析度)
 * @param {String} assetName 圖檔名稱 (如 "menu_證券行情.png" 或 "盤後排行.png")
 * @param {String} targetRes 可選的目標解析度 (例: "2560x1440" 或 "1920x1080")，預設抓取主顯示器解析度
 * @returns {String} 解析後的圖檔完整路徑
 */
GetAssetImagePath(assetName, targetRes := "") {
    if !InStr(assetName, ".") {
        assetName .= ".png"
    }
    if (targetRes == "") {
        res := GetDisplayResolution(0)
        targetRes := res.str
    }
    
    rootDir := GetProjectRootDir()
    
    ; 1. 優先匹配 assets/{解析度}/{檔名} (例如 assets/2560x1440/盤後排行.png)
    p1 := rootDir "\assets\" targetRes "\" assetName
    if FileExist(p1)
        return p1
        
    ; 2. 匹配向下相容命名 assets/{檔名無副檔名}_{解析度}.png
    nameNoExt := SubStr(assetName, 1, InStr(assetName, ".", , -1) - 1)
    p2 := rootDir "\assets\" nameNoExt "_" targetRes ".png"
    if FileExist(p2)
        return p2
        
    ; 3. 備援尋找 2560x1440 目錄
    p3 := rootDir "\assets\2560x1440\" assetName
    if FileExist(p3)
        return p3

    ; 4. 備援尋找 1920x1080 目錄
    p4 := rootDir "\assets\1920x1080\" assetName
    if FileExist(p4)
        return p4
        
    ; 5. 備援尋找 assets/ 直屬目錄
    p5 := rootDir "\assets\" assetName
    if FileExist(p5)
        return p5
        
    ; 若皆不存在，傳回最符合預期的路徑 p1
    return p1
}

/**
 * 點擊「三竹股市」選單列的「證券行情」項目
 * 僅主程式視窗具備 menu bar，點擊前應先切換到主程式視窗 (WinTitle: "三竹股市")
 * 參照 assets/{resolution}/menu_證券行情.png 進行圖像辨識定位與點擊
 * @returns {Boolean} 點擊是否成功
 */
ClickSecuritiesQuoteMenu() {
    mainWinTitle := GetMainWindowTitle()
    
    ; 點擊 menu bar「證券行情」前應先切換到主程式視窗
    if !SwitchToMainWindow() {
        LogMessage("點擊證券行情失敗：無法切換至主程式視窗", "WARN")
        return false
    }
    
    Sleep(200) ; 確保切換至主程式視窗並渲染就緒
    
    res := GetDisplayResolution(0)
    imgPath := GetAssetImagePath("menu_證券行情.png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 500 : 350
    
    imgRes := FindAndClickImage(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    if imgRes.found {
        LogMessage("已成功透過圖像辨識點擊「證券行情」。", "INFO")
        return true
    } else {
        ; 影像搜尋若未比對成功，降級採用預設相對座標點擊
        clickX := Integer(GetConfig("SecuritiesQuote", "ClickX", "337"))
        clickY := Integer(GetConfig("SecuritiesQuote", "ClickY", "14"))
        clickMethod := GetConfig("App", "ClickMethod", "physical")
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), mainWinTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("圖像辨識點擊「證券行情」未比對到 ({1})，降級採用座標點擊 (X:{2}, Y:{3})", imgPath, clickX, clickY), "WARN")
        return true
    }
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「熱門排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "熱門排行"
 * 參照 assets/{resolution}/熱門排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「熱門排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickPopularRankingMenu(waitNewWindow := true, timeout := 5) {
    ; 1. 點擊 menu bar 前應先切換到主程式視窗並點擊「證券行情」
    if !ClickSecuritiesQuoteMenu() {
        LogMessage("點擊熱門排行失敗：開啟證券行情選單未成功", "WARN")
        return false
    }
    
    Sleep(300) ; 等待選單展開
    
    ; 2. 尋找與點擊「熱門排行」 (shouldActivate 設為 false，避免關閉已展開的下拉選單)
    mainWinTitle := GetMainWindowTitle()
    res := GetDisplayResolution(0)
    imgPath := GetAssetImagePath("熱門排行.png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 750 : 500
    
    imgRes := FindAndClickImage(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    clicked := false
    if imgRes.found {
        LogMessage("已成功透過圖像辨識點擊「熱門排行」。", "INFO")
        clicked := true
    } else {
        ; 影像搜尋若未比對成功，降級採用預設相對座標點擊 (不重複調用 WinActivate，以免關閉選單)
        clickX := Integer(GetConfig("PopularRanking", "ClickX", "78"))
        clickY := Integer(GetConfig("PopularRanking", "ClickY", "80"))
        clickMethod := GetConfig("App", "ClickMethod", "physical")
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), mainWinTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("圖像辨識點擊「熱門排行」未比對到 ({1})，降級採用座標點擊 (X:{2}, Y:{3})", imgPath, clickX, clickY), "WARN")
        clicked := true
    }
    
    ; 3. 點擊後出現新視窗且 WinTitle 為 "熱門排行"
    if (clicked && waitNewWindow) {
        popWinTitle := GetPopularRankingWindowTitle()
        procName := GetConfig("App", "ProcessName", "三竹股市.exe")
        hwnd := 0
        if WinWait(popWinTitle, , timeout) || WinWait(popWinTitle " ahk_exe " procName, , timeout) {
            hwnd := WinExist(popWinTitle) ? WinExist(popWinTitle) : WinExist(popWinTitle " ahk_exe " procName)
            ActivateMitake(hwnd)
            LogMessage(Format("已偵測到「熱門排行」新視窗 ({1}) 並最大化顯示", popWinTitle), "INFO")
        } else {
            LogMessage(Format("等待「熱門排行」新視窗 ({1}) 出現超時 ({2} 秒)", popWinTitle, timeout), "WARN")
        }
    }
    
    return clicked
}

/**
 * 對「三竹股市」主程式視窗點擊選單列「證券行情」→「盤後排行」
 * 點擊 menu bar 前會先切換到主程式視窗，點擊後會出現新視窗且 WinTitle 為 "盤後排行"
 * 參照 assets/{resolution}/盤後排行.png 進行圖像辨識定位與點擊
 * @param {Boolean} waitNewWindow 點擊後是否等待「盤後排行」新視窗出現 (預設 true)
 * @param {Integer} timeout 等待新視窗超時秒數 (預設 5 秒)
 * @returns {Boolean} 點擊是否成功
 */
ClickAfterMarketRankingMenu(waitNewWindow := true, timeout := 5) {
    ; 1. 點擊 menu bar 前應先切換到主程式視窗並點擊「證券行情」
    if !ClickSecuritiesQuoteMenu() {
        LogMessage("點擊盤後排行失敗：開啟證券行情選單未成功", "WARN")
        return false
    }
    
    Sleep(300) ; 等待選單展開
    
    ; 2. 尋找與點擊「盤後排行」 (shouldActivate 設為 false，避免關閉已展開的下拉選單)
    mainWinTitle := GetMainWindowTitle()
    res := GetDisplayResolution(0)
    imgPath := GetAssetImagePath("盤後排行.png")
    searchW := (res.width >= 2560) ? 2000 : 1200
    searchH := (res.height >= 1440) ? 750 : 500
    
    imgRes := FindAndClickImage(imgPath, 0, 0, searchW, searchH, 30, mainWinTitle, false)
    clicked := false
    if imgRes.found {
        LogMessage("已成功透過圖像辨識點擊「盤後排行」。", "INFO")
        clicked := true
    } else {
        ; 影像搜尋若未比對成功，降級採用預設相對座標點擊 (不重複調用 WinActivate，以免關閉選單)
        clickX := Integer(GetConfig("AfterMarketRanking", "ClickX", "78"))
        clickY := Integer(GetConfig("AfterMarketRanking", "ClickY", "110"))
        clickMethod := GetConfig("App", "ClickMethod", "physical")
        if (clickMethod == "control") {
            ControlClick(Format("X{1} Y{2}", clickX, clickY), mainWinTitle)
        } else {
            oldMouse := CoordMode("Mouse", "Client")
            MouseMove(clickX, clickY, 0)
            Click(clickX, clickY)
            CoordMode("Mouse", oldMouse)
        }
        LogMessage(Format("圖像辨識點擊「盤後排行」未比對到 ({1})，降級採用座標點擊 (X:{2}, Y:{3})", imgPath, clickX, clickY), "WARN")
        clicked := true
    }
    
    ; 3. 點擊後出現新視窗且 WinTitle 為 "盤後排行"
    if (clicked && waitNewWindow) {
        afterWinTitle := GetAfterMarketRankingWindowTitle()
        procName := GetConfig("App", "ProcessName", "三竹股市.exe")
        hwnd := 0
        if WinWait(afterWinTitle, , timeout) || WinWait(afterWinTitle " ahk_exe " procName, , timeout) {
            hwnd := WinExist(afterWinTitle) ? WinExist(afterWinTitle) : WinExist(afterWinTitle " ahk_exe " procName)
            ActivateMitake(hwnd)
            LogMessage(Format("已偵測到「盤後排行」新視窗 ({1}) 並最大化顯示", afterWinTitle), "INFO")
        } else {
            LogMessage(Format("等待「盤後排行」新視窗 ({1}) 出現超時 ({2} 秒)", afterWinTitle, timeout), "WARN")
        }
    }
    
    return clicked
}

/**
 * 切換至「熱門排行」視窗 (WinTitle: "熱門排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToPopularRankingWindow(timeout := 5) {
    popWinTitle := GetPopularRankingWindowTitle()
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    hwnd := WinExist(popWinTitle) ? WinExist(popWinTitle) : WinExist(popWinTitle " ahk_exe " procName)
    if hwnd {
        ActivateMitake(hwnd)
        LogMessage(Format("已切換至現有的「熱門排行」視窗: {1}", popWinTitle), "INFO")
        return true
    }
    
    LogMessage("「熱門排行」視窗尚未開啟，切換至主程式點擊選單開啟...", "INFO")
    return ClickPopularRankingMenu(true, timeout)
}

/**
 * 切換至「盤後排行」視窗 (WinTitle: "盤後排行") 並置於最前台與最大化
 * 若視窗已存在則直接切換；若未開啟則自動點擊選單開啟新視窗
 * @param {Integer} timeout 等待視窗出現之超時秒數 (預設 5 秒)
 * @returns {Boolean} 切換或開啟是否成功
 */
SwitchToAfterMarketRankingWindow(timeout := 5) {
    afterWinTitle := GetAfterMarketRankingWindowTitle()
    procName := GetConfig("App", "ProcessName", "三竹股市.exe")
    hwnd := WinExist(afterWinTitle) ? WinExist(afterWinTitle) : WinExist(afterWinTitle " ahk_exe " procName)
    if hwnd {
        ActivateMitake(hwnd)
        LogMessage(Format("已切換至現有的「盤後排行」視窗: {1}", afterWinTitle), "INFO")
        return true
    }
    
    LogMessage("「盤後排行」視窗尚未開啟，切換至主程式點擊選單開啟...", "INFO")
    return ClickAfterMarketRankingMenu(true, timeout)
}


