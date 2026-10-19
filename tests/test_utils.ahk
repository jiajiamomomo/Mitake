#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include helpers\assert.ahk

Test_GetCfg_DefVal() {
    val := GetCfg("NonExistentSection", "NonExistentKey", "DefaultTestValue")
    Assert.AssertEquals("DefaultTestValue", val, "GetCfg should return default value when key does not exist")
}

Test_EnsureIniEnc_AtomicConversion() {
    utf8Path := A_Temp "\mitake_utf8_settings.ini"
    ansiPath := A_Temp "\mitake_ansi_settings.ini"
    try FileDelete(utf8Path)
    try FileDelete(ansiPath)

    FileAppend("[測試]`n名稱=三竹`n", utf8Path, "UTF-8-RAW")
    Assert.AssertTrue(EnsureIniEnc(utf8Path), "UTF-8 INI should convert successfully")
    utf8Raw := FileRead(utf8Path, "RAW")
    Assert.AssertTrue(utf8Raw.Size >= 2 && NumGet(utf8Raw, 0, "UChar") == 0xFF && NumGet(utf8Raw, 1, "UChar") == 0xFE, "Converted UTF-8 INI should have UTF-16 LE BOM")
    Assert.AssertTrue(InStr(FileRead(utf8Path, "UTF-16"), "三竹") > 0, "UTF-8 Chinese content should be preserved")

    FileAppend("[測試]`n名稱=三竹`n", ansiPath, "CP950")
    Assert.AssertTrue(EnsureIniEnc(ansiPath), "ANSI INI should convert successfully")
    Assert.AssertTrue(InStr(FileRead(ansiPath, "UTF-16"), "三竹") > 0, "ANSI Chinese content should be preserved")

    FileDelete(utf8Path)
    FileDelete(ansiPath)
}

Test_LogMsg() {
    testMsg := "Unit Test Log Message"
    LogMsg(testMsg, "INFO")
    
    logFile := A_ScriptDir "\..\logs\app.log"
    Assert.AssertTrue(FileExist(logFile), "Log file should exist after LogMsg call")
}

Test_WriteRotatingLog() {
    logDir := A_Temp "\\mitake-log-rotation-" DllCall("GetCurrentProcessId") "-" A_TickCount
    DirCreate(logDir)
    logFile := logDir "\\app.log"
    try {
        Loop 12
            WriteRotatingLog(logFile, "[INFO] 第" A_Index "筆測試訊息`n", 90, 2)

        Assert.AssertTrue(FileExist(logFile), "Current log should exist")
        Assert.AssertTrue(FileExist(logFile ".1"), "First archive should exist")
        Assert.AssertTrue(FileExist(logFile ".2"), "Second archive should exist")
        Assert.AssertTrue(!FileExist(logFile ".3"), "Archives should be bounded")
        for path in [logFile, logFile ".1", logFile ".2"]
            Assert.AssertTrue(FileGetSize(path) <= 90, "Each log file should stay within byte limit: " path)
        Assert.AssertTrue(InStr(FileRead(logFile, "UTF-8"), "第12筆") > 0, "Current log should contain newest entry")
        Assert.AssertTrue(InStr(FileRead(logFile ".2", "UTF-8"), "第1筆") == 0, "Oldest entries should be discarded")

        longLine := ""
        Loop 200
            longLine .= "中"
        WriteRotatingLog(logFile, longLine "`n", 90, 2)
        Assert.AssertTrue(FileGetSize(logFile) <= 90, "Oversized entry should be truncated within limit")
        Assert.AssertTrue(InStr(FileRead(logFile, "UTF-8"), "已截斷") > 0, "Truncation should be visible in log")

        oldLog := logDir "\\old.log"
        FileAppend(longLine, oldLog, "UTF-8")
        WriteRotatingLog(oldLog, "new entry`n", 90, 1)
        Assert.AssertTrue(FileGetSize(oldLog) <= 90, "Previously oversized log should rotate before append")
        Assert.AssertTrue(InStr(FileRead(oldLog, "UTF-8"), "new entry") > 0, "New entry should survive rotation")
    } finally {
        Loop Files, logDir "\\*", "F"
            FileDelete(A_LoopFileFullPath)
        DirDelete(logDir)
    }
}

Test_GetRes() {
    res := GetRes()
    Assert.AssertTrue(res.width > 0, "Primary display width should be greater than 0")
    Assert.AssertTrue(res.height > 0, "Primary display height should be greater than 0")
    Assert.AssertEquals(res.width "x" res.height, res.str, "Display resolution str formatted correctly")
    Assert.AssertTrue(res.isPrimary, "Default display resolution should be primary monitor")
}

Test_GetAllRes() {
    displays := GetAllRes()
    Assert.AssertTrue(displays.Length >= 1, "Should return at least one display")
    Assert.AssertTrue(displays[1].width > 0, "First display width should be greater than 0")
    Assert.AssertTrue(displays[1].height > 0, "First display height should be greater than 0")
}

Test_IsSupportedRes() {
    Assert.AssertTrue(IsSupportedRes("1920x1080"), "1920x1080 should be supported")
    Assert.AssertTrue(IsSupportedRes("2560x1440"), "2560x1440 should be supported")
    Assert.AssertTrue(!IsSupportedRes("1366x768"), "1366x768 should not be supported")
    Assert.AssertTrue(!IsSupportedRes("3840x2160"), "3840x2160 should not be supported")
}

Test_ValidatePriRes() {
    ; Test ValidatePriRes without showing MsgBox during automated unit tests
    valid := ValidatePriRes(false)
    priRes := GetRes(0)
    expectedValid := (priRes.str == "1920x1080" || priRes.str == "2560x1440")
    Assert.AssertEquals(expectedValid, valid, "ValidatePriRes should return expected boolean")
}

RunUtilsTests() {
    FileAppend("Running Utils Tests...`n", "*")
    Test_GetCfg_DefVal()
    Test_EnsureIniEnc_AtomicConversion()
    Test_LogMsg()
    Test_WriteRotatingLog()
    Test_GetRes()
    Test_GetAllRes()
    Test_IsSupportedRes()
    Test_ValidatePriRes()
}
