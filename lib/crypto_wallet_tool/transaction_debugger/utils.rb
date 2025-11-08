# frozen_string_literal: true

module CryptoWalletTool
  module TransactionDebugger
    # Utility module for common transaction debugger operations
    module Utils
      # Converts a hexadecimal string to an integer
      # @param hex_string [String, nil] Hexadecimal string (e.g., '0x10')
      # @return [Integer, nil] Decimal integer or nil if input is nil
      def hex_to_int(hex_string)
        return nil if hex_string.nil?

        hex_string.to_i(16)
      end
    end
  end
end
