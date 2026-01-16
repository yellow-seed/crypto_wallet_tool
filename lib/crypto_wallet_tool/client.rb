# frozen_string_literal: true

require 'faraday'
require 'json'

module CryptoWalletTool
  # Custom exception classes
  class RPCError < Error
    attr_reader :code, :message, :data

    def initialize(code, message, data = nil)
      @code = code
      @message = message
      @data = data
      super("RPC Error #{code}: #{message}")
    end
  end

  class TransactionNotFoundError < Error; end

  # Ethereum JSON-RPC client for communicating with Ethereum nodes
  class Client
    attr_reader :url

    def initialize(url)
      @url = url
      @connection = Faraday.new(url: url) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    # Get transaction receipt by transaction hash
    # @param tx_hash [String] Transaction hash (0x-prefixed hex string)
    # @return [Hash] Transaction receipt data
    # @raise [TransactionNotFoundError] if transaction is not found
    def eth_get_transaction_receipt(tx_hash)
      response = rpc_call('eth_getTransactionReceipt', [tx_hash])
      raise TransactionNotFoundError, "Transaction #{tx_hash} not found" if response.nil?

      response
    end

    # Get transaction by hash
    # @param tx_hash [String] Transaction hash (0x-prefixed hex string)
    # @return [Hash] Transaction data
    # @raise [TransactionNotFoundError] if transaction is not found
    def eth_get_transaction_by_hash(tx_hash)
      response = rpc_call('eth_getTransactionByHash', [tx_hash])
      raise TransactionNotFoundError, "Transaction #{tx_hash} not found" if response.nil?

      response
    end

    # Execute a call (read-only operation) on the Ethereum blockchain
    # @param params [Hash] Call parameters (to, from, data, etc.)
    # @param block [String] Block number or tag (e.g., 'latest', 'earliest', 'pending')
    # @return [String] Result of the call
    def eth_call(params, block = 'latest')
      rpc_call('eth_call', [params, block])
    end

    # Get the current block number
    # @return [Integer] Current block number
    def eth_block_number
      hex_result = rpc_call('eth_blockNumber', [])
      hex_result.to_i(16)
    end

    # Get block details by block number or tag
    # @param block_number [Integer, String] Block number (integer or 0x hex) or tag (latest, earliest, pending)
    # @param full_transactions [Boolean] Whether to return full transaction objects
    # @return [Hash] Block data
    def eth_get_block_by_number(block_number, full_transactions = false)
      normalized_block_number = normalize_block_number(block_number)
      rpc_call('eth_getBlockByNumber', [normalized_block_number, full_transactions])
    end

    # Get the balance of an address
    # @param address [String] Address to query (0x-prefixed hex string)
    # @param block [String] Block number or tag (default: 'latest')
    # @return [String] Balance in wei as a hex string
    def eth_get_balance(address, block = 'latest')
      rpc_call('eth_getBalance', [address, block])
    end

    private

    # Make a JSON-RPC 2.0 call
    # @param method [String] RPC method name
    # @param params [Array] Method parameters
    # @return [Object] Result from the RPC response
    # @raise [RPCError] if the RPC call returns an error
    def rpc_call(method, params)
      request_body = {
        jsonrpc: '2.0',
        method: method,
        params: params,
        id: generate_id
      }

      response = @connection.post do |req|
        req.body = request_body
      end

      validate_response(response)
    end

    # Validate RPC response and extract result
    # @param response [Faraday::Response] HTTP response
    # @return [Object] Result from the RPC response
    # @raise [RPCError] if the response contains an error
    def validate_response(response)
      raise RPCError.new(-1, 'HTTP request failed', response.status) unless response.success?

      body = response.body
      raise RPCError.new(-1, 'Invalid JSON-RPC response', body) unless body.is_a?(Hash)

      if body['error']
        error = body['error']
        raise RPCError.new(error['code'], error['message'], error['data'])
      end

      body['result']
    end

    # Generate a unique request ID
    # @return [Integer] Request ID
    def generate_id
      (Time.now.to_f * 1000).to_i
    end

    # Normalize block number input for JSON-RPC calls
    # @param block_number [Integer, String] Block number or tag
    # @return [String] Normalized block number or tag
    def normalize_block_number(block_number)
      return "0x#{block_number.to_s(16)}" if block_number.is_a?(Integer)

      block_number
    end
  end
end
