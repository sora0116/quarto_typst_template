# Quarto + Typst + R Docker 環境

Quarto に内蔵された Typst で PDF を生成し、R コードセルは `knitr` で実行するための開発環境です。Docker Desktop が必要です。

## 最初の準備

PowerShell でこのフォルダを開き、イメージを作成して R パッケージを復元します。

```powershell
docker compose build
docker compose run --rm quarto R -q -e "renv::restore(prompt = FALSE)"
```

`renv.lock` は初期の最小構成です。追加した R パッケージは、コンテナ内でインストールした後に `renv::snapshot()` を実行してロックファイルへ記録してください。

## ライブプレビュー

```powershell
docker compose up
```

ブラウザで <http://localhost:4200> を開きます。終了は `Ctrl+C` です。

## レンダリング

プロジェクト全体をレンダリングします。

```powershell
docker compose run --rm quarto quarto render
```

初期サンプルだけを Typst PDF にする場合は次のとおりです。

```powershell
docker compose run --rm quarto quarto render example.qmd --to typst
```

生成物はホスト側の `_output` ディレクトリに保存されます。`example.qmd` には R コードセルがあり、動作確認にも使えます。

## Typst とフォント

内蔵 Typst のバージョンは次で確認できます。

```powershell
docker compose run --rm quarto quarto typst --version
```

日本語フォントはイメージに含めていません。独自フォントを使う場合は `fonts/` に `.ttf` または `.otf` を置き、`_quarto.yml` の `font-paths: fonts` を有効化してください。文書側では `mainfont` などにそのフォント名を指定できます。

## R パッケージの追加

パッケージを追加してロックファイルを更新する例です。

```powershell
docker compose run --rm quarto R -q -e "renv::install('ggplot2'); renv::snapshot()"
```

他の端末やイメージ更新後は、最初の準備の `renv::restore()` を実行して依存関係を復元してください。
