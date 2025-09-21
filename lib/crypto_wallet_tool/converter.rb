# frozen_string_literal: true

module CryptoWalletTool
  # A simple converter class that provides various input transformation methods
  class Converter
    # Convert text to uppercase
    # @param input [String] The input text to convert
    # @return [String] The converted uppercase text
    def self.to_uppercase(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.upcase
    end

    # Convert text to lowercase
    # @param input [String] The input text to convert
    # @return [String] The converted lowercase text
    def self.to_lowercase(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.downcase
    end

    # Reverse the input text
    # @param input [String] The input text to reverse
    # @return [String] The reversed text
    def self.reverse(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.reverse
    end

    # Convert text to title case (capitalize each word)
    # @param input [String] The input text to convert
    # @return [String] The converted title case text
    def self.to_title_case(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.split.map(&:capitalize).join(" ")
    end

    # Convert text to snake_case
    # @param input [String] The input text to convert
    # @return [String] The converted snake_case text
    def self.to_snake_case(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.gsub(/([A-Z])/, '_\1').downcase.gsub(/^_/, '')
    end

    # Convert text to camelCase
    # @param input [String] The input text to convert
    # @return [String] The converted camelCase text
    def self.to_camel_case(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      words = input.split(/[_\s-]/)
      words.first.downcase + words[1..-1].map(&:capitalize).join
    end

    # Remove all whitespace from input
    # @param input [String] The input text to process
    # @return [String] The text with all whitespace removed
    def self.remove_whitespace(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.gsub(/\s+/, '')
    end

    # Convert string to array of characters
    # @param input [String] The input text to convert
    # @return [Array<String>] Array of characters
    def self.to_char_array(input)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      
      input.chars
    end

    # Convert array back to string
    # @param input [Array] The input array to convert
    # @return [String] The joined string
    def self.array_to_string(input)
      raise ArgumentError, "Input must be an array" unless input.is_a?(Array)
      
      input.join
    end

    # Apply multiple transformations in sequence
    # @param input [String] The input text to transform
    # @param transformations [Array<Symbol>] Array of transformation methods
    # @return [String] The final transformed text
    def self.transform(input, transformations)
      raise ArgumentError, "Input must be a string" unless input.is_a?(String)
      raise ArgumentError, "Transformations must be an array" unless transformations.is_a?(Array)
      
      result = input.dup
      transformations.each do |method|
        result = send(method, result)
      end
      result
    end
  end
end
