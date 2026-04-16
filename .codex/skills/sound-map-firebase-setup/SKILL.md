---
name: sound-map-firebase-setup
description: sound_map_app_web の Firebase 初期設定、Hosting デプロイ、Storage CORS を案内する。
---

# sound-map-firebase-setup

`sound_map_app_web` の Firebase 周りを支援する skill です。

## 使う場面

- Firebase Hosting にデプロイする
- Firebase Storage を web から使う
- CORS を再設定する
- Firebase 認証や初期化まわりを確認する

## 進め方

1. まず `references/workflow.md` を前提手順として使う
2. `firebase.json` と `lib/firebase_options.dart` が現在の project に合っているか確認する
3. 失敗したら Firebase Hosting / Storage / Auth のどこで止まっているか切り分ける

## 参照

- `references/workflow.md`
- `cors.json`
- `firebase.json`
- `.firebaserc`
- `lib/firebase_options.dart`
