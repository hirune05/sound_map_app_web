---
name: sound-map-web-setup
description: sound_map_app_web を Chrome で起動する。`.env` の有無を確認 → `flutter pub get && flutter run -d chrome --dart-define-from-file=.env` を実行 → 起動後に「正常 / 地図が白い / その他エラー」を聞いて分岐対応する。「セットアップ」「起動したい」「地図が表示されない」といった依頼に使う。
---

# sound-map-web-setup

`sound_map_app_web` をローカル起動する。実行前の最小チェック → まず走らせる → 結果で分岐、という方針。

## メインフロー

### Step 1. 実行前の確認（最小限）

以下だけ確認する。**それ以外は先回りしない**（API キーの referrer 設定・CORS などは、症状が出てから対応で十分）。

- `.env` が存在するか
  - 無ければ: `cp .env.example .env` → `YOURAPIKEY=` の右辺に Google Maps API キーを貼ってもらう
  - キー自体がまだ無ければ `references/workflow.md` の「Google Maps API キーを作る」を案内
  - キー文字列は**ユーザー自身が貼る**。Claude が生成・推測・出力してはいけない
- `flutter` コマンドが使えるか (`flutter --version`)
  - 無ければ Flutter SDK 導入から。`references/workflow.md` の「前提ツール」参照

### Step 2. 起動

```bash
flutter pub get && flutter run -d chrome --dart-define-from-file=.env
```

### Step 3. 結果を聞く

起動後、ユーザーに選んでもらう:

> どうでしたか？
> a. **正常に動いた**（ログイン画面 → 地図が表示される）
> b. **地図が真っ白**
> c. **その他のエラー**（エラー文言を貼ってください）

### Step 4. 分岐

- **a. 正常** → 完了。何も追加提案しない。
- **b. 地図が真っ白** → Chrome devtools の Console のエラー文言を聞き、`references/workflow.md` の「地図が白い」表で原因を特定。
- **c. その他のエラー** → エラー文言から `references/workflow.md` のトラブルシュート表で該当項目を探す。

---

## Optional（ユーザーが明示的に頼んだときだけ）

- **本番 URL の referrer 追加**: `*.web.app` / `*.firebaseapp.com` を GCP Credentials に追加
- **Firebase Storage の CORS 設定**: 音声ファイル取得で CORS エラーが出たとき限定

どちらも**先回りして提案しない**。

---

## 参照

- 詳細手順・トラブルシュート表: `references/workflow.md`
- コード: `lib/env/env.dart`, `.env.example`, `cors.json`, `firebase.json`
