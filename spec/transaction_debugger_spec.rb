# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransactionDebugger do
  it 'has a version number' do
    expect(TransactionDebugger::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'allows configuration' do
      TransactionDebugger.configure do |config|
        config.rpc_url = 'https://test.rpc.url'
        config.chain_id = 5
      end

      expect(TransactionDebugger.configuration.rpc_url).to eq('https://test.rpc.url')
      expect(TransactionDebugger.configuration.chain_id).to eq(5)
    end
  end

  describe '.analyze' do
    it 'analyzes a transaction' do
      result = TransactionDebugger.analyze('0x1234567890abcdef')
      expect(result).to be_a(Hash)
      expect(result[:tx_hash]).to eq('0x1234567890abcdef')
    end
  end

  describe TransactionDebugger::Configuration do
    it 'has default rpc_url' do
      config = TransactionDebugger::Configuration.new
      expect(config.rpc_url).to eq('https://mainnet.infura.io/v3/')
    end

    it 'has default chain_id' do
      config = TransactionDebugger::Configuration.new
      expect(config.chain_id).to eq(1)
    end

    it 'reads rpc_url from environment variable' do
      ENV['ETHEREUM_RPC_URL'] = 'https://custom.rpc.url'
      config = TransactionDebugger::Configuration.new
      expect(config.rpc_url).to eq('https://custom.rpc.url')
      ENV.delete('ETHEREUM_RPC_URL')
    end
  end

  describe TransactionDebugger::Client do
    it 'initializes with configuration' do
      TransactionDebugger.configure do |config|
        config.rpc_url = 'https://test.rpc.url'
        config.chain_id = 5
      end

      client = TransactionDebugger::Client.new
      expect(client.rpc_url).to eq('https://test.rpc.url')
      expect(client.chain_id).to eq(5)
    end

    it 'can override configuration' do
      client = TransactionDebugger::Client.new(rpc_url: 'https://override.url', chain_id: 10)
      expect(client.rpc_url).to eq('https://override.url')
      expect(client.chain_id).to eq(10)
    end
  end

  describe TransactionDebugger::Analyzer do
    it 'analyzes a transaction' do
      analyzer = TransactionDebugger::Analyzer.new
      result = analyzer.analyze('0xabc123')
      expect(result).to be_a(Hash)
      expect(result[:tx_hash]).to eq('0xabc123')
    end
  end
end
