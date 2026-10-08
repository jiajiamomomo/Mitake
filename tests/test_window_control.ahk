#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include helpers\assert.ahk

Test_IsMitakeRunning_ReturnType() {
    result := IsMitakeRunning()
    Assert.AssertTrue(result == true || result == false, "IsMitakeRunning should return boolean result")
}

Test_FindClickImg_NonExistentFile() {
    result := FindClickImg("assets/non_existent_file.png")
    Assert.AssertTrue(result.found == false, "FindClickImg with missing file should return found=false")
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

Test_GetAssetImgPath_NoCrossResolutionFallback() {
    p := GetAssetImgPath("熱門排行.png", "3840x2160")
    Assert.AssertTrue(!FileExist(p), "Unsupported resolution must not reuse another resolution's asset")
    Assert.AssertTrue(InStr(p, "3840x2160") > 0, "Missing asset path should retain the requested resolution")
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
        {proc: "三竹股市.exe", title: "三竹股市 - 提示", expected: false, desc: "same-process modal title"},
        {proc: "notepad.exe", title: "三竹股市", expected: false, desc: "unrelated process"}
    ]

    for c in cases {
        actual := ShouldMaximizeMitakeWin(c.proc, c.title, "三竹股市.exe")
        Assert.AssertEquals(c.expected, actual, c.desc)
    }
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

    unsupported := GetResCoords("MenuBar", 0, 0, "3840x2160")
    Assert.AssertEquals(0, unsupported.x, "Unsupported resolution must not reuse generic ClickX")
    Assert.AssertEquals(0, unsupported.y, "Unsupported resolution must not reuse generic ClickY")

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

Test_ClickPoint_MissingTargetIsSafe() {
    ok := ClickPoint(10, 10, "NonExistentWindow_98765", false)
    Assert.AssertTrue(!ok, "ClickPoint must reject a missing target without clicking the active window")
}

Test_TrustedForegroundMeta() {
    Assert.AssertTrue(IsTrustedForegroundMeta(100, 100, 10, 10, ""), "Same root-owner popup should be trusted")
    Assert.AssertTrue(IsTrustedForegroundMeta(100, 100, 10, 20, ""), "Untitled same-process transient menu should be trusted")
    Assert.AssertTrue(!IsTrustedForegroundMeta(100, 200, 10, 10, ""), "Different-process foreground must be rejected")
    Assert.AssertTrue(!IsTrustedForegroundMeta(100, 100, 10, 20, "盤後排行"), "Different titled same-process window must be rejected")
}

RunWindowControlTests() {
    FileAppend("Running Window Control Tests...`n", "*")
    Test_IsMitakeRunning_ReturnType()
    Test_FindClickImg_NonExistentFile()
    Test_GetAssetImgPath_2560x1440()
    Test_GetAssetImgPath_1920x1080()
    Test_GetAssetImgPath_NoCrossResolutionFallback()
    Test_AssetImageSizes_2560x1440()
    Test_GetImgSize_Fallback()
    Test_GetWindowTitles()
    Test_ShouldMaximizeMitakeWin()
    Test_GetResCoords_DualResolutions()
    Test_FindMitakeWin()
    Test_ClickPoint_MissingTargetIsSafe()
    Test_TrustedForegroundMeta()
}
