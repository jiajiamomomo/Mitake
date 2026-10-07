#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2)
DetectHiddenWindows(false)

#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include ..\lib\export.ahk

; =============================================================================
; 手動實機驗證：熱門排行匯出 (會實際操作滑鼠與鍵盤，請勿在執行期間操作電腦)
; 用法：
;   AutoHotkey64.exe tests\test_pop_rank_export.ahk        → 互動式輸入項目序號 (0 = 全部)
;   AutoHotkey64.exe tests\test_pop_rank_export.ahk 3      → 只匯出第 3 項
;   AutoHotkey64.exe tests\test_pop_rank_export.ahk all    → 批次匯出全部
; 執行期間按 Esc 可立即中止腳本
; =============================================================================

; $ 前綴強制使用鍵盤 hook，避免流程中 ResetPopRankState 送出的 {Esc} 誤觸本中止熱鍵
$Esc:: {
    LogMsg("手動驗證：使用者按下 Esc 中止", "WARN")
    ExitApp(2)
}

arg := A_Args.Length ? A_Args[1] : ""
if (arg == "") {
    ib := InputBox(Format("輸入要匯出的熱門排行項目序號 (1~{1})，0 = 全部：", GetPopRankTotalItems()), "熱門排行匯出驗證", "w320 h130", "1")
    if (ib.Result != "OK")
        ExitApp(0)
    arg := ib.Value
}

if (arg = "all" || arg == "0") {
    r := ExportPopRankAll(true)
    ExitApp(r.failed.Length || r.aborted ? 1 : 0)
}

if !IsInteger(arg) {
    MsgBox("項目序號無效：" arg, "熱門排行匯出驗證", "Icon!")
    ExitApp(1)
}

ok := ExportPopRankItem(Integer(arg))
MsgBox(Format("熱門排行 #{1} 匯出{2}。`n詳見 logs\app.log", arg, ok ? "成功" : "失敗"), "熱門排行匯出驗證", ok ? "Iconi" : "Icon!")
ExitApp(ok ? 0 : 1)
