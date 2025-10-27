# frozen_string_literal: true

require_relative 'crypto_wallet_tool/version'

module CryptoWalletTool
  class Error < StandardError; end
  # Your code goes here...
end

require_relative 'crypto_wallet_tool/converter'
require_relative 'crypto_wallet_tool/client'
