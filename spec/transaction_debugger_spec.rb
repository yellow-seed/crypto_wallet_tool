# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransactionDebugger do
  # Reset configuration between tests to prevent state pollution
  after do
    described_class.instance_variable_set(:@configuration, nil)
  end

  it 'has a version number' do
    expect(TransactionDebugger::VERSION).not_to be_nil
  end

  describe '.configure' do
    it 'allows configuration' do
      described_class.configure do |config|
        config.rpc_url = 'https://test.rpc.url'
        config.chain_id = 5
      end

      expect(described_class.configuration.rpc_url).to eq('https://test.rpc.url')
      expect(described_class.configuration.chain_id).to eq(5)
    end
  end

  describe '.analyze' do
    it 'analyzes a transaction' do
      result = described_class.analyze('0x1234567890abcdef')
      expect(result).to be_a(Hash)
      expect(result[:tx_hash]).to eq('0x1234567890abcdef')
    end
  end

  describe TransactionDebugger::Configuration do
    it 'has default rpc_url' do
      config = described_class.new
      expect(config.rpc_url).to eq('https://mainnet.infura.io/v3/')
    end

    it 'has default chain_id' do
      config = described_class.new
      expect(config.chain_id).to eq(1)
    end

    it 'reads rpc_url from environment variable' do
      original_value = ENV['ETHEREUM_RPC_URL']
      begin
        ENV['ETHEREUM_RPC_URL'] = 'https://custom.rpc.url'
        config = described_class.new
        expect(config.rpc_url).to eq('https://custom.rpc.url')
      ensure
        if original_value
          ENV['ETHEREUM_RPC_URL'] = original_value
        else
          ENV.delete('ETHEREUM_RPC_URL')
        end
      end
    end
  end

  describe TransactionDebugger::Client do
    it 'initializes with configuration' do
      TransactionDebugger.configure do |config|
        config.rpc_url = 'https://test.rpc.url'
        config.chain_id = 5
      end

      client = described_class.new
      expect(client.rpc_url).to eq('https://test.rpc.url')
      expect(client.chain_id).to eq(5)
    end

    it 'can override configuration' do
      client = described_class.new(rpc_url: 'https://override.url', chain_id: 10)
      expect(client.rpc_url).to eq('https://override.url')
      expect(client.chain_id).to eq(10)
    end
  end

  describe TransactionDebugger::Analyzer do
    it 'analyzes a transaction' do
      analyzer = described_class.new
      result = analyzer.analyze('0xabc123')
      expect(result).to be_a(Hash)
      expect(result[:tx_hash]).to eq('0xabc123')
    end
  end
end
