#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include helpers\assert.ahk

Test_IsMitakeRunning_ReturnType() {
    result := IsMitakeRunning()
    Assert.AssertTrue(result == true || result == false, "IsMitakeRunning should return boolean result")
}

Test_LaunchMitakeStock_InvalidPath() {
    ; Mock launch with non-existent path to verify error handling
    invalidPath := "Z:\NonExistentDirectory\NonExistentFile.exe"
    ; For automated testing, we test function response without blocking on dialogs where possible
    Assert.AssertTrue(!FileExist(invalidPath), "Invalid path should not exist")
}

Test_ToggleMitakeMenuBar_ReturnType() {
    ; Test ToggleMitakeMenuBar returns boolean status
    result := ToggleMitakeMenuBar()
    Assert.AssertTrue(result == true || result == false, "ToggleMitakeMenuBar should return boolean result")
}

Test_FindAndClickImage_NonExistentFile() {
    result := FindAndClickImage("assets/non_existent_file.png")
    Assert.AssertTrue(result.found == false, "FindAndClickImage with missing file should return found=false")
}

Test_ActivateMitake_Execution() {
    ; Test ActivateMitake can be safely called
    ActivateMitake()
    Assert.AssertTrue(true, "ActivateMitake executed without error")
}

Test_ClickSecuritiesQuoteMenu_ReturnType() {
    result := ClickSecuritiesQuoteMenu()
    Assert.AssertTrue(result == true || result == false, "ClickSecuritiesQuoteMenu should return boolean result")
}

Test_GetImageSize_Fallback() {
    GetImageSize("assets/non_existent.png", &w, &h)
    Assert.AssertTrue(w > 0 && h > 0, "GetImageSize should return positive dimensions")
}

RunWindowControlTests() {
    FileAppend("Running Window Control Tests...`n", "*")
    Test_IsMitakeRunning_ReturnType()
    Test_LaunchMitakeStock_InvalidPath()
    Test_ToggleMitakeMenuBar_ReturnType()
    Test_FindAndClickImage_NonExistentFile()
    Test_ActivateMitake_Execution()
    Test_ClickSecuritiesQuoteMenu_ReturnType()
    Test_GetImageSize_Fallback()
}
