# qrun & qrun-setup

Amazon Q CLIをコンテナで動かすための簡単なDockerのラッパープログラム

現在のディレクトリ（`$PWD`）を **自動的に** コンテナの `/workspace` にバインドし、  
面倒な `docker run ... -v $(pwd):/workspace ...` を一発で実行できるシンプルなラッパーです。
Dockerfileが一緒においてありますが、そのなかでAmazon Q CLIのインストールを行っています。
このDockerfileをカスタマイズすることでコンテナの環境をカスタマイズできます。

| コマンド | 役割 |
|----------|------|
| **`qrun-setup`** | 同じフォルダにある **Dockerfile** から _既定イメージ_ をビルドし、`~/.config/qrun/image_tag` に登録する。引数は *任意* でタグのみ指定可能 |
| **`qrun`** | 登録済みイメージを使ってコンテナを起動。イメージ未登録・未ビルド時はエラーで促す |

---

## 特長 🏷️

* **今いるフォルダを自動マウント** — `$(pwd)` → `/workspace`  
* **UID/GID をホストと合わせる** — `--user $(id -u):$(id -g)`  
* **“既定イメージ” ワークフロー** — `qrun-setup` 一回だけ → 以後 `qrun`  
* **不要なゴミを残さない** — `--rm` でコンテナ終了時に自動削除  
* **シェル一発導入** — bash だけで動作  

---

## 動作要件

* **Docker** (`docker build`, `docker run` が使えること）
* **bash** 
* Linux／macOS／WSL

---

## インストール

```bash
git clone https://github.com/lambdasakura/qrun.git
cd qrun

# パスの通った所へ配置
mkdir -p ~/bin
cp qrun qrun-setup ~/bin
chmod +x ~/bin/qrun ~/bin/qrun-setup
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

---

## 使い方

### 1. 既定イメージをビルド & 登録

```bash
# タグ省略 → qrun-default:latest
qrun-setup

# 好きなタグを与える
qrun-setup mybase:dev
```

> **ヒント**  
> `qrun-setup` は _必ず_ スクリプトと同じディレクトリの Dockerfile を使います。  
> Dockerfile を変更したら再度 `qrun-setup` を実行してください。

---

### 2. コンテナを起動

```bash
cd ~/project
qrun                 # 既定イメージ + bash
```

| 呼び方 | 動作 |
|--------|------|
| `qrun` | 既定イメージで `/bin/bash` |
| `qrun ls -la` | 既定イメージで `ls -la` |
| `qrun alpine:edge` | イメージを指定して起動 |
| `qrun node:22 npm test` | `node:22` で `npm test` |

---

## カスタマイズ

スクリプト冒頭の変数を編集してください。

| 変数 | 目的 |
|------|------|
| `WORKDIR_IN_CONTAINER` | デフォルト `/workspace` |
| `CUSTOM_OPTS` (qrun) | `--gpus all` 等を追加 |
| `CMD=(bash)` | デフォルトシェルを変更 |

---

## FAQ

<details>
<summary>既定イメージを変更したい</summary>

Dockerfile を更新 → `qrun-setup [<新タグ>]` を実行 → 古いタグは `docker image rm <tag>` で削除。
</details>


---

## ライセンス

MIT License — 詳細は `LICENSE` を参照。
