# frozen_string_literal: true

module CryptoWalletTool
  module TransactionDebugger
    # Represents a transaction from the Ethereum blockchain
    class Transaction
      attr_reader :raw_data

      def initialize(raw_data)
        @raw_data = raw_data
      end

      def hash
        raw_data['hash']
      end

      def from
        raw_data['from']
      end

      def to
        raw_data['to']
      end

      def value
        hex_to_int(raw_data['value'])
      end

      def gas
        hex_to_int(raw_data['gas'])
      end

      def gas_price
        hex_to_int(raw_data['gasPrice'])
      end

      def eip1559?
        !raw_data['maxFeePerGas'].nil?
      end

      private

      def hex_to_int(hex_string)
        return nil if hex_string.nil?

        hex_string.to_i(16)
      end
    end
  end
end
