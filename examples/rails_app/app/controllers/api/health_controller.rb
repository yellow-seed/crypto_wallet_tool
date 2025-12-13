class Api::HealthController < ApplicationController
  def index
    # Test crypto_wallet_tool gem integration with error handling
    begin
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
    rescue StandardError => e
      render json: {
        status: "error",
        message: "Error testing crypto_wallet_tool gem",
        error: e.message
      }, status: :internal_server_error
    end
  end
end
