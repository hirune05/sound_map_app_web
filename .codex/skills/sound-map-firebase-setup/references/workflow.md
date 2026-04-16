# Workflow

## 1. Firebase project を確認する

- project は `cocomakers-sound-classify-app`
- [`firebase.json`](/Users/tajimamiho/dev/sound_map_app_web/firebase.json) は Hosting を `build/web` に向けている
- [`lib/firebase_options.dart`](/Users/tajimamiho/dev/sound_map_app_web/lib/firebase_options.dart) は初期化設定を持っている

## 2. Hosting をビルドする

```bash
flutter build web --release --dart-define-from-file=.env
firebase deploy --only hosting
```

## 3. Storage の CORS を設定する

- `cors.json` は Firebase Storage 用
- バケットは `cocomakers-sound-classify-app.appspot.com`
- 設定例:

```bash
gsutil cors set cors.json gs://cocomakers-sound-classify-app.appspot.com
gsutil cors get gs://cocomakers-sound-classify-app.appspot.com
```

## 4. うまくいかない時

- web だけ Storage が失敗するときは CORS を再設定する
- `firebase deploy` 前に `flutter build web` が通るか確認する
- Firebase 初期化で失敗するときは `firebase_options.dart` の project が一致しているか確認する
