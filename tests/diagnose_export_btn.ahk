#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include ..\lib\export.ahk

; =============================================================================
; 診斷工具：檢視滑鼠座標與「資料匯出」圖像比對狀態
;
; 功能操作：
;   [Space] - 自動移開滑鼠消除 Hover 狀態，並測試比對各容許度之「資料匯出.png」
;   [Enter] - 測試模擬點擊 (先圖像辨識，若失敗則降級為 settings.ini 座標點擊)
;   [Esc]   - 結束工具 (使用 $Esc 避免自身送鍵誤觸)
; =============================================================================

SetTitleMatchMode(2)
DetectHiddenWindows(false)

CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")
CoordMode("ToolTip", "Screen")

SetTimer(ShowInfo, 50)

ShowInfo() {
    MouseGetPos(&mx, &my, &mHwnd)
    title := WinGetTitle(mHwnd)
    ToolTip(Format("【滑鼠與匯出診斷】`n視窗: {1} (HWND: {2})`nClient 座標: X: {3}, Y: {4}`n`n[Space] 測試比對 資料匯出.png (自動移開游標)`n[Enter] 測試點擊資料匯出 (圖像 + 座標降級)`n[Esc] 結束工具", title, mHwnd, mx, my), 10, 10)
}

Space:: {
    ; 優先嘗試取得當前滑鼠下的視窗，若非三竹則尋找「熱門排行」視窗
    MouseGetPos(, , &hoverHwnd)
    hoverTitle := WinGetTitle(hoverHwnd)
    
    hwnd := 0
    if InStr(hoverTitle, "熱門排行") || InStr(hoverTitle, "三竹")
        hwnd := hoverHwnd
    else
        hwnd := FindMitakeWin(GetPopRankWinTitle())
    
    if !hwnd || !WinExist(hwnd) {
        MsgBox("未找到「熱門排行」視窗，請先開啟或將滑鼠移至該視窗上方。", "偵錯", "Icon!")
        return
    }
    
    ; 測試前暫停 ToolTip 並將滑鼠移至空白處清除 Hover 高亮狀態
    SetTimer(ShowInfo, 0)
    ToolTip()
    
    ; 確保視窗處於激活狀態，並在該視窗客戶區移開游標
    if !WinActive(hwnd) {
        WinActivate(hwnd)
        Sleep(100)
    }
    
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)
    Sleep(300)
    
    if !WinExist(hwnd) {
        MsgBox("視窗已不存在。", "偵錯", "Icon!")
        SetTimer(ShowInfo, 50)
        return
    }
    
    cw := 0, ch := 0
    try {
        WinGetClientPos(&cx, &cy, &cw, &ch, hwnd)
    } catch as err {
        MsgBox(Format("取得視窗客戶區座標失敗: {1}", err.Message), "錯誤", "Icon!")
        SetTimer(ShowInfo, 50)
        return
    }
    res := GetRes(0)
    imgPath := GetRootDir() "\assets\" res.str "\資料匯出.png"
    
    coords := GetResCoords("ExportButton", 0, 0, res.str)
    info := Format("視窗 HWND: {1} (尺寸: {2}x{3})`n圖檔路徑: {4}`n`n設定檔備援座標: ({5}, {6})`n`n【圖像比對測試】`n", hwnd, cw, ch, imgPath, coords.x, coords.y)
    
    oldPixel := CoordMode("Pixel", "Client")
    found := false
    for v in [30, 45, 60, 80] {
        if ImageSearch(&fx, &fy, 0, 0, cw, ch, Format("*{1} {2}", v, imgPath)) {
            GetImgSize(imgPath, &imgW, &imgH)
            targetX := fx + (imgW // 2)
            targetY := fy + (imgH // 2)
            info .= Format("★ 容許度 {1}：成功匹配！中心座標: ({2}, {3}) (左上: {4}, {5})`n", v, targetX, targetY, fx, fy)
            found := true
            break
        } else {
            info .= Format("- 容許度 {1}：未比對到`n", v)
        }
    }
    CoordMode("Pixel", oldPixel)
    
    MsgBox(info, "資料匯出比對診斷", found ? "Iconi" : "Icon!")
    SetTimer(ShowInfo, 50)
}

Enter:: {
    winTitle := GetPopRankWinTitle()
    hwnd := FindMitakeWin(winTitle)
    if !hwnd {
        MsgBox("未找到「熱門排行」視窗", "偵錯", "Icon!")
        return
    }
    SetTimer(ShowInfo, 0)
    ToolTip()
    
    res := GetRes(0)
    ok := ClickExportBtn(winTitle, res)
    
    oldMouse := CoordMode("Mouse", "Client")
    MouseMove(10, 10, 0)
    CoordMode("Mouse", oldMouse)
    
    MsgBox(Format("點擊結果：{1}`n請檢查日誌 logs\app.log 獲取詳細資訊。", ok ? "已成功觸發" : "失敗"), "點擊測試", ok ? "Iconi" : "Icon!")
    SetTimer(ShowInfo, 50)
}

$Esc:: ExitApp()
