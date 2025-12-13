# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::TransactionDebugger::RevertDecoder do
  let(:client) { CryptoWalletTool::Client.new('http://localhost:8545') }
  let(:decoder) { described_class.new(client: client) }

  describe '#initialize' do
    context 'when client is provided' do
      it 'uses the provided client' do
        expect(decoder.instance_variable_get(:@client)).to eq(client)
      end
    end

    context 'when client is not provided' do
      let(:decoder) { described_class.new }

      it 'initializes without a client' do
        expect(decoder.instance_variable_get(:@client)).to be_nil
      end
    end
  end

  describe '#decode_revert_data' do
    context 'when data is nil' do
      it 'returns nil' do
        expect(decoder.decode_revert_data(nil)).to be_nil
      end
    end

    context 'when data is empty (0x)' do
      it 'returns nil' do
        expect(decoder.decode_revert_data('0x')).to be_nil
      end
    end

    context 'with Error(string) signature' do
      # Error(string) for "Insufficient balance"
      # Signature: 0x08c379a0
      # ABI encoding of string "Insufficient balance"
      let(:error_data) do
        '0x08c379a0' \
          '0000000000000000000000000000000000000000000000000000000000000020' \
          '0000000000000000000000000000000000000000000000000000000000000014' \
          '496e73756666696369656e742062616c616e6365000000000000000000000000'
      end

      it 'decodes the error string' do
        result = decoder.decode_revert_data(error_data)
        expect(result).to eq('Insufficient balance')
      end
    end

    context 'with Error(string) signature for simple error' do
      # Error(string) for "Error"
      let(:error_data) do
        '0x08c379a0' \
          '0000000000000000000000000000000000000000000000000000000000000020' \
          '0000000000000000000000000000000000000000000000000000000000000005' \
          '4572726f72000000000000000000000000000000000000000000000000000000'
      end

      it 'decodes the error string' do
        result = decoder.decode_revert_data(error_data)
        expect(result).to eq('Error')
      end
    end

    context 'with Panic signature for assertion error (0x01)' do
      let(:panic_data) do
        '0x4e487b71' \
          '0000000000000000000000000000000000000000000000000000000000000001'
      end

      it 'decodes the panic code' do
        result = decoder.decode_revert_data(panic_data)
        expect(result).to eq('Panic: Assertion error (code: 0x1)')
      end
    end

    context 'with Panic signature for arithmetic overflow (0x11)' do
      let(:panic_data) do
        '0x4e487b71' \
          '0000000000000000000000000000000000000000000000000000000000000011'
      end

      it 'decodes the panic code' do
        result = decoder.decode_revert_data(panic_data)
        expect(result).to eq('Panic: Arithmetic operation underflowed or overflowed (code: 0x11)')
      end
    end

    context 'with Panic signature for division by zero (0x12)' do
      let(:panic_data) do
        '0x4e487b71' \
          '0000000000000000000000000000000000000000000000000000000000000012'
      end

      it 'decodes the panic code' do
        result = decoder.decode_revert_data(panic_data)
        expect(result).to eq('Panic: Division or modulo by zero (code: 0x12)')
      end
    end

    context 'with Panic signature for unknown panic code' do
      let(:panic_data) do
        '0x4e487b71' \
          '0000000000000000000000000000000000000000000000000000000000000099'
      end

      it 'returns unknown panic code message' do
        result = decoder.decode_revert_data(panic_data)
        expect(result).to eq('Panic: Unknown panic code (code: 0x99)')
      end
    end

    context 'with unknown signature' do
      let(:unknown_data) { "0x12345678#{'0' * 64}" }

      it 'returns unknown error message' do
        result = decoder.decode_revert_data(unknown_data)
        expect(result).to eq('Unknown error (signature: 0x12345678)')
      end
    end

    context 'with data without 0x prefix' do
      let(:error_data) do
        '08c379a0' \
          '0000000000000000000000000000000000000000000000000000000000000020' \
          '0000000000000000000000000000000000000000000000000000000000000005' \
          '4572726f72000000000000000000000000000000000000000000000000000000'
      end

      it 'decodes the error string' do
        result = decoder.decode_revert_data(error_data)
        expect(result).to eq('Error')
      end
    end

    context 'with invalid error string data' do
      let(:invalid_data) { '0x08c379a0invalid' }

      it 'returns decode failure message' do
        result = decoder.decode_revert_data(invalid_data)
        expect(result).to start_with('Failed to decode error string:')
      end
    end
  end

  describe '#decode_from_receipt' do
    context 'when receipt is successful' do
      it 'returns nil' do
        receipt_data = {
          'transactionHash' => '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
          'blockNumber' => '0x4b7',
          'status' => '0x1',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        expect(decoder.decode_from_receipt(receipt)).to be_nil
      end
    end

    context 'when receipt has revertReason' do
      let(:revert_reason_data) do
        '0x08c379a0' \
          '0000000000000000000000000000000000000000000000000000000000000020' \
          '0000000000000000000000000000000000000000000000000000000000000005' \
          '4572726f72000000000000000000000000000000000000000000000000000000'
      end

      it 'decodes the revert reason from receipt' do
        receipt_data = {
          'transactionHash' => '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208',
          'revertReason' => revert_reason_data
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        expect(decoder.decode_from_receipt(receipt)).to eq('Error')
      end
    end

    context 'when receipt does not have revertReason and eth_call succeeds' do
      let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }
      let(:transaction) do
        {
          'from' => '0xfrom',
          'to' => '0xto',
          'input' => '0xdata',
          'value' => '0x0'
        }
      end

      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction)
        stub_rpc_request(
          'eth_call',
          [{
            from: '0xfrom',
            to: '0xto',
            data: '0xdata',
            value: '0x0'
          }, 1206],
          '0x'
        )
      end

      it 'returns nil' do
        receipt_data = {
          'transactionHash' => tx_hash,
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        result = decoder.decode_from_receipt(receipt)
        expect(result).to be_nil
      end
    end

    context 'when receipt does not have revertReason and eth_call fails with execution reverted' do
      let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }
      let(:transaction) do
        {
          'from' => '0xfrom',
          'to' => '0xto',
          'input' => '0xdata',
          'value' => '0x0'
        }
      end

      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction)
        stub_rpc_request_error(
          'eth_call',
          [{
            from: '0xfrom',
            to: '0xto',
            data: '0xdata',
            value: '0x0'
          }, 1206],
          -32_000,
          'execution reverted: Insufficient funds'
        )
      end

      it 'extracts revert reason from error message' do
        receipt_data = {
          'transactionHash' => tx_hash,
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        result = decoder.decode_from_receipt(receipt)
        expect(result).to eq('Insufficient funds')
      end
    end

    context 'when receipt does not have revertReason and eth_call fails with revert' do
      let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }
      let(:transaction) do
        {
          'from' => '0xfrom',
          'to' => '0xto',
          'input' => '0xdata',
          'value' => '0x0'
        }
      end

      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction)
        stub_rpc_request_error(
          'eth_call',
          [{
            from: '0xfrom',
            to: '0xto',
            data: '0xdata',
            value: '0x0'
          }, 1206],
          -32_000,
          'revert Custom error message'
        )
      end

      it 'extracts revert reason from error message' do
        receipt_data = {
          'transactionHash' => tx_hash,
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        result = decoder.decode_from_receipt(receipt)
        expect(result).to eq('Custom error message')
      end
    end

    context 'when receipt does not have revertReason and eth_call fails with generic error' do
      let(:tx_hash) { '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef' }
      let(:transaction) do
        {
          'from' => '0xfrom',
          'to' => '0xto',
          'input' => '0xdata',
          'value' => '0x0'
        }
      end

      before do
        stub_rpc_request('eth_getTransactionByHash', [tx_hash], transaction)
        stub_rpc_request_error(
          'eth_call',
          [{
            from: '0xfrom',
            to: '0xto',
            data: '0xdata',
            value: '0x0'
          }, 1206],
          -32_000,
          'Some generic error'
        )
      end

      it 'returns the full error message' do
        receipt_data = {
          'transactionHash' => tx_hash,
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        result = decoder.decode_from_receipt(receipt)
        expect(result).to eq('Some generic error')
      end
    end

    context 'when client is not provided' do
      let(:decoder) { described_class.new }

      it 'raises ArgumentError' do
        receipt_data = {
          'transactionHash' => '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
          'blockNumber' => '0x4b7',
          'status' => '0x0',
          'gasUsed' => '0x5208'
        }
        receipt = CryptoWalletTool::TransactionDebugger::Receipt.new(receipt_data)
        expect do
          decoder.decode_from_receipt(receipt)
        end.to raise_error(ArgumentError, 'Client is required for simulation')
      end
    end
  end

  private

  def stub_rpc_request(method, params, result)
    stub_request(:post, 'http://localhost:8545')
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

  def stub_rpc_request_error(method, params, code, message)
    stub_request(:post, 'http://localhost:8545')
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
          error: {
            code: code,
            message: message
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end
