# Workflow

## 1. Google Maps API キーを作る

- Google Cloud Console で `cocomakers-sound-classify-app` を開く
- `APIs & Services` で `Maps JavaScript API` を有効化する
- `Credentials` で API key を作成する
- web 用なので `HTTP referrers` 制限を付ける
- 例:
  - `http://localhost:*`
  - `https://cocomakers-sound-classify-app.web.app/*`
  - `https://cocomakers-sound-classify-app.firebaseapp.com/*`

## 2. `.env` を作る

```bash
cp .env.example .env
```

- `.env` の `YOURAPIKEY` に API key を入れる
- `lib/env/env.dart` は `String.fromEnvironment('YOURAPIKEY')` を読む

## 3. ローカルビルド

```bash
flutter pub get
flutter run -d chrome --dart-define-from-file=.env
```

## 4. うまくいかない時

- 地図が白いときは console の `Google Maps JavaScript API` エラーを見る
- API key を変えたら web を再ビルドする
