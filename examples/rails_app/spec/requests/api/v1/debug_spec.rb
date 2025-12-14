require 'swagger_helper'

RSpec.describe 'api/v1/debug', type: :request do
  path '/api/v1/debug/transaction' do
    post('Analyze transaction with debugging info') do
      tags 'Transaction Debugger'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transaction_hash, in: :query, type: :string, required: true,
                description: 'Transaction hash (0x-prefixed hex string)',
                example: '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'

      response(200, 'successful') do
        let(:transaction_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

        schema type: :object,
          properties: {
            hash: { type: :string },
            from: { type: :string },
            to: { type: :string },
            value: { type: :integer },
            gas: { type: :integer },
            gas_price: { type: :integer },
            eip1559: { type: :boolean },
            raw_data: { type: :object }
          },
          required: [ "hash", "from", "to", "value", "gas", "gas_price", "eip1559" ]

        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return('https://eth.llamarpc.com')
          tx_data = {
            'hash' => transaction_hash,
            'from' => '0xabcd1234',
            'to' => '0xef015678',
            'value' => '0x0',
            'gas' => '0x5208',
            'gasPrice' => '0x3b9aca00'
          }
          tx_obj = CryptoWalletTool::TransactionDebugger::Transaction.new(tx_data)
          allow_any_instance_of(CryptoWalletTool::TransactionDebugger::Fetcher)
            .to receive(:fetch_transaction).and_return(tx_obj)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['hash']).to eq(transaction_hash)
          expect(data).to have_key('eip1559')
        end
      end

      response(404, 'transaction not found') do
        let(:transaction_hash) { '0x0000000000000000000000000000000000000000000000000000000000000000' }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return('https://eth.llamarpc.com')
          allow_any_instance_of(CryptoWalletTool::TransactionDebugger::Fetcher)
            .to receive(:fetch_transaction)
            .and_raise(CryptoWalletTool::TransactionNotFoundError, 'Transaction not found')
        end

        run_test!
      end

      response(503, 'RPC endpoint not configured') do
        let(:transaction_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return(nil)
        end

        run_test!
      end
    end
  end

  path '/api/v1/debug/receipt' do
    post('Analyze transaction receipt with debugging info') do
      tags 'Transaction Debugger'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transaction_hash, in: :query, type: :string, required: true,
                description: 'Transaction hash (0x-prefixed hex string)'

      response(200, 'successful') do
        let(:transaction_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

        schema type: :object,
          properties: {
            transaction_hash: { type: :string },
            status: { type: :string },
            success: { type: :boolean },
            failed: { type: :boolean },
            block_number: { type: :integer },
            gas_used: { type: :integer },
            raw_data: { type: :object }
          },
          required: [ "transaction_hash", "status", "success", "failed", "block_number", "gas_used" ]

        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return('https://eth.llamarpc.com')
          receipt_data = {
            'transactionHash' => transaction_hash,
            'status' => '0x1',
            'blockNumber' => '0x1',
            'gasUsed' => '0x5208'
          }
          receipt_obj = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
          allow_any_instance_of(CryptoWalletTool::TransactionDebugger::Fetcher)
            .to receive(:fetch_receipt).and_return(receipt_obj)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['transaction_hash']).to eq(transaction_hash)
          expect(data['status']).to be_in([ "success", "failed", "unknown" ])
          expect(data).to have_key('success')
          expect(data).to have_key('failed')
        end
      end

      response(404, 'transaction not found') do
        let(:transaction_hash) { '0x0000000000000000000000000000000000000000000000000000000000000000000000' }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return('https://eth.llamarpc.com')
          allow_any_instance_of(CryptoWalletTool::TransactionDebugger::Fetcher)
            .to receive(:fetch_receipt)
            .and_raise(CryptoWalletTool::TransactionNotFoundError, 'Transaction not found')
        end

        run_test!
      end
    end
  end
end
