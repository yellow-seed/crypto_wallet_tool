# frozen_string_literal: true

require_relative 'transaction_debugger/version'
require_relative 'transaction_debugger/client'
require_relative 'transaction_debugger/analyzer'

module TransactionDebugger
  class Error < StandardError; end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :rpc_url, :chain_id

    def initialize
      @rpc_url = ENV['ETHEREUM_RPC_URL'] || 'https://mainnet.infura.io/v3/'
      @chain_id = 1
    end
  end

  def self.analyze(tx_hash)
    analyzer = Analyzer.new
    analyzer.analyze(tx_hash)
  end
end
