---
name: sound-map-web-setup
description: sound_map_app_web の Google Maps API キー取得、.env 設定、CORS 設定、Flutter web のローカル起動を案内する。
---

# sound-map-web-setup

`sound_map_app_web` の Google Maps 初期設定、Storage CORS、web 起動を支援する skill です。

## 使う場面

- GCP で Google Maps API キーを作る
- `.env` に API キーを入れる
- Firebase Storage の CORS を設定する
- `flutter run` / `flutter build web` を通す

## 進め方

1. まず `references/workflow.md` を前提手順として使う
2. `YOURAPIKEY` を本物の API key に差し替える
3. CORS は `cors.json` を使って Firebase Storage に再設定する
4. 失敗したらコンソールの `Google Maps JavaScript API` 系エラーを確認する

## 参照

- `references/workflow.md`
- `.env.example`
- `lib/env/env.dart`
- `cors.json`
