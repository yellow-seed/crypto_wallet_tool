# frozen_string_literal: true

require_relative 'utils'

module CryptoWalletTool
  module TransactionDebugger
    # Represents a transaction from the Ethereum blockchain
    class Transaction
      include Utils

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
    end
  end
end
