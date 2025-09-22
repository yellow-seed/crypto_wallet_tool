# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoWalletTool::Converter do
  describe '.to_uppercase' do
    it 'converts text to uppercase' do
      expect(described_class.to_uppercase('hello world')).to eq('HELLO WORLD')
    end

    it 'raises error for non-string input' do
      expect { described_class.to_uppercase(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.to_lowercase' do
    it 'converts text to lowercase' do
      expect(described_class.to_lowercase('HELLO WORLD')).to eq('hello world')
    end

    it 'raises error for non-string input' do
      expect { described_class.to_lowercase(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.reverse' do
    it 'reverses the input text' do
      expect(described_class.reverse('hello')).to eq('olleh')
    end

    it 'raises error for non-string input' do
      expect { described_class.reverse(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.to_title_case' do
    it 'converts text to title case' do
      expect(described_class.to_title_case('hello world')).to eq('Hello World')
    end

    it 'handles single word' do
      expect(described_class.to_title_case('hello')).to eq('Hello')
    end

    it 'raises error for non-string input' do
      expect { described_class.to_title_case(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.to_snake_case' do
    it 'converts camelCase to snake_case' do
      expect(described_class.to_snake_case('helloWorld')).to eq('hello_world')
    end

    it 'converts PascalCase to snake_case' do
      expect(described_class.to_snake_case('HelloWorld')).to eq('hello_world')
    end

    it 'handles already snake_case' do
      expect(described_class.to_snake_case('hello_world')).to eq('hello_world')
    end

    it 'raises error for non-string input' do
      expect { described_class.to_snake_case(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.to_camel_case' do
    it 'converts snake_case to camelCase' do
      expect(described_class.to_camel_case('hello_world')).to eq('helloWorld')
    end

    it 'converts kebab-case to camelCase' do
      expect(described_class.to_camel_case('hello-world')).to eq('helloWorld')
    end

    it 'converts space separated to camelCase' do
      expect(described_class.to_camel_case('hello world')).to eq('helloWorld')
    end

    it 'raises error for non-string input' do
      expect { described_class.to_camel_case(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.remove_whitespace' do
    it 'removes all whitespace from input' do
      expect(described_class.remove_whitespace('hello world')).to eq('helloworld')
    end

    it 'removes multiple spaces' do
      expect(described_class.remove_whitespace('hello   world')).to eq('helloworld')
    end

    it 'removes tabs and newlines' do
      expect(described_class.remove_whitespace('hello\tworld\n')).to eq('helloworld')
    end

    it 'raises error for non-string input' do
      expect { described_class.remove_whitespace(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.to_char_array' do
    it 'converts string to array of characters' do
      expect(described_class.to_char_array('hello')).to eq(['h', 'e', 'l', 'l', 'o'])
    end

    it 'handles empty string' do
      expect(described_class.to_char_array('')).to eq([])
    end

    it 'raises error for non-string input' do
      expect { described_class.to_char_array(123) }.to raise_error(ArgumentError, 'Input must be a string')
    end
  end

  describe '.array_to_string' do
    it 'converts array to string' do
      expect(described_class.array_to_string(['h', 'e', 'l', 'l', 'o'])).to eq('hello')
    end

    it 'handles empty array' do
      expect(described_class.array_to_string([])).to eq('')
    end

    it 'raises error for non-array input' do
      expect { described_class.array_to_string('hello') }.to raise_error(ArgumentError, 'Input must be an array')
    end
  end

  describe '.transform' do
    it 'applies multiple transformations in sequence' do
      result = described_class.transform('hello world', [:to_uppercase, :reverse])
      expect(result).to eq('DLROW OLLEH')
    end

    it 'applies snake_case and remove_whitespace' do
      result = described_class.transform('HelloWorld', [:to_snake_case, :remove_whitespace])
      expect(result).to eq('helloworld')
    end

    it 'raises error for non-string input' do
      expect { described_class.transform(123, [:to_uppercase]) }.to raise_error(ArgumentError, 'Input must be a string')
    end

    it 'raises error for non-array transformations' do
      expect { described_class.transform('hello', :to_uppercase) }.to raise_error(ArgumentError, 'Transformations must be an array')
    end
  end
end
