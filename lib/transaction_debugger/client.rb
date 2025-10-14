# frozen_string_literal: true

module TransactionDebugger
  # Client for interacting with Ethereum RPC
  class Client
    attr_reader :rpc_url, :chain_id

    def initialize(rpc_url: nil, chain_id: nil)
      @rpc_url = rpc_url || TransactionDebugger.configuration.rpc_url
      @chain_id = chain_id || TransactionDebugger.configuration.chain_id
    end

    def get_transaction(tx_hash)
      # Placeholder for RPC call
      { tx_hash: tx_hash }
    end

    def get_transaction_receipt(tx_hash)
      # Placeholder for RPC call
      { tx_hash: tx_hash }
    end
  end
end
