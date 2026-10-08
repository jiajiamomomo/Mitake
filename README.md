# Mitake 三竹股市自動化

使用 AutoHotkey v2 操作「三竹股市電腦版」，自動開啟／切換視窗，並批次匯出「熱門排行」與「盤後排行」CSV。

## 環境需求

- Windows 11
- AutoHotkey v2：`C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`
- 三竹股市電腦版：預設 `D:\Program Files\MitakeGU\三竹股市.exe`
- 主顯示器解析度必須為 `1920x1080` 或 `2560x1440`

## 快速開始

1. 確認 [config/settings.ini](config/settings.ini) 中的程式路徑、匯出目錄與解析度座標。
2. 執行 `Mitake.ahk`。
3. 由系統托盤選擇「匯出熱門排行」或「匯出盤後排行」。
4. 匯出執行期間可按 `Esc` 要求安全中止；同一時間只允許一個匯出作業。
5. 結果會寫入 `熱門排行\YYYYMMDD\` 或 `盤後排行\YYYYMMDD\`，執行紀錄位於 `logs\app.log`。

批次開始前，腳本會暫存三竹 `USER\OUT` 中既有的 CSV，避免三竹因同名檔已存在而拒絕重新輸出。未被本次輸出取代的檔案會在結束時恢復；同名舊版會保留在 `logs\out-backups\` 供復原。

> 執行期間請勿操作三竹視窗、滑鼠或鍵盤。腳本不執行下單，但會實際控制桌面與點擊三竹介面。

## 測試

```powershell
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$p = Start-Process -FilePath "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" `
  -ArgumentList '/ErrorStdOut', 'tests\run_tests.ahk' `
  -NoNewWindow -PassThru -Wait
exit $p.ExitCode
```

`tests/run_tests.ahk` 僅執行無頭單元測試，不會點擊真實桌面。需要實機驗證時，另行執行：

- `tests/test_pop_rank_export.ahk`
- `tests/test_after_rank_export.ahk`
- `tests/test_coords_click.ahk`
- `tests/diagnose_export_btn.ahk`

## 後續工作

- [ ] 匯出每個新 CSV 後，安全關閉本批次由三竹新開啟的 Excel；不得關閉使用者原本已開啟的 Excel。詳見 [TODO.md](TODO.md)。

## 文件

- [熱門排行匯出規格](pop_rank_export_spec.md)
- [盤後排行匯出規格](After%20Rank%20Export%20Spec.md)
- [實機驗證 Lessons Learned](LESSONS_LEARNED.md)
- [後續工作](TODO.md)
- [命名縮寫表](ABBREVIATIONS.md)
- [開發與自動化注意事項](agents.md)
