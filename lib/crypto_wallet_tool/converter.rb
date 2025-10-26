# frozen_string_literal: true

module CryptoWalletTool
  # A simple converter class that provides various input transformation methods
  class Converter
    # Helper method to validate string input
    # @param input [Object] The input to validate
    # @raise [ArgumentError] if input is not a string
    def self.validate_string_input(input)
      raise ArgumentError, 'Input must be a string' unless input.is_a?(String)
    end

    # Helper method to validate array input
    # @param input [Object] The input to validate
    # @raise [ArgumentError] if input is not an array
    def self.validate_array_input(input)
      raise ArgumentError, 'Input must be an array' unless input.is_a?(Array)
    end

    private_class_method :validate_string_input, :validate_array_input
    # Convert text to uppercase
    # @param input [String] The input text to convert
    # @return [String] The converted uppercase text
    def self.to_uppercase(input)
      validate_string_input(input)

      input.upcase
    end

    # Convert text to lowercase
    # @param input [String] The input text to convert
    # @return [String] The converted lowercase text
    def self.to_lowercase(input)
      validate_string_input(input)

      input.downcase
    end

    # Reverse the input text
    # @param input [String] The input text to reverse
    # @return [String] The reversed text
    def self.reverse(input)
      validate_string_input(input)

      input.reverse
    end

    # Convert text to title case (capitalize each word)
    # @param input [String] The input text to convert
    # @return [String] The converted title case text
    def self.to_title_case(input)
      validate_string_input(input)

      input.split.map(&:capitalize).join(' ')
    end

    # Convert text to snake_case
    # @param input [String] The input text to convert
    # @return [String] The converted snake_case text
    def self.to_snake_case(input)
      validate_string_input(input)

      input.gsub(/([A-Z])/, '_\1').downcase.gsub(/^_/, '')
    end

    # Convert text to camelCase
    # @param input [String] The input text to convert
    # @return [String] The converted camelCase text
    def self.to_camel_case(input)
      validate_string_input(input)

      words = input.split(/[_\s-]/)
      return '' if words.empty?

      words.first.downcase + words.drop(1).map(&:capitalize).join
    end

    # Remove all whitespace from input
    # @param input [String] The input text to process
    # @return [String] The text with all whitespace removed
    def self.remove_whitespace(input)
      validate_string_input(input)

      input.gsub(/\s+/, '')
    end

    # Convert string to array of characters
    # @param input [String] The input text to convert
    # @return [Array<String>] Array of characters
    def self.to_char_array(input)
      validate_string_input(input)

      input.chars
    end

    # Convert array back to string
    # @param input [Array] The input array to convert
    # @return [String] The joined string
    def self.array_to_string(input)
      validate_array_input(input)

      input.join
    end

    # Apply multiple transformations in sequence
    # @param input [String] The input text to transform
    # @param transformations [Array<Symbol>] Array of transformation methods
    # @return [String] The final transformed text
    def self.transform(input, transformations)
      validate_string_input(input)
      validate_array_input(transformations)

      transformations.reduce(input.dup) do |result, method|
        send(method, result)
      end
    end
  end
end
