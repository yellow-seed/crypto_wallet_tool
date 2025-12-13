class Api::V1::ConverterController < ApplicationController
  # POST /api/v1/converter/uppercase
  def uppercase
    text = params.require(:text)
    result = CryptoWalletTool::Converter.to_uppercase(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/converter/lowercase
  def lowercase
    text = params.require(:text)
    result = CryptoWalletTool::Converter.to_lowercase(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/converter/reverse
  def reverse
    text = params.require(:text)
    result = CryptoWalletTool::Converter.reverse(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/converter/title_case
  def title_case
    text = params.require(:text)
    result = CryptoWalletTool::Converter.to_title_case(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/converter/snake_case
  def snake_case
    text = params.require(:text)
    result = CryptoWalletTool::Converter.to_snake_case(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /api/v1/converter/camel_case
  def camel_case
    text = params.require(:text)
    result = CryptoWalletTool::Converter.to_camel_case(text)
    render json: { input: text, output: result }
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
