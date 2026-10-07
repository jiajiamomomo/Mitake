#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ..\lib\utils.ahk

; =============================================================================
; 資產截圖工具：以 1:1 實體像素擷取「非 Hover 狀態」的按鈕圖檔
; 用法：
;   AutoHotkey64.exe tests\capture_asset.ahk [檔名] [寬] [高]
;   預設：資料匯出.png 24x24
; 操作：將滑鼠指向目標按鈕中心 → 按 F8
;       工具會先把滑鼠移開 (清除 Hover)，等待 400ms 後擷取以原游標為中心的區域，
;       存至 assets\{解析度}\{檔名} (原檔會先備份為 .bak.png)
;   Esc 結束
; =============================================================================

name := A_Args.Length >= 1 ? A_Args[1] : "資料匯出.png"
capW := A_Args.Length >= 2 ? Integer(A_Args[2]) : 24
capH := A_Args.Length >= 3 ? Integer(A_Args[3]) : 24

CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")
SetTimer(ShowTip, 50)

ShowTip() {
    MouseGetPos(&mx, &my)
    ToolTip(Format("擷取 {1} ({2}x{3})`n螢幕座標: {4}, {5}`n[F8] 擷取  [Esc] 結束", name, capW, capH, mx, my), 10, 10)
}

F8:: {
    MouseGetPos(&mx, &my)
    x := mx - capW // 2, y := my - capH // 2
    SetTimer(ShowTip, 0)
    ToolTip()
    MouseMove(5, A_ScreenHeight // 2, 0)   ; 移開滑鼠清除 Hover
    Sleep(400)

    res := GetRes(0)
    dir := GetRootDir() "\assets\" res.str
    if !DirExist(dir)
        DirCreate(dir)
    out := dir "\" name
    if FileExist(out)
        FileCopy(out, RegExReplace(out, "\.png$", ".bak.png"), true)

    ps := Format("
    (
Add-Type -AssemblyName System.Drawing
Add-Type -Namespace W -Name U -MemberDefinition '[DllImport(\"user32.dll\")] public static extern bool SetProcessDPIAware();'
[W.U]::SetProcessDPIAware() | Out-Null
$b = New-Object System.Drawing.Bitmap {3}, {4}
$g = [System.Drawing.Graphics]::FromImage($b)
$g.CopyFromScreen({1}, {2}, 0, 0, $b.Size)
$b.Save('{5}', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $b.Dispose()
    )", "", x, y, capW, capH, out)
    tmp := A_Temp "\capture_asset.ps1"
    try FileDelete(tmp)
    FileAppend(ps, tmp, "UTF-8")
    RunWait(Format('powershell -NoProfile -ExecutionPolicy Bypass -File "{1}"', tmp), , "Hide")

    MouseMove(mx, my, 0)
    LogMsg(Format("資產截圖：已擷取 {1} (螢幕 {2},{3} {4}x{5})", out, x, y, capW, capH), "INFO")
    MsgBox(Format("已儲存：{1}`n區域：({2}, {3}) {4}x{5}", out, x, y, capW, capH), "資產截圖", "Iconi")
    SetTimer(ShowTip, 50)
}

Esc:: ExitApp()
