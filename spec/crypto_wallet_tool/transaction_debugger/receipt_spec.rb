# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::TransactionDebugger::Receipt do
  let(:receipt_data) do
    {
      'transactionHash' => '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
      'blockNumber' => '0x4b7',
      'status' => '0x1',
      'gasUsed' => '0x5208'
    }
  end

  let(:receipt) { described_class.new(receipt_data) }

  describe '#initialize' do
    it 'stores the raw data' do
      expect(receipt.raw_data).to eq(receipt_data)
    end
  end

  describe '#transaction_hash' do
    it 'returns the transaction hash' do
      expect(receipt.transaction_hash).to eq('0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef')
    end
  end

  describe '#status' do
    context 'when status is 0x1' do
      it 'returns :success' do
        expect(receipt.status).to eq(:success)
      end
    end

    context 'when status is 0x0' do
      let(:receipt_data) { { 'status' => '0x0' } }

      it 'returns :failed' do
        expect(receipt.status).to eq(:failed)
      end
    end

    context 'when status is unknown' do
      let(:receipt_data) { { 'status' => '0x2' } }

      it 'returns :unknown' do
        expect(receipt.status).to eq(:unknown)
      end
    end

    context 'when status is nil' do
      let(:receipt_data) { {} }

      it 'returns :unknown' do
        expect(receipt.status).to eq(:unknown)
      end
    end
  end

  describe '#success?' do
    context 'when transaction succeeded' do
      it 'returns true' do
        expect(receipt.success?).to be true
      end
    end

    context 'when transaction failed' do
      let(:receipt_data) { { 'status' => '0x0' } }

      it 'returns false' do
        expect(receipt.success?).to be false
      end
    end
  end

  describe '#failed?' do
    context 'when transaction succeeded' do
      it 'returns false' do
        expect(receipt.failed?).to be false
      end
    end

    context 'when transaction failed' do
      let(:receipt_data) { { 'status' => '0x0' } }

      it 'returns true' do
        expect(receipt.failed?).to be true
      end
    end
  end

  describe '#block_number' do
    it 'converts hex block number to integer' do
      expect(receipt.block_number).to eq(1207)
    end

    context 'when block number is nil' do
      let(:receipt_data) { {} }

      it 'returns nil' do
        expect(receipt.block_number).to be_nil
      end
    end
  end

  describe '#gas_used' do
    it 'converts hex gas used to integer' do
      expect(receipt.gas_used).to eq(21_000)
    end

    context 'when gas used is nil' do
      let(:receipt_data) { {} }

      it 'returns nil' do
        expect(receipt.gas_used).to be_nil
      end
    end
  end
end
