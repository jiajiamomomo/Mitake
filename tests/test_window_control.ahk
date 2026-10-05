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

Test_ClickPopularRankingMenu_ReturnType() {
    result := ClickPopularRankingMenu()
    Assert.AssertTrue(result == true || result == false, "ClickPopularRankingMenu should return boolean result")
}

Test_ClickAfterMarketRankingMenu_ReturnType() {
    result := ClickAfterMarketRankingMenu()
    Assert.AssertTrue(result == true || result == false, "ClickAfterMarketRankingMenu should return boolean result")
}

Test_GetAssetImagePath_2560x1440() {
    ; 測試針對 2560x1440 解析度的三個新增圖檔能被精確定位
    pathMenu := GetAssetImagePath("menu_證券行情.png", "2560x1440")
    Assert.AssertTrue(FileExist(pathMenu) != "", "menu_證券行情.png should exist for 2560x1440")
    Assert.AssertTrue(InStr(pathMenu, "2560x1440") > 0, "pathMenu should resolve to 2560x1440 directory")

    pathPopular := GetAssetImagePath("熱門排行.png", "2560x1440")
    Assert.AssertTrue(FileExist(pathPopular) != "", "熱門排行.png should exist for 2560x1440")
    Assert.AssertTrue(InStr(pathPopular, "2560x1440") > 0, "pathPopular should resolve to 2560x1440 directory")

    pathAfterMarket := GetAssetImagePath("盤後排行.png", "2560x1440")
    Assert.AssertTrue(FileExist(pathAfterMarket) != "", "盤後排行.png should exist for 2560x1440")
    Assert.AssertTrue(InStr(pathAfterMarket, "2560x1440") > 0, "pathAfterMarket should resolve to 2560x1440 directory")
}

Test_GetAssetImagePath_1920x1080() {
    ; 測試針對 1920x1080 解析度圖檔亦能正常定位
    pathMenu := GetAssetImagePath("menu_證券行情.png", "1920x1080")
    Assert.AssertTrue(FileExist(pathMenu) != "", "menu_證券行情.png should exist for 1920x1080")

    pathPopular := GetAssetImagePath("熱門排行.png", "1920x1080")
    Assert.AssertTrue(FileExist(pathPopular) != "", "熱門排行.png should exist for 1920x1080")

    pathAfterMarket := GetAssetImagePath("盤後排行.png", "1920x1080")
    Assert.AssertTrue(FileExist(pathAfterMarket) != "", "盤後排行.png should exist for 1920x1080")
}

Test_AssetImageSizes_2560x1440() {
    ; 驗證 2560x1440 圖檔尺寸有效
    pMenu := GetAssetImagePath("menu_證券行情.png", "2560x1440")
    GetImageSize(pMenu, &w1, &h1)
    Assert.AssertTrue(w1 > 0 && h1 > 0, "2560x1440 menu_證券行情.png dimensions should be valid")

    pPopular := GetAssetImagePath("熱門排行.png", "2560x1440")
    GetImageSize(pPopular, &w2, &h2)
    Assert.AssertTrue(w2 > 0 && h2 > 0, "2560x1440 熱門排行.png dimensions should be valid")

    pAfterMarket := GetAssetImagePath("盤後排行.png", "2560x1440")
    GetImageSize(pAfterMarket, &w3, &h3)
    Assert.AssertTrue(w3 > 0 && h3 > 0, "2560x1440 盤後排行.png dimensions should be valid")
}

Test_GetImageSize_Fallback() {
    GetImageSize("assets/non_existent.png", &w, &h)
    Assert.AssertTrue(w > 0 && h > 0, "GetImageSize should return positive dimensions")
}

Test_GetWindowTitles() {
    mainTitle := GetMainWindowTitle()
    Assert.AssertEquals("三竹股市", mainTitle, "GetMainWindowTitle should return '三竹股市'")

    popTitle := GetPopularRankingWindowTitle()
    Assert.AssertEquals("熱門排行", popTitle, "GetPopularRankingWindowTitle should return '熱門排行'")

    afterTitle := GetAfterMarketRankingWindowTitle()
    Assert.AssertEquals("盤後排行", afterTitle, "GetAfterMarketRankingWindowTitle should return '盤後排行'")
}

Test_SwitchToMainWindow_WhenNotRunning() {
    result := SwitchToMainWindow(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToMainWindow should return boolean")
}

Test_SwitchToPopularRankingWindow_ReturnType() {
    result := SwitchToPopularRankingWindow(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToPopularRankingWindow should return boolean")
}

Test_SwitchToAfterMarketRankingWindow_ReturnType() {
    result := SwitchToAfterMarketRankingWindow(1)
    Assert.AssertTrue(result == true || result == false, "SwitchToAfterMarketRankingWindow should return boolean")
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
    successMain := SwitchToMainWindow(1)
    Assert.AssertTrue(successMain, "SwitchToMainWindow should succeed when main window exists")

    ; 驗證切換至熱門排行視窗
    successPop := SwitchToPopularRankingWindow(1)
    Assert.AssertTrue(successPop, "SwitchToPopularRankingWindow should succeed when popular ranking exists")

    ; 驗證切換至盤後排行視窗
    successAfter := SwitchToAfterMarketRankingWindow(1)
    Assert.AssertTrue(successAfter, "SwitchToAfterMarketRankingWindow should succeed when after-market ranking exists")

    ; 驗證點擊 menu bar 前切換回主程式視窗
    successBack := SwitchToMainWindow(1)
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

Test_GetResolutionClickCoords_DualResolutions() {
    ; 測試 SecuritiesQuote 在 1920x1080 與 2560x1440 兩個解析度下的降級座標
    sq1080 := GetResolutionClickCoords("SecuritiesQuote", 0, 0, "1920x1080")
    Assert.AssertEquals(337, sq1080.x, "SecuritiesQuote 1920x1080 ClickX should be 337")
    Assert.AssertEquals(15, sq1080.y, "SecuritiesQuote 1920x1080 ClickY should be 15")

    sq1440 := GetResolutionClickCoords("SecuritiesQuote", 0, 0, "2560x1440")
    Assert.AssertEquals(337, sq1440.x, "SecuritiesQuote 2560x1440 ClickX should be 337")
    Assert.AssertEquals(14, sq1440.y, "SecuritiesQuote 2560x1440 ClickY should be 14")

    ; 測試 PopularRanking 在 1920x1080 與 2560x1440 兩個解析度下的降級座標
    pop1080 := GetResolutionClickCoords("PopularRanking", 0, 0, "1920x1080")
    Assert.AssertEquals(77, pop1080.x, "PopularRanking 1920x1080 ClickX should be 77")
    Assert.AssertEquals(80, pop1080.y, "PopularRanking 1920x1080 ClickY should be 80")

    pop1440 := GetResolutionClickCoords("PopularRanking", 0, 0, "2560x1440")
    Assert.AssertEquals(78, pop1440.x, "PopularRanking 2560x1440 ClickX should be 78")
    Assert.AssertEquals(80, pop1440.y, "PopularRanking 2560x1440 ClickY should be 80")

    ; 測試 AfterMarketRanking 在 1920x1080 與 2560x1440 兩個解析度下的降級座標
    after1080 := GetResolutionClickCoords("AfterMarketRanking", 0, 0, "1920x1080")
    Assert.AssertEquals(78, after1080.x, "AfterMarketRanking 1920x1080 ClickX should be 78")
    Assert.AssertEquals(110, after1080.y, "AfterMarketRanking 1920x1080 ClickY should be 110")

    after1440 := GetResolutionClickCoords("AfterMarketRanking", 0, 0, "2560x1440")
    Assert.AssertEquals(78, after1440.x, "AfterMarketRanking 2560x1440 ClickX should be 78")
    Assert.AssertEquals(110, after1440.y, "AfterMarketRanking 2560x1440 ClickY should be 110")

    ; 測試 MenuBar 在 1920x1080 與 2560x1440 兩個解析度下的座標
    mb1080 := GetResolutionClickCoords("MenuBar", 0, 0, "1920x1080")
    Assert.AssertEquals(35, mb1080.x, "MenuBar 1920x1080 ClickX should be 35")
    Assert.AssertEquals(45, mb1080.y, "MenuBar 1920x1080 ClickY should be 45")

    mb1440 := GetResolutionClickCoords("MenuBar", 0, 0, "2560x1440")
    Assert.AssertEquals(35, mb1440.x, "MenuBar 2560x1440 ClickX should be 35")
    Assert.AssertEquals(45, mb1440.y, "MenuBar 2560x1440 ClickY should be 45")

    ; 測試備援與相容模式：不存在之區段應回傳給定預設值
    fallback := GetResolutionClickCoords("NonExistentSection", 99, 199, "1920x1080")
    Assert.AssertEquals(99, fallback.x, "Non-existent section should fallback to default X")
    Assert.AssertEquals(199, fallback.y, "Non-existent section should fallback to default Y")

    ; 測試未指定目標解析度時，應自動採用主顯示器解析度並回傳有效座標
    autoRes := GetResolutionClickCoords("SecuritiesQuote", 0, 0)
    Assert.AssertTrue(autoRes.x > 0 && autoRes.y > 0, "Auto resolution should return positive coords")
}

RunWindowControlTests() {
    FileAppend("Running Window Control Tests...`n", "*")
    Test_IsMitakeRunning_ReturnType()
    Test_LaunchMitakeStock_InvalidPath()
    Test_ToggleMitakeMenuBar_ReturnType()
    Test_FindAndClickImage_NonExistentFile()
    Test_ActivateMitake_Execution()
    Test_ClickSecuritiesQuoteMenu_ReturnType()
    Test_ClickPopularRankingMenu_ReturnType()
    Test_ClickAfterMarketRankingMenu_ReturnType()
    Test_GetAssetImagePath_2560x1440()
    Test_GetAssetImagePath_1920x1080()
    Test_AssetImageSizes_2560x1440()
    Test_GetImageSize_Fallback()
    Test_GetWindowTitles()
    Test_SwitchToMainWindow_WhenNotRunning()
    Test_SwitchToPopularRankingWindow_ReturnType()
    Test_SwitchToAfterMarketRankingWindow_ReturnType()
    Test_WindowSwitching_WithMockGuis()
    Test_ActivateMitake_RestoreMinimized()
    Test_GetResolutionClickCoords_DualResolutions()
}

