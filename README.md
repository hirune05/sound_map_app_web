## アプリのリンク
https://cocomakers-sound-classify-app.web.app
(※ スマホのwebでは地図が表示されないことがあります。ご了承ください。)

## Skills を用いた対話型セットアップと実行
> [!TIP]
> Codex または Claude Code を使用している場合は、以下コマンドで対話的にセットアップを実行できます。
> 
> Cocex: `$sound-map-web-setup`
> 
> Claude Code: `/sound-map-web-setup`

## Google Maps セットアップ
1. GCP で Google Maps API キーを作る
2. `.env.example` をコピーして `.env` を作成
3. `.env` の `YOURAPIKEY` にAPIキーを入れる
4. Firebase Storage の CORS を設定する
5. 起動
```
flutter run -d chrome --dart-define-from-file=.env
```

アプリが起動するのでログインまたは新規登録してください。
googleMapへのアクセス要求画面が出てきたら成功です！
