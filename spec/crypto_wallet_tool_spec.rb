# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool do
  it 'has a version number' do
    expect(CryptoWalletTool::VERSION).not_to be_nil
  end

  it 'has a valid version format' do
    expect(CryptoWalletTool::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
