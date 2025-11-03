# frozen_string_literal: true

require_relative 'utils'

module CryptoWalletTool
  module TransactionDebugger
    # Represents a transaction receipt from the Ethereum blockchain
    class Receipt
      include Utils

      attr_reader :raw_data

      def initialize(raw_data)
        @raw_data = raw_data
      end

      def transaction_hash
        raw_data['transactionHash']
      end

      def status
        case raw_data['status']
        when '0x1' then :success
        when '0x0' then :failed
        else :unknown
        end
      end

      def success?
        status == :success
      end

      def failed?
        status == :failed
      end

      def block_number
        hex_to_int(raw_data['blockNumber'])
      end

      def gas_used
        hex_to_int(raw_data['gasUsed'])
      end
    end
  end
end
