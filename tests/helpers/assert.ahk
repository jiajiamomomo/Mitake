#Requires AutoHotkey v2.0

class Assert {
    static passedCount := 0
    static failedCount := 0
    static errors := []

    static AssertTrue(condition, message := "Expected true but got false") {
        if (condition) {
            this.passedCount++
        } else {
            this.failedCount++
            this.errors.Push(message)
            FileAppend("[FAIL] " message "`n", "*")
        }
    }

    static AssertEquals(expected, actual, message := "") {
        if (message == "") {
            message := "Expected: '" expected "', Got: '" actual "'"
        }
        if (expected == actual) {
            this.passedCount++
        } else {
            this.failedCount++
            this.errors.Push(message)
            FileAppend("[FAIL] " message "`n", "*")
        }
    }

    static Summary() {
        total := this.passedCount + this.failedCount
        summaryText := "`n========================================`n"
                     . "Test Summary: " total " Total, " this.passedCount " Passed, " this.failedCount " Failed.`n"
                     . "========================================`n"
        FileAppend(summaryText, "*")
        try {
            if !DirExist(A_ScriptDir "\..\logs")
                DirCreate(A_ScriptDir "\..\logs")
            FileDelete(A_ScriptDir "\..\logs\test_result.log")
        }
        try {
            FileAppend(summaryText, A_ScriptDir "\..\logs\test_result.log", "UTF-8")
        }
        return this.failedCount == 0
    }

    static Reset() {
        this.passedCount := 0
        this.failedCount := 0
        this.errors := []
    }
}
