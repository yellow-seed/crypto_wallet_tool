# frozen_string_literal: true

class Api::V1::EthereumController < ApplicationController
  def transaction
    tx_hash = params.require(:tx_hash)
    transaction = client.eth_get_transaction_by_hash(tx_hash)

    render json: { transaction: transaction }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue CryptoWalletTool::TransactionNotFoundError => e
    render json: { error: e.message }, status: :not_found
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code, data: e.data }, status: :bad_gateway
  end

  def block
    block_number = params.fetch(:block_number, "latest")
    full_transactions = ActiveModel::Type::Boolean.new.cast(params.fetch(:full_transactions, false))
    block = client.eth_get_block_by_number(block_number, full_transactions)

    render json: { block: block }
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code, data: e.data }, status: :bad_gateway
  end

  def balance
    address = params.require(:address)
    block = params.fetch(:block, "latest")
    balance = client.eth_get_balance(address, block)

    render json: { balance: balance }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code, data: e.data }, status: :bad_gateway
  end

  def block_number
    block_number = client.eth_block_number

    render json: { block_number: block_number }
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code, data: e.data }, status: :bad_gateway
  end

  def call
    call_params = params.require(:call)
    block = params.fetch(:block, "latest")
    result = client.eth_call(call_params, block)

    render json: { result: result }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue CryptoWalletTool::RPCError => e
    render json: { error: e.message, code: e.code, data: e.data }, status: :bad_gateway
  end

  private

  def client
    CryptoWalletTool::Client.new(ENV.fetch("ETHEREUM_RPC_URL", "http://localhost:8545"))
  end
end
