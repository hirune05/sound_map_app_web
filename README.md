## 実行方法
Google Maps APIキーは `.env` に入れて `--dart-define-from-file` で渡します。
1. `.env.example` をコピーして `.env` を作成
2. `.env` の `YOURAPIKEY` にAPIキーを入れる
3. 起動
```
flutter run -d chrome --dart-define-from-file=.env
```

Firebase Hosting にデプロイする場合も同じ `--dart-define` を付けてビルドします。
```
flutter build web --release --dart-define-from-file=.env
firebase deploy --only hosting
```

アプリが起動するのでログインまたは新規登録してください。
googleMapへのアクセス要求画面が出てきたら成功です！
