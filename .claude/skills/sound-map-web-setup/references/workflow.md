# Workflow — sound_map_app_web セットアップ詳細

SKILL.md から参照される実行手順。コピペで通るコマンドと、各ステップの「成功の定義」を併記する。

---

## 前提ツール

| ツール | 用途 | 確認 |
| --- | --- | --- |
| Flutter SDK | web ビルド | `flutter --version` |
| gcloud CLI (`gsutil` 含む) | Storage CORS | `gsutil version` |
| GCP プロジェクトへの権限 | API キー発行 / Storage 設定 | `gcloud config get-value project` |

`gsutil` が無い場合: `brew install --cask google-cloud-sdk` → `gcloud init` → `gcloud auth login`。

---

## 1. Google Maps API キーを作る

1. [GCP Console](https://console.cloud.google.com/) で プロジェクト `cocomakers-sound-classify-app` を選択
2. `APIs & Services → Library` で **Maps JavaScript API** を有効化
3. `APIs & Services → Credentials → Create credentials → API key`
4. 作成直後のモーダルで **Edit API key** を開く
5. **Application restrictions** を `HTTP referrers (web sites)` に設定し、以下を追加:
   - `http://localhost:*`
   - `http://localhost:*/*`
   - `https://cocomakers-sound-classify-app.web.app/*`
   - `https://cocomakers-sound-classify-app.firebaseapp.com/*`
6. **API restrictions** で `Maps JavaScript API` だけに制限
7. キー文字列をコピー（この後 `.env` に貼る）

**成功の定義**: Credentials 画面にキーが表示され、referrer 制限 4 行と API 制限 1 件が設定されている。

---

## 2. `.env` を作る

```bash
cp .env.example .env
```

`.env` を開いて、`YOURAPIKEY=` の右辺にキーを貼る:

```
YOURAPIKEY=AIza...（実際のキー）
```

- `lib/env/env.dart` の `String.fromEnvironment('YOURAPIKEY')` が参照するため、**キー名は `YOURAPIKEY` 固定**。
- `.env` は `.gitignore` 済みであることを確認 (`git check-ignore .env` が `.env` を返せば OK)。

---

## 3. Firebase Storage の CORS 設定

バケット: `cocomakers-sound-classify-app.appspot.com`

```bash
gsutil cors set cors.json gs://cocomakers-sound-classify-app.appspot.com
gsutil cors get gs://cocomakers-sound-classify-app.appspot.com
```

**成功の定義**: `gsutil cors get` の出力が `cors.json` と同じ JSON を返す。

`AccessDeniedException: 403` が出るときは、ログイン中の gcloud アカウントが該当プロジェクトの `Storage Admin` 権限を持っているか確認:

```bash
gcloud auth list
gcloud config set project cocomakers-sound-classify-app
```

---

## 4. ローカル起動

```bash
flutter pub get
flutter run -d chrome --dart-define-from-file=.env
```

**成功の定義**:
- Chrome が起動し、ログイン/新規登録画面が出る
- ログイン後、Google Maps の位置情報許可ダイアログが出る
- 地図タイルが描画される（白い矩形のままなら失敗）

---

## 5. トラブルシュート

### 地図が白い
1. Chrome devtools の Console を開く
2. 以下のキーワードを探す:
   - `ApiNotActivatedMapError` → ステップ 1 の API 有効化が未完了
   - `RefererNotAllowedMapError` → referrer 制限に `http://localhost:*` が入っていない
   - `InvalidKeyMapError` → `.env` のキー文字列が間違い、または改行/空白混入
   - 何もエラーが出ない → キー未反映。`flutter clean && flutter pub get` 後に再起動

### `.env` のキーを変えても反映されない
`--dart-define-from-file` はビルド時埋め込みなので、プロセスを止めて再 `flutter run` する。hot reload では反映されない。

### 音声ファイル取得時の CORS エラー
- バケット名が一致しているか (`cocomakers-sound-classify-app.appspot.com`)
- `gsutil cors get` の結果が空 `[]` なら set がエラー終了している
- ブラウザのキャッシュを無効化してリロード

### 本番デプロイ後に地図が白い
`.web.app` / `.firebaseapp.com` の referrer が登録されているか再確認。変更反映まで最大数分かかる。
