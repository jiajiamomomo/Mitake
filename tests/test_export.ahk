#Requires AutoHotkey v2.0
#Include ..\lib\utils.ahk
#Include ..\lib\window_control.ahk
#Include ..\lib\export.ahk
#Include helpers\assert.ahk

/**
 * 建立乾淨的暫存測試目錄
 * @param {String} name 子目錄名稱
 * @returns {String} 目錄完整路徑
 */
NewTmpDir(name) {
    dir := A_Temp "\mitake_test_" name
    if DirExist(dir)
        DirDelete(dir, true)
    DirCreate(dir)
    return dir
}

/**
 * 建立測試檔案並設定修改時間
 * @param {String} path 檔案路徑
 * @param {String} mtime 修改時間 (YYYYMMDDHH24MISS)，空字串代表現在
 */
MakeFile(path, mtime := "", content := "a,b`n1,2`n") {
    FileAppend(content, path, "UTF-8")
    if (mtime != "")
        FileSetTime(mtime, path, "M")
}

Test_GetPopRankTotalItems() {
    n := GetPopRankTotalItems()
    expected := Integer(GetCfg("PopularRanking", "TotalItems", "44"))
    Assert.AssertEquals(expected, n, "GetPopRankTotalItems should read TotalItems from settings.ini")
    Assert.AssertTrue(IsInteger(n) && n > 0, "GetPopRankTotalItems should return a positive integer")
}

Test_GetExportOutDir() {
    expected := GetCfg("PopularRanking", "OutDir", "D:\Program Files\MitakeGU\USER\OUT")
    Assert.AssertEquals(expected, GetExportOutDir("PopularRanking"), "GetExportOutDir should read OutDir from settings.ini")
    Assert.AssertTrue(GetExportOutDir("NonExistentSection") != "", "GetExportOutDir should fall back to default path")
}

Test_GetPopRankDstRoot() {
    Assert.AssertEquals(GetRootDir() "\熱門排行", GetPopRankDstRoot(), "Destination root should be <project>\熱門排行")
}

Test_FindNewCsv() {
    dir := NewTmpDir("find")
    since := A_Now
    since := DateAdd(since, -60, "Seconds")
    since := FormatTime(since, "yyyyMMddHHmmss")

    MakeFile(dir "\20200101_old.csv", "20200101120000")
    MakeFile(dir "\new.txt")
    Assert.AssertEquals("", FindNewCsv(dir, since), "FindNewCsv should ignore old CSV and non-CSV files")

    MakeFile(dir "\熱門排行_成交量.csv")
    Assert.AssertEquals(dir "\熱門排行_成交量.csv", FindNewCsv(dir, since), "FindNewCsv should return CSV newer than sinceTime")

    future := FormatTime(DateAdd(A_Now, 1, "Days"), "yyyyMMddHHmmss")
    Assert.AssertEquals("", FindNewCsv(dir, future), "FindNewCsv should return empty when no CSV is newer")

    Assert.AssertEquals("", FindNewCsv(dir "\nope", since), "FindNewCsv should return empty for missing directory")
    DirDelete(dir, true)
}

Test_FindNewCsv_Newest() {
    dir := NewTmpDir("newest")
    since := FormatTime(DateAdd(A_Now, -10, "Minutes"), "yyyyMMddHHmmss")
    t1 := FormatTime(DateAdd(A_Now, -5, "Minutes"), "yyyyMMddHHmmss")
    t2 := FormatTime(DateAdd(A_Now, -1, "Minutes"), "yyyyMMddHHmmss")
    MakeFile(dir "\a.csv", t1)
    MakeFile(dir "\b.csv", t2)
    Assert.AssertEquals(dir "\b.csv", FindNewCsv(dir, since), "FindNewCsv should return the most recently modified CSV")
    DirDelete(dir, true)
}

Test_WaitNewCsv_Timeout() {
    dir := NewTmpDir("wait")
    future := FormatTime(DateAdd(A_Now, 1, "Days"), "yyyyMMddHHmmss")
    t0 := A_TickCount
    Assert.AssertEquals("", WaitNewCsv(dir, future, 300, 50), "WaitNewCsv should return empty on timeout")
    Assert.AssertTrue(A_TickCount - t0 < 2000, "WaitNewCsv should respect timeout")

    since := FormatTime(DateAdd(A_Now, -60, "Seconds"), "yyyyMMddHHmmss")
    MakeFile(dir "\x.csv")
    Assert.AssertEquals(dir "\x.csv", WaitNewCsv(dir, since, 1000, 50), "WaitNewCsv should return existing new CSV")
    DirDelete(dir, true)
}

Test_CopyToDateDir() {
    srcDir := NewTmpDir("src")
    dstRoot := NewTmpDir("dst")
    src := srcDir "\熱門排行_成交量.csv"
    MakeFile(src, "", "v1")

    dst := CopyToDateDir(src, dstRoot, "20261007")
    Assert.AssertEquals(dstRoot "\20261007\熱門排行_成交量.csv", dst, "CopyToDateDir should return destination path")
    Assert.AssertTrue(FileExist(dst), "CopyToDateDir should create date folder and copy file")
    Assert.AssertTrue(FileExist(src), "CopyToDateDir should keep the source file")

    FileDelete(src)
    MakeFile(src, "", "v2")
    CopyToDateDir(src, dstRoot, "20261007")
    Assert.AssertEquals("v2", FileRead(dst, "UTF-8"), "CopyToDateDir should overwrite same-name file")

    Assert.AssertEquals("", CopyToDateDir(srcDir "\missing.csv", dstRoot, "20261007"), "CopyToDateDir should return empty for missing source")
    DirDelete(srcDir, true)
    DirDelete(dstRoot, true)
}

Test_HasResAssets() {
    names := ["熱門下拉.png", "資料匯出.png"]
    Assert.AssertTrue(HasResAssets(names, "1920x1080"), "1920x1080 export assets should exist")
    Assert.AssertTrue(HasResAssets(names, "2560x1440"), "2560x1440 export assets should exist")
    Assert.AssertTrue(!HasResAssets(names, "3840x2160"), "3840x2160 export assets should be reported missing")
    Assert.AssertTrue(!HasResAssets(["不存在.png"], "1920x1080"), "Missing asset should be reported")
}

Test_ExportBtnCoords() {
    c := GetResCoords("ExportButton", 0, 0, "1920x1080")
    Assert.AssertEquals(1777, c.x, "ExportButton 1920x1080 ClickX should be 1777")
    Assert.AssertEquals(50, c.y, "ExportButton 1920x1080 ClickY should be 50")
    c2 := GetResCoords("ExportButton", 0, 0, "2560x1440")
    Assert.AssertTrue(c2.x == 0 && c2.y == 0, "ExportButton 2560x1440 should be unconfigured (0,0) to avoid blind clicks")
}

Test_GetAfterRankTotalItems() {
    l := GetAfterRankTotalItemsL()
    Assert.AssertEquals(5, l, "GetAfterRankTotalItemsL should read TotalItemsL (5) from settings.ini")

    expectedR := [10, 10, 4, 8, 4]
    Loop expectedR.Length {
        r := GetAfterRankTotalItemsR(A_Index)
        Assert.AssertEquals(expectedR[A_Index], r, Format("GetAfterRankTotalItemsR({1}) should return {2}", A_Index, expectedR[A_Index]))
    }
}

Test_GetAfterRankDstRoot() {
    Assert.AssertEquals(GetRootDir() "\盤後排行", GetAfterRankDstRoot(), "Destination root should be <project>\盤後排行")
}

Test_AfterRankAssets() {
    assets := AfterRankAssets()
    Assert.AssertEquals(3, assets.Length, "AfterRankAssets should have 3 items")
    Assert.AssertEquals("盤後下拉L.png", assets[1], "First asset should be 盤後下拉L.png")
    Assert.AssertEquals("盤後下拉R.png", assets[2], "Second asset should be 盤後下拉R.png")
    Assert.AssertEquals("資料匯出.png", assets[3], "Third asset should be 資料匯出.png")
    Assert.AssertTrue(HasResAssets(assets, "1920x1080"), "1920x1080 should have all AfterRankAssets")
    Assert.AssertTrue(HasResAssets(assets, "2560x1440"), "2560x1440 should have all AfterRankAssets")
    Assert.AssertTrue(!HasResAssets(assets, "3840x2160"), "3840x2160 should report missing AfterRankAssets")
}

RunExportTests() {
    FileAppend("Running Export Tests...`n", "*")
    Test_GetPopRankTotalItems()
    Test_GetExportOutDir()
    Test_GetPopRankDstRoot()
    Test_FindNewCsv()
    Test_FindNewCsv_Newest()
    Test_WaitNewCsv_Timeout()
    Test_CopyToDateDir()
    Test_HasResAssets()
    Test_ExportBtnCoords()
    Test_GetAfterRankTotalItems()
    Test_GetAfterRankDstRoot()
    Test_AfterRankAssets()
}

