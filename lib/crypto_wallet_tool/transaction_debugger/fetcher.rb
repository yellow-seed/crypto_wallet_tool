# frozen_string_literal: true

module CryptoWalletTool
  module TransactionDebugger
    # Fetches transaction and receipt data from the Ethereum blockchain
    class Fetcher
      def initialize(client: nil)
        @client = client || Client.new('http://localhost:8545')
      end

      def fetch_receipt(tx_hash)
        receipt_data = @client.eth_get_transaction_receipt(normalize_hash(tx_hash))
        Receipt.new(receipt_data)
      end

      def fetch_transaction(tx_hash)
        tx_data = @client.eth_get_transaction_by_hash(normalize_hash(tx_hash))
        Transaction.new(tx_data)
      end

      def fetch_both(tx_hash)
        {
          transaction: fetch_transaction(tx_hash),
          receipt: fetch_receipt(tx_hash)
        }
      end

      private

      def normalize_hash(tx_hash)
        tx_hash = tx_hash.strip
        tx_hash.start_with?('0x') ? tx_hash : "0x#{tx_hash}"
      end
    end
  end
end
