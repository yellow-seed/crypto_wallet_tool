# CryptoWalletTool API ドキュメント

このドキュメントでは、CryptoWalletTool gemで利用可能なすべてのメソッドと使用方法を説明します。

## 目次

- [Converter](#converter) - テキスト変換・変形ユーティリティ
- [Client](#client) - Ethereum JSON-RPCクライアント
- [TransactionDebugger](#transactiondebugger) - トランザクション分析ツール
  - [Fetcher](#fetcher) - トランザクション・レシート取得
  - [Transaction](#transaction) - トランザクションデータラッパー
  - [Receipt](#receipt) - レシートデータラッパー
  - [Utils](#utils) - ユーティリティモジュール

---

## Converter

テキスト変換とデータ変形のためのユーティリティクラスです。

### 基本メソッド

#### `Converter.to_uppercase(input)`

テキストを大文字に変換します。

```ruby
CryptoWalletTool::Converter.to_uppercase("hello world")
# => "HELLO WORLD"
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** String - 大文字に変換された文字列

---

#### `Converter.to_lowercase(input)`

テキストを小文字に変換します。

```ruby
CryptoWalletTool::Converter.to_lowercase("HELLO WORLD")
# => "hello world"
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** String - 小文字に変換された文字列

---

#### `Converter.reverse(input)`

文字列を反転します。

```ruby
CryptoWalletTool::Converter.reverse("hello")
# => "olleh"
```

**パラメータ:**
- `input` (String) - 反転する文字列

**戻り値:** String - 反転された文字列

---

#### `Converter.to_title_case(input)`

各単語の先頭を大文字にします（タイトルケース）。

```ruby
CryptoWalletTool::Converter.to_title_case("hello world")
# => "Hello World"
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** String - タイトルケースに変換された文字列

---

### ケース変換メソッド

#### `Converter.to_snake_case(input)`

キャメルケースをスネークケースに変換します。

```ruby
CryptoWalletTool::Converter.to_snake_case("helloWorld")
# => "hello_world"

CryptoWalletTool::Converter.to_snake_case("HelloWorldExample")
# => "hello_world_example"
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** String - スネークケースに変換された文字列

---

#### `Converter.to_camel_case(input)`

スネークケースやハイフン区切りをキャメルケースに変換します。

```ruby
CryptoWalletTool::Converter.to_camel_case("hello_world")
# => "helloWorld"

CryptoWalletTool::Converter.to_camel_case("hello-world-example")
# => "helloWorldExample"
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** String - キャメルケースに変換された文字列

---

### 文字列操作メソッド

#### `Converter.remove_whitespace(input)`

すべての空白文字を削除します。

```ruby
CryptoWalletTool::Converter.remove_whitespace("hello world")
# => "helloworld"

CryptoWalletTool::Converter.remove_whitespace("  hello   world  ")
# => "helloworld"
```

**パラメータ:**
- `input` (String) - 処理する文字列

**戻り値:** String - 空白が削除された文字列

---

#### `Converter.to_char_array(input)`

文字列を文字の配列に変換します。

```ruby
CryptoWalletTool::Converter.to_char_array("hello")
# => ["h", "e", "l", "l", "o"]
```

**パラメータ:**
- `input` (String) - 変換する文字列

**戻り値:** Array<String> - 文字の配列

---

#### `Converter.array_to_string(input)`

配列を文字列に結合します。

```ruby
CryptoWalletTool::Converter.array_to_string(["h", "e", "l", "l", "o"])
# => "hello"
```

**パラメータ:**
- `input` (Array) - 変換する配列

**戻り値:** String - 結合された文字列

---

### 複合変換メソッド

#### `Converter.transform(input, transformations)`

複数の変換を順番に適用します。

```ruby
CryptoWalletTool::Converter.transform("hello world", [:to_uppercase, :reverse])
# => "DLROW OLLEH"

CryptoWalletTool::Converter.transform("HelloWorld", [:to_snake_case, :remove_whitespace])
# => "helloworld"
```

**パラメータ:**
- `input` (String) - 変換する文字列
- `transformations` (Array<Symbol>) - 適用するメソッド名のシンボル配列

**戻り値:** String - すべての変換が適用された文字列

---

## Client

Ethereumノードと通信するためのJSON-RPCクライアントです。

### 初期化

```ruby
# デフォルトのURL (http://localhost:8545) を使用
client = CryptoWalletTool::Client.new('http://localhost:8545')

# カスタムノードURL
client = CryptoWalletTool::Client.new('https://mainnet.infura.io/v3/YOUR_PROJECT_ID')
```

**パラメータ:**
- `url` (String) - Ethereum JSON-RPCエンドポイントのURL

---

### トランザクション取得メソッド

#### `Client#eth_get_transaction_receipt(tx_hash)`

トランザクションハッシュからレシートを取得します。

```ruby
client = CryptoWalletTool::Client.new('http://localhost:8545')
receipt = client.eth_get_transaction_receipt('0x1234...')
# => { 'status' => '0x1', 'blockNumber' => '0x10', ... }
```

**パラメータ:**
- `tx_hash` (String) - トランザクションハッシュ（0x接頭辞付き）

**戻り値:** Hash - レシートデータ

**例外:**
- `TransactionNotFoundError` - トランザクションが見つからない場合
- `RPCError` - RPC呼び出しエラー

---

#### `Client#eth_get_transaction_by_hash(tx_hash)`

トランザクションハッシュからトランザクションデータを取得します。

```ruby
client = CryptoWalletTool::Client.new('http://localhost:8545')
tx = client.eth_get_transaction_by_hash('0x1234...')
# => { 'hash' => '0x1234...', 'from' => '0xabc...', ... }
```

**パラメータ:**
- `tx_hash` (String) - トランザクションハッシュ（0x接頭辞付き）

**戻り値:** Hash - トランザクションデータ

**例外:**
- `TransactionNotFoundError` - トランザクションが見つからない場合
- `RPCError` - RPC呼び出しエラー

---

### ブロックチェーン情報メソッド

#### `Client#eth_block_number`

現在のブロック番号を取得します。

```ruby
client = CryptoWalletTool::Client.new('http://localhost:8545')
block_num = client.eth_block_number
# => 12345678
```

**戻り値:** Integer - 現在のブロック番号

---

#### `Client#eth_call(params, block = 'latest')`

読み取り専用のコントラクト呼び出しを実行します。

```ruby
client = CryptoWalletTool::Client.new('http://localhost:8545')
result = client.eth_call({
  to: '0x1234...',
  data: '0x...'
}, 'latest')
# => "0x..."
```

**パラメータ:**
- `params` (Hash) - 呼び出しパラメータ（to, from, data など）
- `block` (String) - ブロック番号またはタグ（デフォルト: 'latest'）

**戻り値:** String - 呼び出し結果

---

## TransactionDebugger

Ethereumトランザクションの分析とデバッグのためのモジュールです。

---

## Fetcher

トランザクションとレシートデータを取得するためのクラスです。

### 初期化

```ruby
# デフォルトのクライアント（localhost:8545）を使用
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new

# カスタムクライアントを使用
client = CryptoWalletTool::Client.new('https://mainnet.infura.io/v3/YOUR_PROJECT_ID')
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new(client: client)
```

**パラメータ:**
- `client` (Client, optional) - 使用するClientインスタンス（デフォルト: localhost:8545）

---

### 取得メソッド

#### `Fetcher#fetch_receipt(tx_hash)`

レシートを取得し、Receiptオブジェクトとして返します。

```ruby
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new
receipt = fetcher.fetch_receipt('1234abcd...')  # 0x接頭辞なしでも可
# => #<CryptoWalletTool::TransactionDebugger::Receipt>
```

**パラメータ:**
- `tx_hash` (String) - トランザクションハッシュ（0x接頭辞は任意、空白は自動削除）

**戻り値:** Receipt - レシートオブジェクト

---

#### `Fetcher#fetch_transaction(tx_hash)`

トランザクションを取得し、Transactionオブジェクトとして返します。

```ruby
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new
tx = fetcher.fetch_transaction('0x1234abcd...')
# => #<CryptoWalletTool::TransactionDebugger::Transaction>
```

**パラメータ:**
- `tx_hash` (String) - トランザクションハッシュ（0x接頭辞は任意、空白は自動削除）

**戻り値:** Transaction - トランザクションオブジェクト

---

#### `Fetcher#fetch_both(tx_hash)`

トランザクションとレシートの両方を取得します。

```ruby
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new
result = fetcher.fetch_both('1234abcd...')
# => { transaction: #<Transaction>, receipt: #<Receipt> }

puts result[:receipt].success?  # => true
puts result[:transaction].value  # => 1000000000000000000
```

**パラメータ:**
- `tx_hash` (String) - トランザクションハッシュ（0x接頭辞は任意、空白は自動削除）

**戻り値:** Hash - `:transaction`と`:receipt`キーを含むハッシュ

---

## Transaction

トランザクションデータのラッパークラスです。生のRPCレスポンスを扱いやすくします。

### 初期化

```ruby
raw_data = {
  'hash' => '0x1234...',
  'from' => '0xabc...',
  'value' => '0xde0b6b3a7640000',
  'gas' => '0x5208',
  'gasPrice' => '0x4a817c800'
}
tx = CryptoWalletTool::TransactionDebugger::Transaction.new(raw_data)
```

**パラメータ:**
- `raw_data` (Hash) - RPCレスポンスの生データ

---

### アクセサメソッド

#### `Transaction#raw_data`

生のトランザクションデータを返します。

```ruby
tx.raw_data
# => { 'hash' => '0x1234...', ... }
```

**戻り値:** Hash - 生データ

---

#### `Transaction#hash`

トランザクションハッシュを返します。

```ruby
tx.hash
# => "0x1234abcd..."
```

**戻り値:** String - トランザクションハッシュ

---

#### `Transaction#from`

送信者アドレスを返します。

```ruby
tx.from
# => "0xabc..."
```

**戻り値:** String - 送信者アドレス

---

#### `Transaction#to`

受信者アドレスを返します。

```ruby
tx.to
# => "0xdef..."
```

**戻り値:** String - 受信者アドレス（コントラクト作成の場合はnil）

---

#### `Transaction#value`

送金額をWei単位の整数で返します。

```ruby
tx.value
# => 1000000000000000000  # 1 ETH in Wei
```

**戻り値:** Integer - Wei単位の送金額

---

#### `Transaction#gas`

ガスリミットを整数で返します。

```ruby
tx.gas
# => 21000
```

**戻り値:** Integer - ガスリミット

---

#### `Transaction#gas_price`

ガス価格をWei単位の整数で返します。

```ruby
tx.gas_price
# => 20000000000  # 20 Gwei
```

**戻り値:** Integer - Wei単位のガス価格

---

#### `Transaction#eip1559?`

トランザクションがEIP-1559（Type 2）かどうかを判定します。

```ruby
tx.eip1559?
# => false  # Legacy transaction
# => true   # EIP-1559 transaction
```

**戻り値:** Boolean - EIP-1559トランザクションの場合true

---

## Receipt

トランザクションレシートのラッパークラスです。実行結果の確認に使用します。

### 初期化

```ruby
raw_data = {
  'transactionHash' => '0x1234...',
  'status' => '0x1',
  'blockNumber' => '0x10',
  'gasUsed' => '0x5208'
}
receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(raw_data)
```

**パラメータ:**
- `raw_data` (Hash) - RPCレスポンスの生データ

---

### アクセサメソッド

#### `Receipt#raw_data`

生のレシートデータを返します。

```ruby
receipt.raw_data
# => { 'transactionHash' => '0x1234...', ... }
```

**戻り値:** Hash - 生データ

---

#### `Receipt#transaction_hash`

トランザクションハッシュを返します。

```ruby
receipt.transaction_hash
# => "0x1234abcd..."
```

**戻り値:** String - トランザクションハッシュ

---

#### `Receipt#status`

トランザクションのステータスをシンボルで返します。

```ruby
receipt.status
# => :success  # status = 0x1
# => :failed   # status = 0x0
# => :unknown  # その他
```

**戻り値:** Symbol - `:success`, `:failed`, `:unknown`のいずれか

---

#### `Receipt#success?`

トランザクションが成功したかどうかを返します。

```ruby
receipt.success?
# => true   # status = 0x1
# => false  # status = 0x0 or unknown
```

**戻り値:** Boolean - 成功の場合true

---

#### `Receipt#failed?`

トランザクションが失敗したかどうかを返します。

```ruby
receipt.failed?
# => true   # status = 0x0
# => false  # status = 0x1 or unknown
```

**戻り値:** Boolean - 失敗の場合true

---

#### `Receipt#block_number`

ブロック番号を整数で返します。

```ruby
receipt.block_number
# => 16  # 0x10 -> 16
```

**戻り値:** Integer - ブロック番号

---

#### `Receipt#gas_used`

使用されたガス量を整数で返します。

```ruby
receipt.gas_used
# => 21000  # 0x5208 -> 21000
```

**戻り値:** Integer - 使用ガス量

---

## Utils

TransactionDebuggerモジュールで使用される共通ユーティリティです。

### ヘルパーメソッド

#### `Utils#hex_to_int(hex_string)`

16進数文字列を整数に変換します。

```ruby
include CryptoWalletTool::TransactionDebugger::Utils

hex_to_int('0x5208')
# => 21000

hex_to_int('0xde0b6b3a7640000')
# => 1000000000000000000

hex_to_int(nil)
# => nil
```

**パラメータ:**
- `hex_string` (String, nil) - 16進数文字列（0x接頭辞付き）

**戻り値:** Integer, nil - 10進数の整数、またはnilの場合はnil

---

## 完全な使用例

### トランザクション分析の基本フロー

```ruby
require 'crypto_wallet_tool'

# 1. Fetcherを初期化
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new

# 2. トランザクションとレシートを取得
result = fetcher.fetch_both('0x1234abcd...')

# 3. トランザクション情報を確認
transaction = result[:transaction]
puts "From: #{transaction.from}"
puts "To: #{transaction.to}"
puts "Value: #{transaction.value} Wei"
puts "Gas: #{transaction.gas}"
puts "Gas Price: #{transaction.gas_price} Wei"
puts "EIP-1559?: #{transaction.eip1559?}"

# 4. レシート情報を確認
receipt = result[:receipt]
puts "Status: #{receipt.status}"
puts "Success?: #{receipt.success?}"
puts "Block Number: #{receipt.block_number}"
puts "Gas Used: #{receipt.gas_used}"

# 5. 成功/失敗の判定
if receipt.success?
  puts "Transaction succeeded!"
else
  puts "Transaction failed!"
end
```

### カスタムノードの使用

```ruby
require 'crypto_wallet_tool'

# カスタムクライアントを作成
client = CryptoWalletTool::Client.new('https://mainnet.infura.io/v3/YOUR_PROJECT_ID')

# Fetcherにカスタムクライアントを渡す
fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new(client: client)

# トランザクションを取得
result = fetcher.fetch_both('0x...')
```

### テキスト変換との組み合わせ

```ruby
require 'crypto_wallet_tool'

# アドレスをフォーマット
address = "0xABCDEF1234567890"
formatted = CryptoWalletTool::Converter.to_lowercase(address)
# => "0xabcdef1234567890"

# トランザクションハッシュを正規化
tx_hash = "  1234ABCD  "
normalized = CryptoWalletTool::Converter.remove_whitespace(tx_hash)
normalized = CryptoWalletTool::Converter.to_lowercase(normalized)
# => "1234abcd"
```

---

## エラーハンドリング

### RPCError

RPC呼び出し時のエラーをキャッチします。

```ruby
begin
  client = CryptoWalletTool::Client.new('http://localhost:8545')
  receipt = client.eth_get_transaction_receipt('0x...')
rescue CryptoWalletTool::RPCError => e
  puts "RPC Error: #{e.message}"
  puts "Error Code: #{e.code}"
  puts "Error Data: #{e.data}"
end
```

### TransactionNotFoundError

トランザクションが見つからない場合のエラーをキャッチします。

```ruby
begin
  fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new
  result = fetcher.fetch_both('0xnonexistent...')
rescue CryptoWalletTool::TransactionNotFoundError => e
  puts "Transaction not found: #{e.message}"
end
```

---

## 参考リンク

- [GitHub Repository](https://github.com/yellow-seed/crypto_wallet_tool)
- [RubyGems](https://rubygems.org/gems/crypto_wallet_tool)
- [Ethereum JSON-RPC Specification](https://ethereum.org/en/developers/docs/apis/json-rpc/)
