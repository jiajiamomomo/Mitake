#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include helpers\assert.ahk

Test_GetCfg_DefVal() {
    val := GetCfg("NonExistentSection", "NonExistentKey", "DefaultTestValue")
    Assert.AssertEquals("DefaultTestValue", val, "GetCfg should return default value when key does not exist")
}

Test_LogMsg() {
    testMsg := "Unit Test Log Message"
    LogMsg(testMsg, "INFO")
    
    logFile := A_ScriptDir "\..\logs\app.log"
    Assert.AssertTrue(FileExist(logFile), "Log file should exist after LogMsg call")
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
    Test_LogMsg()
    Test_GetRes()
    Test_GetAllRes()
    Test_IsSupportedRes()
    Test_ValidatePriRes()
}
