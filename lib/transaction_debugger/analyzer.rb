# frozen_string_literal: true

module TransactionDebugger
  # Analyzer for transaction failures
  class Analyzer
    attr_reader :client

    def initialize(client: nil)
      @client = client || Client.new
    end

    def analyze(tx_hash)
      transaction = client.get_transaction(tx_hash)
      receipt = client.get_transaction_receipt(tx_hash)

      {
        tx_hash: tx_hash,
        transaction: transaction,
        receipt: receipt,
        analysis: 'Analysis placeholder'
      }
    end
  end
end
