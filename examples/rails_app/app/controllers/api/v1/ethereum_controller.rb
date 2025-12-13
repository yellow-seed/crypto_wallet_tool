class Api::V1::EthereumController < ApplicationController
  before_action :initialize_client

  # POST /api/v1/ethereum/transaction
  def transaction
    tx_hash = params.require(:transaction_hash)
    result = @client.eth_get_transaction_by_hash(tx_hash)
    render json: result
  rescue CryptoWalletTool::TransactionNotFoundError => e
    render json: { error: e.message }, status: :not_found
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code }, status: :bad_gateway
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/ethereum/receipt
  def receipt
    tx_hash = params.require(:transaction_hash)
    result = @client.eth_get_transaction_receipt(tx_hash)
    render json: result
  rescue CryptoWalletTool::TransactionNotFoundError => e
    render json: { error: e.message }, status: :not_found
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code }, status: :bad_gateway
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/ethereum/block_number
  def block_number
    result = @client.eth_block_number
    render json: { block_number: result }
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code }, status: :bad_gateway
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/ethereum/call
  def call
    call_params = params.require(:call).permit(:to, :from, :data, :gas, :gasPrice, :value)
    block = params[:block] || 'latest'
    
    result = @client.eth_call(call_params.to_h, block)
    render json: { result: result }
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code }, status: :bad_gateway
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def initialize_client
    rpc_url = ENV.fetch('ETHEREUM_RPC_URL', nil)
    
    if rpc_url.nil? || rpc_url.empty?
      render json: { 
        error: 'ETHEREUM_RPC_URL environment variable is not set. Please configure an Ethereum RPC endpoint.' 
      }, status: :service_unavailable
      return
    end

    @client = CryptoWalletTool::Client.new(rpc_url)
  rescue StandardError => e
    render json: { error: "Failed to initialize Ethereum client: #{e.message}" }, status: :internal_server_error
  end
end
