class Api::V1::DebugController < ApplicationController
  before_action :initialize_client

  # POST /api/v1/debug/transaction
  def transaction
    tx_hash = params.require(:transaction_hash)
    
    fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new(client: @client)
    transaction = fetcher.fetch_transaction(tx_hash)
    
    render json: {
      hash: transaction.hash,
      from: transaction.from,
      to: transaction.to,
      value: transaction.value,
      gas: transaction.gas,
      gas_price: transaction.gas_price,
      eip1559: transaction.eip1559?,
      raw_data: transaction.raw_data
    }
  rescue CryptoWalletTool::TransactionNotFoundError => e
    render json: { error: e.message }, status: :not_found
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code }, status: :bad_gateway
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/debug/receipt
  def receipt
    tx_hash = params.require(:transaction_hash)
    
    fetcher = CryptoWalletTool::TransactionDebugger::Fetcher.new(client: @client)
    receipt = fetcher.fetch_receipt(tx_hash)
    
    render json: {
      transaction_hash: receipt.transaction_hash,
      status: receipt.status,
      success: receipt.success?,
      failed: receipt.failed?,
      block_number: receipt.block_number,
      gas_used: receipt.gas_used,
      raw_data: receipt.raw_data
    }
  rescue CryptoWalletTool::TransactionNotFoundError => e
    render json: { error: e.message }, status: :not_found
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
