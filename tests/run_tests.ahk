#Requires AutoHotkey v2.0
#Include test_utils.ahk
#Include test_window_control.ahk

FileAppend("========================================`n", "*")
FileAppend("Starting AutoHotkey Unit Test Runner`n", "*")
FileAppend("========================================`n", "*")

Assert.Reset()

RunUtilsTests()
RunWindowControlTests()

success := Assert.Summary()

if (!success) {
    ExitApp(1)
} else {
    ExitApp(0)
}
