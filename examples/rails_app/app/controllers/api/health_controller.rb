class Api::HealthController < ApplicationController
  def index
    # Test crypto_wallet_tool gem integration
    sample_text = "hello world"
    transformed = CryptoWalletTool::Converter.to_uppercase(sample_text)
    
    render json: {
      status: "ok",
      message: "Rails app is running with crypto_wallet_tool gem",
      database: ActiveRecord::Base.connection.active? ? "connected" : "disconnected",
      gem_test: {
        input: sample_text,
        output: transformed
      }
    }
  end
end
