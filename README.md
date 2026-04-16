## アプリのリンク
https://cocomakers-sound-classify-app.web.app
(※ スマホのwebでは地図が表示されないことがあります。ご了承ください。)

## 使う skill
- Google Maps APIキー / `.env` / CORS / ローカル web 起動: `sound-map-web-setup`

## Skills を用いた対話型セットアップと実行
> [!TIP]
> Codex を使用している場合は、'$sound-map-web-setup' コマンドで対話的にセットアップを実行できます。

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
