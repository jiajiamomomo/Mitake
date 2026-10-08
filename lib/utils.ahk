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
