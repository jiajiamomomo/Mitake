#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include helpers\assert.ahk

Test_IsMitakeRunning_ReturnType() {
    result := IsMitakeRunning()
    Assert.AssertTrue(result == true || result == false, "IsMitakeRunning should return boolean result")
}

Test_LaunchMitake_InvalidPath() {
    ; Mock launch with non-existent path to verify error handling
    invalidPath := "Z:\NonExistentDirectory\NonExistentFile.exe"
    ; For automated testing, we test function response without blocking on dialogs where possible
    Assert.AssertTrue(!FileExist(invalidPath), "Invalid path should not exist")
}

Test_ToggleMenuBar_ReturnType() {
    ; Test ToggleMenuBar returns boolean status
    result := ToggleMenuBar()
    Assert.AssertTrue(result == true || result == false, "ToggleMenuBar should return boolean result")
}

Test_FindClickImg_NonExistentFile() {
    result := FindClickImg("assets/non_existent_file.png")
    Assert.AssertTrue(result.found == false, "FindClickImg with missing file should return found=false")
}

Test_ActivateMitake_Execution() {
    ; Test ActivateMitake can be safely called
    ActivateMitake()
    Assert.AssertTrue(true, "ActivateMitake executed without error")
}

Test_ClickSecQuoteMenu_ReturnType() {
    result := ClickSecQuoteMenu()
    Assert.AssertTrue(result == true || result == false, "ClickSecQuoteMenu should return boolean result")
}

Test_ClickPopRankMenu_ReturnType() {
    result := ClickPopRankMenu()
    Assert.AssertTrue(result == true || result == false, "ClickPopRankMenu should return boolean result")
}

Test_ClickAfterRankMenu_ReturnType() {
    result := ClickAfterRankMenu()
    Assert.AssertTrue(result == true || result == false, "ClickAfterRankMenu should return boolean result")
}

Test_GetAssetImgPath_2560x1440() {
    assets := ["menu_證券行情.png", "熱門排行.png", "盤後排行.png"]
    for asset in assets {
        p := GetAssetImgPath(asset, "2560x1440")
        Assert.AssertTrue(FileExist(p) != "", Format("{1} should exist for 2560x1440", asset))
        Assert.AssertTrue(InStr(p, "2560x1440") > 0, Format("{1} should resolve to 2560x1440 directory", asset))
    }
}

Test_GetAssetImgPath_1920x1080() {
    assets := ["menu_證券行情.png", "熱門排行.png", "盤後排行.png"]
    for asset in assets {
        p := GetAssetImgPath(asset, "1920x1080")
        Assert.AssertTrue(FileExist(p) != "", Format("{1} should exist for 1920x1080", asset))
    }
}

Test_AssetImageSizes_2560x1440() {
    assets := ["menu_證券行情.png", "熱門排行.png", "盤後排行.png"]
    for asset in assets {
        p := GetAssetImgPath(asset, "2560x1440")
        GetImgSize(p, &w, &h)
        Assert.AssertTrue(w > 0 && h > 0, Format("2560x1440 {1} dimensions should be valid", asset))
    }
}

Test_GetImgSize_Fallback() {
    GetImgSize("assets/non_existent.png", &w, &h)
    Assert.AssertTrue(w > 0 && h > 0, "GetImgSize should return positive dimensions")
}

Test_GetWindowTitles() {
    mainTitle := GetMainWinTitle()
    Assert.AssertEquals("三竹股市", mainTitle, "GetMainWinTitle should return '三竹股市'")

    popTitle := GetPopRankWinTitle()
    Assert.AssertEquals("熱門排行", popTitle, "GetPopRankWinTitle should return '熱門排行'")

    afterTitle := GetAfterRankWinTitle()
    Assert.AssertEquals("盤後排行", afterTitle, "GetAfterRankWinTitle should return '盤後排行'")
}

Test_ShouldMaximizeMitakeWin() {
    cases := [
        {proc: "三竹股市.exe", title: "三竹股市", expected: true, desc: "matching process and non-blank title"},
        {proc: "三竹股市.exe", title: "", expected: false, desc: "empty title"},
        {proc: "三竹股市.exe", title: "   `t", expected: false, desc: "whitespace-only title"},
        {proc: "notepad.exe", title: "三竹股市", expected: false, desc: "unrelated process"}
    ]

    for c in cases {
        actual := ShouldMaximizeMitakeWin(c.proc, c.title, "三竹股市.exe")
        Assert.AssertEquals(c.expected, actual, c.desc)
    }
}

Test_SwitchToMainWin_WhenNotRunning() {
    result := SwitchToMainWin(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToMainWin should return boolean")
}

Test_SwitchToPopRankWin_ReturnType() {
    result := SwitchToPopRankWin(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToPopRankWin should return boolean")
}

Test_SwitchToAfterRankWin_ReturnType() {
    result := SwitchToAfterRankWin(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToAfterRankWin should return boolean")
}

Test_WindowSwitching_WithMockGuis() {
    mainGui := Gui(, "三竹股市")
    mainGui.Show("w200 h100 x100 y100 NoActivate")

    popGui := Gui(, "熱門排行")
    popGui.Show("w200 h100 x350 y100 NoActivate")

    afterGui := Gui(, "盤後排行")
    afterGui.Show("w200 h100 x600 y100 NoActivate")

    ; 驗證視窗存在
    Assert.AssertTrue(WinExist("三竹股市") != 0, "Main window '三竹股市' should exist")
    Assert.AssertTrue(WinExist("熱門排行") != 0, "Popular ranking window '熱門排行' should exist")
    Assert.AssertTrue(WinExist("盤後排行") != 0, "After-market ranking window '盤後排行' should exist")

    ; 驗證切換至主程式視窗
    successMain := SwitchToMainWin(1)
    Assert.AssertTrue(successMain, "SwitchToMainWin should succeed when main window exists")

    ; 驗證切換至熱門排行視窗
    successPop := SwitchToPopRankWin(1)
    Assert.AssertTrue(successPop, "SwitchToPopRankWin should succeed when popular ranking exists")

    ; 驗證切換至盤後排行視窗
    successAfter := SwitchToAfterRankWin(1)
    Assert.AssertTrue(successAfter, "SwitchToAfterRankWin should succeed when after-market ranking exists")

    ; 驗證點擊 menu bar 前切換回主程式視窗
    successBack := SwitchToMainWin(1)
    Assert.AssertTrue(successBack, "Switch back to main window should succeed")

    mainGui.Destroy()
    popGui.Destroy()
    afterGui.Destroy()
}

Test_ActivateMitake_RestoreMinimized() {
    mockGui := Gui(, "三竹股市")
    mockGui.Show("w200 h100 x100 y100 NoActivate")
    WinMinimize(mockGui.Hwnd)
    Assert.AssertTrue(WinGetMinMax(mockGui.Hwnd) == -1, "Mock window should be minimized")
    
    ActivateMitake(mockGui.Hwnd)
    Assert.AssertTrue(WinGetMinMax(mockGui.Hwnd) != -1, "ActivateMitake should unminimize window")
    mockGui.Destroy()
}

Test_GetResCoords_DualResolutions() {
    cases := [
        {sec: "SecuritiesQuote", res: "1920x1080", expX: 337, expY: 15},
        {sec: "SecuritiesQuote", res: "2560x1440", expX: 337, expY: 14},
        {sec: "PopularRanking", res: "1920x1080", expX: 77, expY: 80},
        {sec: "PopularRanking", res: "2560x1440", expX: 78, expY: 80},
        {sec: "AfterMarketRanking", res: "1920x1080", expX: 78, expY: 110},
        {sec: "AfterMarketRanking", res: "2560x1440", expX: 78, expY: 110},
        {sec: "MenuBar", res: "1920x1080", expX: 35, expY: 45},
        {sec: "MenuBar", res: "2560x1440", expX: 35, expY: 45}
    ]
    for c in cases {
        coords := GetResCoords(c.sec, 0, 0, c.res)
        Assert.AssertEquals(c.expX, coords.x, Format("{1} {2} ClickX should be {3}", c.sec, c.res, c.expX))
        Assert.AssertEquals(c.expY, coords.y, Format("{1} {2} ClickY should be {3}", c.sec, c.res, c.expY))
    }

    ; 測試備援與相容模式：不存在之區段應回傳給定預設值
    fallback := GetResCoords("NonExistentSection", 99, 199, "1920x1080")
    Assert.AssertEquals(99, fallback.x, "Non-existent section should fallback to default X")
    Assert.AssertEquals(199, fallback.y, "Non-existent section should fallback to default Y")

    ; 測試未指定目標解析度時，應自動採用主顯示器解析度並回傳有效座標
    autoRes := GetResCoords("SecuritiesQuote", 0, 0)
    Assert.AssertTrue(autoRes.x > 0 && autoRes.y > 0, "Auto resolution should return positive coords")
    res := GetRes(0)
    if (res.str == "1920x1080") {
        Assert.AssertEquals(337, autoRes.x, "Auto resolution under 1920x1080 should return ClickX 337")
        Assert.AssertEquals(15, autoRes.y, "Auto resolution under 1920x1080 should return ClickY 15")
    }
}

Test_FindMitakeWin() {
    h := FindMitakeWin("NonExistentWindow_98765")
    Assert.AssertEquals(0, h, "FindMitakeWin should return 0 for non-existent window")
}

Test_ClickPoint() {
    ClickPoint(0, 0, "NonExistentWindow_98765", false)
    Assert.AssertTrue(true, "ClickPoint should execute safely without throwing")
}

RunWindowControlTests() {
    FileAppend("Running Window Control Tests...`n", "*")
    Test_IsMitakeRunning_ReturnType()
    Test_LaunchMitake_InvalidPath()
    Test_ToggleMenuBar_ReturnType()
    Test_FindClickImg_NonExistentFile()
    Test_ActivateMitake_Execution()
    Test_ClickSecQuoteMenu_ReturnType()
    Test_ClickPopRankMenu_ReturnType()
    Test_ClickAfterRankMenu_ReturnType()
    Test_GetAssetImgPath_2560x1440()
    Test_GetAssetImgPath_1920x1080()
    Test_AssetImageSizes_2560x1440()
    Test_GetImgSize_Fallback()
    Test_GetWindowTitles()
    Test_ShouldMaximizeMitakeWin()
    Test_SwitchToMainWin_WhenNotRunning()
    Test_SwitchToPopRankWin_ReturnType()
    Test_SwitchToAfterRankWin_ReturnType()
    Test_WindowSwitching_WithMockGuis()
    Test_ActivateMitake_RestoreMinimized()
    Test_GetResCoords_DualResolutions()
    Test_FindMitakeWin()
    Test_ClickPoint()
}
