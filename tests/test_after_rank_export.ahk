#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2)
DetectHiddenWindows(false)

#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include ..\lib\export.ahk

; =============================================================================
; 手動實機驗證：盤後排行匯出 (會實際操作滑鼠與鍵盤，請勿在執行期間操作電腦)
; 用法：
;   AutoHotkey64.exe tests\test_after_rank_export.ahk          → 互動式輸入
;   AutoHotkey64.exe tests\test_after_rank_export.ahk 1 3      → 匯出分類 1 之子項目 3
;   AutoHotkey64.exe tests\test_after_rank_export.ahk 1,3      → 匯出分類 1 之子項目 3
;   AutoHotkey64.exe tests\test_after_rank_export.ahk 2        → 匯出分類 2 之所有子項目
;   AutoHotkey64.exe tests\test_after_rank_export.ahk all      → 批次匯出全部
; 執行期間按 Esc 可立即中止腳本
; =============================================================================

; $ 前綴強制使用鍵盤 hook，避免流程中 ResetAfterRankState 送出的 {Esc} 誤觸本中止熱鍵
$Esc:: {
    LogMsg("手動驗證 (盤後排行)：使用者按下 Esc 中止", "WARN")
    ExitApp(2)
}

arg1 := A_Args.Length >= 1 ? A_Args[1] : ""
arg2 := A_Args.Length >= 2 ? A_Args[2] : ""

if (arg1 == "") {
    prompt := "輸入要匯出的盤後排行項目：`n`n"
        . "  0 或 all       → 匯出全部項目`n"
        . "  1~5            → 匯出該分類下所有項目 (例: 1)`n"
        . "  L,R (逗號隔開)  → 匯出單一子項目 (例: 1,3)"
    ib := InputBox(prompt, "盤後排行匯出驗證", "w360 h180", "1,1")
    if (ib.Result != "OK")
        ExitApp(0)
    arg1 := Trim(ib.Value)
}

; 處理 "all" 或 "0"
if (arg1 = "all" || arg1 == "0") {
    r := ExportAfterRankAll(true)
    ExitApp(r.failed.Length || r.aborted ? 1 : 0)
}

; 解析 L 與 R 參數
itemNoL := 0, itemNoR := 0

if (arg2 != "") {
    itemNoL := Integer(arg1)
    itemNoR := Integer(arg2)
} else if InStr(arg1, ",") {
    parts := StrSplit(arg1, ",")
    itemNoL := Integer(Trim(parts[1]))
    itemNoR := Integer(Trim(parts[2]))
} else if InStr(arg1, "-") {
    parts := StrSplit(arg1, "-")
    itemNoL := Integer(Trim(parts[1]))
    itemNoR := Integer(Trim(parts[2]))
} else if IsInteger(arg1) {
    itemNoL := Integer(arg1)
    itemNoR := 0 ; 代表該分類全部
} else {
    MsgBox("參數格式無效：" arg1, "盤後排行匯出驗證", "Icon!")
    ExitApp(1)
}

totalL := GetAfterRankTotalItemsL()
if (itemNoL < 1 || itemNoL > totalL) {
    MsgBox(Format("左側分類序號無效 ({1})，有效範圍為 1~{2}", itemNoL, totalL), "盤後排行匯出驗證", "Icon!")
    ExitApp(1)
}

; 若指定了單一 R
if (itemNoR > 0) {
    totalR := GetAfterRankTotalItemsR(itemNoL)
    if (itemNoR > totalR) {
        MsgBox(Format("右側項目序號無效 ({1})，分類 #{2} 之有效範圍為 1~{3}", itemNoR, itemNoL, totalR), "盤後排行匯出驗證", "Icon!")
        ExitApp(1)
    }

    LogMsg(Format("手動驗證：開始執行盤後排行 L#{1} - R#{2}", itemNoL, itemNoR), "INFO")
    if !ExportAfterRankItemL(itemNoL) {
        MsgBox(Format("盤後排行 L#{1} 選取失敗。`n詳見 logs\app.log", itemNoL), "盤後排行匯出驗證", "Icon!")
        ExitApp(1)
    }
    ok := ExportAfterRankItemR(itemNoR, itemNoL)
    MsgBox(Format("盤後排行 L#{1} - R#{2} 匯出{3}。`n詳見 logs\app.log", itemNoL, itemNoR, ok ? "成功" : "失敗"), "盤後排行匯出驗證", ok ? "Iconi" : "Icon!")
    ExitApp(ok ? 0 : 1)
}

; 若僅指定 L，匯出該分類下之所有 R
totalR := GetAfterRankTotalItemsR(itemNoL)
LogMsg(Format("手動驗證：開始執行盤後排行分類 L#{1} 全部項目 (共 {2} 項)", itemNoL, totalR), "INFO")

if !ExportAfterRankItemL(itemNoL) {
    MsgBox(Format("盤後排行 L#{1} 選取失敗。`n詳見 logs\app.log", itemNoL), "盤後排行匯出驗證", "Icon!")
    ExitApp(1)
}

dateStr := FormatTime(A_Now, "yyyyMMdd")
okCount := 0, failCount := 0
Loop totalR {
    if ExportAfterRankItemR(A_Index, itemNoL, dateStr)
        okCount++
    else
        failCount++
}

summary := Format("盤後排行分類 L#{1} 匯出完成：成功 {2} / {3} 項", itemNoL, okCount, totalR)
MsgBox(summary "`n詳見 logs\app.log", "盤後排行匯出驗證", failCount ? "Icon!" : "Iconi")
ExitApp(failCount ? 1 : 0)
