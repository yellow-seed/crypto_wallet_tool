# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::TransactionDebugger::Fetcher do
  let(:url) { 'http://localhost:8545' }
  let(:client) { CryptoWalletTool::Client.new(url) }
  let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

  describe '#initialize' do
    context 'when client is provided' do
      it 'uses the provided client' do
        fetcher = described_class.new(client: client)
        expect(fetcher.instance_variable_get(:@client)).to eq(client)
      end
    end

    context 'when client is not provided' do
      it 'creates a new client with default URL' do
        fetcher = described_class.new
        default_client = fetcher.instance_variable_get(:@client)
        expect(default_client).to be_a(CryptoWalletTool::Client)
        expect(default_client.url).to eq('http://localhost:8545')
      end
    end
  end

  describe '#fetch_receipt' do
    let(:fetcher) { described_class.new(client: client) }
    let(:receipt_data) do
      {
        'transactionHash' => tx_hash,
        'blockNumber' => '0x4b7',
        'status' => '0x1',
        'gasUsed' => '0x5208'
      }
    end

    before do
      stub_rpc_request('eth_getTransactionReceipt', [tx_hash], receipt_data)
    end

    it 'fetches and returns a Receipt object' do
      receipt = fetcher.fetch_receipt(tx_hash)
      expect(receipt).to be_a(CryptoWalletTool::TransactionDebugger::Receipt)
      expect(receipt.transaction_hash).to eq(tx_hash)
      expect(receipt.status).to eq(:success)
    end

    context 'when hash is not prefixed with 0x' do
      it 'normalizes the hash and fetches the receipt' do
        tx_hash_without_prefix = '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'
        receipt = fetcher.fetch_receipt(tx_hash_without_prefix)
        expect(receipt).to be_a(CryptoWalletTool::TransactionDebugger::Receipt)
      end
    end

    context 'when hash has whitespace' do
      it 'strips whitespace and fetches the receipt' do
        receipt = fetcher.fetch_receipt("  #{tx_hash}  ")
        expect(receipt).to be_a(CryptoWalletTool::TransactionDebugger::Receipt)
      end
    end
  end

  describe '#fetch_transaction' do
    let(:fetcher) { described_class.new(client: client) }
    let(:transaction_data) do
      {
        'hash' => tx_hash,
        'from' => '0xabcdef1234567890abcdef1234567890abcdef12',
        'to' => '0x1234567890abcdef1234567890abcdef12345678',
        'value' => '0xde0b6b3a7640000',
        'gas' => '0x5208',
        'gasPrice' => '0x3b9aca00'
      }
    end

    before do
      stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction_data)
    end

    it 'fetches and returns a Transaction object' do
      transaction = fetcher.fetch_transaction(tx_hash)
      expect(transaction).to be_a(CryptoWalletTool::TransactionDebugger::Transaction)
      expect(transaction.hash).to eq(tx_hash)
      expect(transaction.from).to eq('0xabcdef1234567890abcdef1234567890abcdef12')
    end

    context 'when hash is not prefixed with 0x' do
      it 'normalizes the hash and fetches the transaction' do
        tx_hash_without_prefix = '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'
        transaction = fetcher.fetch_transaction(tx_hash_without_prefix)
        expect(transaction).to be_a(CryptoWalletTool::TransactionDebugger::Transaction)
      end
    end

    context 'when hash has whitespace' do
      it 'strips whitespace and fetches the transaction' do
        transaction = fetcher.fetch_transaction("  #{tx_hash}  ")
        expect(transaction).to be_a(CryptoWalletTool::TransactionDebugger::Transaction)
      end
    end
  end

  describe '#fetch_both' do
    let(:fetcher) { described_class.new(client: client) }

    before do
      receipt_data = { 'transactionHash' => tx_hash, 'blockNumber' => '0x4b7', 'status' => '0x1', 'gasUsed' => '0x5208' }
      transaction_data = { 'hash' => tx_hash, 'from' => '0xabcdef1234567890abcdef1234567890abcdef12',
                           'to' => '0x1234567890abcdef1234567890abcdef12345678',
                           'value' => '0xde0b6b3a7640000', 'gas' => '0x5208', 'gasPrice' => '0x3b9aca00' }
      stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction_data)
      stub_rpc_request('eth_getTransactionReceipt', [tx_hash], receipt_data)
    end

    it 'fetches both transaction and receipt' do
      result = fetcher.fetch_both(tx_hash)
      expect(result[:transaction]).to be_a(CryptoWalletTool::TransactionDebugger::Transaction)
      expect(result[:receipt]).to be_a(CryptoWalletTool::TransactionDebugger::Receipt)
    end
  end

  private

  def stub_rpc_request(method, params, result)
    stub_request(:post, url)
      .with(
        body: hash_including(
          jsonrpc: '2.0',
          method: method,
          params: params
        )
      )
      .to_return(
        status: 200,
        body: {
          jsonrpc: '2.0',
          id: 1,
          result: result
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end
