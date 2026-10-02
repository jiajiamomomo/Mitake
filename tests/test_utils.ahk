#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include helpers\assert.ahk

Test_GetConfig_DefaultValue() {
    val := GetConfig("NonExistentSection", "NonExistentKey", "DefaultTestValue")
    Assert.AssertEquals("DefaultTestValue", val, "GetConfig should return default value when key does not exist")
}

Test_LogMessage() {
    testMsg := "Unit Test Log Message"
    LogMessage(testMsg, "INFO")
    
    logFile := A_ScriptDir "\..\logs\app.log"
    Assert.AssertTrue(FileExist(logFile), "Log file should exist after LogMessage call")
}

Test_GetDisplayResolution() {
    res := GetDisplayResolution()
    Assert.AssertTrue(res.width > 0, "Primary display width should be greater than 0")
    Assert.AssertTrue(res.height > 0, "Primary display height should be greater than 0")
    Assert.AssertEquals(res.width "x" res.height, res.str, "Display resolution str formatted correctly")
    Assert.AssertTrue(res.isPrimary, "Default display resolution should be primary monitor")
}

Test_GetAllDisplaysResolution() {
    displays := GetAllDisplaysResolution()
    Assert.AssertTrue(displays.Length >= 1, "Should return at least one display")
    Assert.AssertTrue(displays[1].width > 0, "First display width should be greater than 0")
    Assert.AssertTrue(displays[1].height > 0, "First display height should be greater than 0")
}

Test_IsSupportedDisplayResolution() {
    Assert.AssertTrue(IsSupportedDisplayResolution("1920x1080"), "1920x1080 should be supported")
    Assert.AssertTrue(IsSupportedDisplayResolution("2560x1440"), "2560x1440 should be supported")
    Assert.AssertTrue(!IsSupportedDisplayResolution("1366x768"), "1366x768 should not be supported")
    Assert.AssertTrue(!IsSupportedDisplayResolution("3840x2160"), "3840x2160 should not be supported")
}

Test_ValidatePrimaryDisplayResolution() {
    ; Test ValidatePrimaryDisplayResolution without showing MsgBox during automated unit tests
    valid := ValidatePrimaryDisplayResolution(false)
    primaryRes := GetDisplayResolution(0)
    expectedValid := (primaryRes.str == "1920x1080" || primaryRes.str == "2560x1440")
    Assert.AssertEquals(expectedValid, valid, "ValidatePrimaryDisplayResolution should return expected boolean")
}

RunUtilsTests() {
    FileAppend("Running Utils Tests...`n", "*")
    Test_GetConfig_DefaultValue()
    Test_LogMessage()
    Test_GetDisplayResolution()
    Test_GetAllDisplaysResolution()
    Test_IsSupportedDisplayResolution()
    Test_ValidatePrimaryDisplayResolution()
}
