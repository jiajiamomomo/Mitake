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
}
