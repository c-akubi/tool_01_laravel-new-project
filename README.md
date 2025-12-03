# tool_01_laravel-new-project

**Laravel 12 + Breeze** の新規プロジェクトを **macOS** 上で  
自動構築するセットアップスクリプトです。

PHP / Composer / Node.js の依存関係チェック、  
Laravel プロジェクト生成、Breeze インストール、  
`.env` 初期化、`APP_KEY` 生成までを **一括で自動実行**します。

---

## English Description

Auto setup script for creating **Laravel 12 + Breeze** projects on **macOS**.  
Automatically checks dependencies (PHP / Composer / Node.js),  
creates a new Laravel project, installs Breeze, prepares `.env`,  
and generates the application key — all in one command.

---

## Features / 機能一覧

- ✔ Homebrew の存在チェック＆必要ならインストール  
- ✔ PHP バージョン確認（Laravel12 推奨バージョンの案内付き）  
- ✔ Composer / Node.js の存在チェック＆必要ならインストール  
- ✔ Laravel 12 プロジェクト自動生成  
- ✔ Breeze（Blade / Vue / React）自動インストール  
- ✔ `.env.example` → `.env` 自動コピー  
- ✔ `APP_KEY` 自動生成  
- ✔ プロジェクト名・保存先・フロント選択の対話式  
- ✔ 数値選択によるフロントエンド方式の簡易選択  
- ✔ カラー付きログで視認性UP  

---

## Usage / 使い方

```bash
chmod +x laravel-new-project.sh
./laravel-new-project.sh
