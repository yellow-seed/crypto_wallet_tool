# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::TransactionDebugger::Transaction do
  let(:transaction_data) do
    {
      'hash' => '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
      'from' => '0xabcdef1234567890abcdef1234567890abcdef12',
      'to' => '0x1234567890abcdef1234567890abcdef12345678',
      'value' => '0xde0b6b3a7640000',
      'gas' => '0x5208',
      'gasPrice' => '0x3b9aca00'
    }
  end

  let(:transaction) { described_class.new(transaction_data) }

  describe '#initialize' do
    it 'stores the raw data' do
      expect(transaction.raw_data).to eq(transaction_data)
    end
  end

  describe '#hash' do
    it 'returns the transaction hash' do
      expect(transaction.hash).to eq('0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef')
    end
  end

  describe '#from' do
    it 'returns the sender address' do
      expect(transaction.from).to eq('0xabcdef1234567890abcdef1234567890abcdef12')
    end
  end

  describe '#to' do
    it 'returns the recipient address' do
      expect(transaction.to).to eq('0x1234567890abcdef1234567890abcdef12345678')
    end
  end

  describe '#value' do
    it 'converts hex value to integer' do
      expect(transaction.value).to eq(1_000_000_000_000_000_000)
    end

    context 'when value is nil' do
      let(:transaction_data) { {} }

      it 'returns nil' do
        expect(transaction.value).to be_nil
      end
    end
  end

  describe '#gas' do
    it 'converts hex gas to integer' do
      expect(transaction.gas).to eq(21_000)
    end

    context 'when gas is nil' do
      let(:transaction_data) { {} }

      it 'returns nil' do
        expect(transaction.gas).to be_nil
      end
    end
  end

  describe '#gas_price' do
    it 'converts hex gas price to integer' do
      expect(transaction.gas_price).to eq(1_000_000_000)
    end

    context 'when gas price is nil' do
      let(:transaction_data) { {} }

      it 'returns nil' do
        expect(transaction.gas_price).to be_nil
      end
    end
  end

  describe '#eip1559?' do
    context 'when maxFeePerGas is present' do
      let(:transaction_data) { { 'maxFeePerGas' => '0x77359400' } }

      it 'returns true' do
        expect(transaction.eip1559?).to be true
      end
    end

    context 'when maxFeePerGas is not present' do
      it 'returns false' do
        expect(transaction.eip1559?).to be false
      end
    end

    context 'when maxFeePerGas is nil' do
      let(:transaction_data) { { 'maxFeePerGas' => nil } }

      it 'returns false' do
        expect(transaction.eip1559?).to be false
      end
    end
  end
end
