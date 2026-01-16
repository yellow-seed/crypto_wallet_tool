# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::Client do
  let(:url) { 'http://localhost:8545' }
  let(:client) { described_class.new(url) }
  let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

  describe '#initialize' do
    it 'creates a new client with the given URL' do
      expect(client.url).to eq(url)
    end
  end

  describe '#eth_get_transaction_receipt' do
    let(:receipt) do
      {
        'transactionHash' => tx_hash,
        'blockNumber' => '0x1',
        'status' => '0x1'
      }
    end

    context 'when transaction exists' do
      before do
        stub_rpc_request('eth_getTransactionReceipt', [tx_hash], receipt)
      end

      it 'returns the transaction receipt' do
        result = client.eth_get_transaction_receipt(tx_hash)
        expect(result).to eq(receipt)
      end
    end

    context 'when transaction does not exist' do
      before do
        stub_rpc_request('eth_getTransactionReceipt', [tx_hash], nil)
      end

      it 'raises TransactionNotFoundError' do
        expect do
          client.eth_get_transaction_receipt(tx_hash)
        end.to raise_error(CryptoWalletTool::TransactionNotFoundError, /not found/)
      end
    end
  end

  describe '#eth_get_transaction_by_hash' do
    let(:transaction) do
      {
        'hash' => tx_hash,
        'blockNumber' => '0x1',
        'from' => '0xabcd',
        'to' => '0x1234'
      }
    end

    context 'when transaction exists' do
      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction)
      end

      it 'returns the transaction data' do
        result = client.eth_get_transaction_by_hash(tx_hash)
        expect(result).to eq(transaction)
      end
    end

    context 'when transaction does not exist' do
      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], nil)
      end

      it 'raises TransactionNotFoundError' do
        expect do
          client.eth_get_transaction_by_hash(tx_hash)
        end.to raise_error(CryptoWalletTool::TransactionNotFoundError, /not found/)
      end
    end
  end

  describe '#eth_call' do
    let(:params) { { 'to' => '0x1234', 'data' => '0xabcd' } }
    let(:result) { '0x0000000000000000000000000000000000000000000000000000000000000001' }

    context 'with default block parameter' do
      before do
        stub_rpc_request('eth_call', [params, 'latest'], result)
      end

      it 'executes the call and returns the result' do
        expect(client.eth_call(params)).to eq(result)
      end
    end

    context 'with custom block parameter' do
      before do
        stub_rpc_request('eth_call', [params, '0x1'], result)
      end

      it 'executes the call with the specified block' do
        expect(client.eth_call(params, '0x1')).to eq(result)
      end
    end
  end

  describe '#eth_block_number' do
    before do
      stub_rpc_request('eth_blockNumber', [], '0x4b7') # 1207 in decimal
    end

    it 'returns the current block number as an integer' do
      expect(client.eth_block_number).to eq(1207)
    end
  end

  describe '#eth_get_block_by_number' do
    let(:block_data) do
      {
        'number' => '0x10',
        'hash' => '0xabc',
        'transactions' => []
      }
    end

    context 'when block number is an integer' do
      before do
        stub_rpc_request('eth_getBlockByNumber', ['0x10', false], block_data)
      end

      it 'normalizes the block number and returns block data' do
        expect(client.eth_get_block_by_number(16)).to eq(block_data)
      end
    end

    context 'when block number is a tag' do
      before do
        stub_rpc_request('eth_getBlockByNumber', ['latest', true], block_data)
      end

      it 'returns block data for the specified tag' do
        expect(client.eth_get_block_by_number('latest', true)).to eq(block_data)
      end
    end
  end

  describe '#eth_get_balance' do
    let(:address) { '0xabcdefabcdefabcdefabcdefabcdefabcdefabcd' }
    let(:balance) { '0x1234' }

    before do
      stub_rpc_request('eth_getBalance', [address, 'latest'], balance)
    end

    it 'returns the balance in wei' do
      expect(client.eth_get_balance(address)).to eq(balance)
    end
  end

  describe 'error handling' do
    context 'when RPC returns an error' do
      before do
        stub_request(:post, url)
          .to_return(
            status: 200,
            body: {
              jsonrpc: '2.0',
              id: 1,
              error: {
                code: -32_000,
                message: 'insufficient funds'
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises RPCError with error details' do
        expect do
          client.eth_block_number
        end.to raise_error(CryptoWalletTool::RPCError, /insufficient funds/)
      end
    end

    context 'when HTTP request fails' do
      before do
        stub_request(:post, url).to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises RPCError' do
        expect do
          client.eth_block_number
        end.to raise_error(CryptoWalletTool::RPCError)
      end
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
