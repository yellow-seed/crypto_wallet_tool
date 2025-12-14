require 'swagger_helper'

RSpec.describe 'api/v1/ethereum', type: :request do
  path '/api/v1/ethereum/transaction' do
    post('Get transaction by hash') do
      tags 'Ethereum'
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
            value: { type: :string },
            gas: { type: :string },
            gasPrice: { type: :string },
            blockNumber: { type: :string },
            blockHash: { type: :string }
          }

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_get_transaction_by_hash).and_return({
            'hash' => transaction_hash,
            'from' => '0xabcd',
            'to' => '0xef01',
            'value' => '0x0',
            'gas' => '0x5208',
            'gasPrice' => '0x3b9aca00'
          })
        end

        run_test!
      end

      response(404, 'transaction not found') do
        let(:transaction_hash) { '0x0000000000000000000000000000000000000000000000000000000000000000' }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_get_transaction_by_hash)
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
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return(nil)
        end

        run_test!
      end
    end
  end

  path '/api/v1/ethereum/receipt' do
    post('Get transaction receipt') do
      tags 'Ethereum'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transaction_hash, in: :query, type: :string, required: true,
                description: 'Transaction hash (0x-prefixed hex string)'

      response(200, 'successful') do
        let(:transaction_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }

        schema type: :object,
          properties: {
            transactionHash: { type: :string },
            status: { type: :string },
            blockNumber: { type: :string },
            gasUsed: { type: :string },
            logs: { type: :array }
          }

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_get_transaction_receipt).and_return({
            'transactionHash' => transaction_hash,
            'status' => '0x1',
            'blockNumber' => '0x1',
            'gasUsed' => '0x5208',
            'logs' => []
          })
        end

        run_test!
      end

      response(404, 'transaction not found') do
        let(:transaction_hash) { '0x0000000000000000000000000000000000000000000000000000000000000000' }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_get_transaction_receipt)
            .and_raise(CryptoWalletTool::TransactionNotFoundError, 'Transaction not found')
        end

        run_test!
      end
    end
  end

  path '/api/v1/ethereum/block_number' do
    post('Get current block number') do
      tags 'Ethereum'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
          properties: {
            block_number: { type: :integer }
          },
          required: [ "block_number" ]

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_block_number).and_return(12345678)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['block_number']).to be_a(Integer)
        end
      end

      response(503, 'RPC endpoint not configured') do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          allow(ENV).to receive(:fetch).with('ETHEREUM_RPC_URL', nil).and_return(nil)
        end

        run_test!
      end
    end
  end

  path '/api/v1/ethereum/call' do
    post('Execute eth_call') do
      tags 'Ethereum'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :call, in: :body, schema: {
        type: :object,
        properties: {
          to: { type: :string, description: 'Contract address' },
          from: { type: :string, description: 'Sender address (optional)' },
          data: { type: :string, description: 'Encoded function call data' },
          gas: { type: :string, description: 'Gas limit (optional)' },
          gasPrice: { type: :string, description: 'Gas price (optional)' },
          value: { type: :string, description: 'Value to send (optional)' }
        },
        required: [ "to" ]
      }
      parameter name: :block, in: :query, type: :string, required: false,
                description: 'Block number or tag (latest, earliest, pending)',
                default: 'latest'

      response(200, 'successful') do
        let(:call) { { to: '0x1234567890123456789012345678901234567890', data: '0x' } }
        let(:block) { 'latest' }

        schema type: :object,
          properties: {
            result: { type: :string }
          }

        before do
          allow_any_instance_of(CryptoWalletTool::Client).to receive(:eth_call).and_return('0x0000000000000000000000000000000000000000000000000000000000000001')
        end

        run_test!
      end
    end
  end
end
