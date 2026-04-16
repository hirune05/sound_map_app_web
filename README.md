## アプリのリンク
https://cocomakers-sound-classify-app.web.app
(※ スマホのwebでは地図が表示されないことがあります。ご了承ください。)

## 使う skill
- Google Maps APIキー / `.env` / ローカル web 起動: `sound-map-web-setup`
- Firebase Hosting / Storage / CORS: `sound-map-firebase-setup`

## Skills を用いた対話型セットアップと実行
> [!TIP]
> Codex を使用している場合は、それぞれ以下コマンドで対話的にセットアップを実行できます。
- コマンド `$sound-map-web-setup` : Google Maps APIキーの `.env`設定 〜　ローカルでの web 起動
- コマンド `$sound-map-firebase-setup`: Firebase Hosting / Storage / CORS　設定等

## Google Maps セットアップ
1. `.env.example` をコピーして `.env` を作成
2. `.env` の `YOURAPIKEY` にAPIキーを入れる
3. 起動
```
flutter run -d chrome --dart-define-from-file=.env
```

## Firebase セットアップ
Firebase 側の設定が必要なら `sound-map-firebase-setup` を使ってください。
```
flutter build web --release --dart-define-from-file=.env
firebase deploy --only hosting
```

アプリが起動するのでログインまたは新規登録してください。
googleMapへのアクセス要求画面が出てきたら成功です！
