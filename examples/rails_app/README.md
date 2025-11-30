# Rails Sample Application for crypto_wallet_tool

このディレクトリには、crypto_wallet_tool Gemの動作確認を行うためのRails APIアプリケーションが含まれています。

## 概要

- **Rails**: 7.2+ (APIモード)
- **Ruby**: 3.2.9
- **Database**: PostgreSQL 15
- **Environment**: Docker & Docker Compose

## セットアップ

### 前提条件

- Docker
- Docker Compose (v2.0+)

**注意**: Docker環境でのビルドには、ネットワーク環境によってはSSL証明書の問題が発生する場合があります。その場合は、ローカル開発環境での実行を推奨します。

### 起動方法

#### オプション1: Docker Compose（推奨）

1. リポジトリのルートディレクトリから、以下のコマンドを実行してください：

```bash
cd examples/rails_app
docker compose build
docker compose up
```

#### オプション2: ローカル開発環境

Docker環境でSSL証明書の問題が発生する場合は、ローカル環境で実行できます：

```bash
cd examples/rails_app

# 依存関係のインストール
bundle install

# データベースのセットアップ（PostgreSQLが必要）
export DB_HOST=localhost
export DB_USERNAME=postgres
export DB_PASSWORD=your_password
bin/rails db:create db:migrate

# サーバーの起動
bin/rails server
```

2. アプリケーションが起動したら、以下のURLにアクセスできます：

- Health Check API: http://localhost:3000/api/health
- Rails Health Check: http://localhost:3000/up

### 動作確認

Health Check APIエンドポイントは、以下の情報を返します：

```json
{
  "status": "ok",
  "message": "Rails app is running with crypto_wallet_tool gem",
  "database": "connected",
  "gem_test": {
    "input": "hello world",
    "output": "HELLO WORLD"
  }
}
```

これにより、以下が確認できます：
- Railsアプリケーションが正常に起動している
- PostgreSQLデータベースに接続できている
- crypto_wallet_tool Gemが正しく読み込まれている

## 開発コマンド

### Dockerを使用する場合

#### コンテナの起動

```bash
docker compose up
```

#### コンテナの停止

```bash
docker compose down
```

#### データベースのリセット

```bash
docker compose run --rm web bin/rails db:reset
```

#### Railsコンソールの起動

```bash
docker compose run --rm web bin/rails console
```

#### シェルへのアクセス

```bash
docker compose run --rm web bash
```

#### ログの確認

```bash
docker compose logs -f web
```

### ローカル環境を使用する場合

#### サーバーの起動

```bash
bin/rails server
```

#### Railsコンソールの起動

```bash
bin/rails console
```

#### データベースのリセット

```bash
bin/rails db:reset
```

## プロジェクト構造

```
examples/rails_app/
├── app/
│   └── controllers/
│       └── api/
│           └── health_controller.rb    # Health check API
├── config/
│   ├── database.yml                    # Database configuration (Docker-ready)
│   └── routes.rb                       # API routes
├── Dockerfile                          # Development Dockerfile
├── docker-compose.yml                  # Docker Compose configuration
├── Gemfile                             # Includes crypto_wallet_tool gem
└── README.md                           # This file
```

## crypto_wallet_tool Gemの使用例

`app/controllers/api/health_controller.rb`で実装例を確認できます：

```ruby
# Gemのメソッドを使用
sample_text = "hello world"
transformed = CryptoWalletTool::Converter.to_uppercase(sample_text)
# => "HELLO WORLD"
```

## トラブルシューティング

### Docker ビルドでのSSL証明書エラー

Docker環境でのビルド時にSSL証明書の検証エラーが発生する場合は、ネットワーク環境やファイアウォールの問題である可能性があります。この場合は、ローカル開発環境での実行を推奨します。

### ポートが既に使用されている

ポート3000または5432が既に使用されている場合、`docker-compose.yml`のポート設定を変更してください。

### データベース接続エラー

データベースコンテナが完全に起動するまで待ってから、Webコンテナを起動してください：

```bash
docker compose up db
# 数秒待つ
docker compose up web
```

または、以下のコマンドですべてをクリーンアップして再起動：

```bash
docker compose down -v
docker compose up --build
```

## 関連ドキュメント

- [crypto_wallet_tool README](../../README.md)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Docker Documentation](https://docs.docker.com/)

