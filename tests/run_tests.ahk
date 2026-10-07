#Requires AutoHotkey v2.0
#Include test_utils.ahk
#Include test_window_control.ahk
#Include test_export.ahk

FileAppend("========================================`n", "*")
FileAppend("Starting AutoHotkey Unit Test Runner`n", "*")
FileAppend("========================================`n", "*")

Assert.Reset()

RunUtilsTests()
RunWindowControlTests()
RunExportTests()

success := Assert.Summary()

if (!success) {
    ExitApp(1)
} else {
    ExitApp(0)
}
