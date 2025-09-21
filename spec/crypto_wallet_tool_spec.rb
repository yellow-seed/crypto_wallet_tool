# frozen_string_literal: true

require "spec_helper"

RSpec.describe CryptoWalletTool do
  it "has a version number" do
    expect(CryptoWalletTool::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
