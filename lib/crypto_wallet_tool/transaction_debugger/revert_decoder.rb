# frozen_string_literal: true

module CryptoWalletTool
  module TransactionDebugger
    # Decoder for transaction revert reasons
    class RevertDecoder
      ERROR_STRING_SIGNATURE = '0x08c379a0'
      PANIC_SIGNATURE = '0x4e487b71'

      PANIC_CODES = {
        0x01 => 'Assertion error',
        0x11 => 'Arithmetic operation underflowed or overflowed',
        0x12 => 'Division or modulo by zero',
        0x21 => 'Enum conversion error',
        0x31 => 'Pop on empty array',
        0x32 => 'Array index out of bounds',
        0x41 => 'Out of memory',
        0x51 => 'Invalid internal function call'
      }.freeze

      def initialize(client: nil)
        @client = client
      end

      def decode_from_receipt(receipt)
        return nil if receipt.success?

        if receipt.raw_data['revertReason']
          decode_revert_data(receipt.raw_data['revertReason'])
        else
          decode_from_simulation(receipt)
        end
      end

      def decode_revert_data(data)
        return nil if data.nil? || data == '0x'

        hex_data = normalize_hex(data)
        signature = extract_signature(hex_data)

        decode_by_signature(signature, hex_data)
      end

      private

      def normalize_hex(data)
        data.start_with?('0x') ? data[2..] : data
      end

      def extract_signature(hex_data)
        "0x#{hex_data[0..7]}"
      end

      def decode_by_signature(signature, hex_data)
        case signature
        when ERROR_STRING_SIGNATURE
          decode_error_string(hex_data)
        when PANIC_SIGNATURE
          decode_panic(hex_data)
        else
          "Unknown error (signature: #{signature})"
        end
      end

      def decode_error_string(hex_data)
        data_hex = hex_data[8..]
        data_binary = [data_hex].pack('H*')
        length = data_binary[32..63].unpack1('H*').to_i(16)
        string_data = data_binary[64, length]
        string_data.force_encoding('UTF-8')
      rescue StandardError => e
        "Failed to decode error string: #{e.message}"
      end

      def decode_panic(hex_data)
        panic_code = hex_data[8..71].to_i(16)
        description = PANIC_CODES[panic_code] || 'Unknown panic code'
        "Panic: #{description} (code: 0x#{panic_code.to_s(16)})"
      end

      def decode_from_simulation(receipt)
        raise ArgumentError, 'Client is required for simulation' if @client.nil?

        tx_data = @client.eth_get_transaction_by_hash(receipt.transaction_hash)

        call_params = {
          from: tx_data['from'],
          to: tx_data['to'],
          data: tx_data['input'],
          value: tx_data['value']
        }

        @client.eth_call(call_params, receipt.block_number - 1)
        nil
      rescue CryptoWalletTool::RPCError => e
        extract_revert_from_error(e.message)
      end

      def extract_revert_from_error(error_message)
        match = error_message.match(/(?:execution reverted:?\s*|revert\s+)(.+)/i)
        match ? match[1].strip : error_message
      end
    end
  end
end
