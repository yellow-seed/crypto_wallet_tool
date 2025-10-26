# frozen_string_literal: true

require_relative 'lib/crypto_wallet_tool/version'

Gem::Specification.new do |spec|
  spec.name = 'crypto_wallet_tool'
  spec.version = CryptoWalletTool::VERSION
  spec.authors = ['Your Name']
  spec.email = ['your.email@example.com']

  spec.summary = 'A simple Ruby gem for input transformation and conversion'
  spec.description = 'CryptoWalletTool provides various input transformation utilities for ' \
                     'text processing and data conversion.'
  spec.homepage = 'https://github.com/your-username/crypto_wallet_tool'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/your-username/crypto_wallet_tool'
  spec.metadata['changelog_uri'] = 'https://github.com/your-username/crypto_wallet_tool/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependencies for transaction_debugger
  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'thor', '~> 1.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
