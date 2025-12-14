require 'swagger_helper'

RSpec.describe 'api/v1/converter', type: :request do
  path '/api/v1/converter/uppercase' do
    post('Convert text to uppercase') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to convert to uppercase'

      response(200, 'successful') do
        let(:text) { 'hello world' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['input']).to eq('hello world')
          expect(data['output']).to eq('HELLO WORLD')
        end
      end

      response(400, 'bad request') do
        let(:text) { nil }

        schema type: :object,
          properties: {
            error: { type: :string }
          }

        run_test!
      end
    end
  end

  path '/api/v1/converter/lowercase' do
    post('Convert text to lowercase') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to convert to lowercase'

      response(200, 'successful') do
        let(:text) { 'HELLO WORLD' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test!
      end
    end
  end

  path '/api/v1/converter/reverse' do
    post('Reverse text') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to reverse'

      response(200, 'successful') do
        let(:text) { 'hello' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['output']).to eq('olleh')
        end
      end
    end
  end

  path '/api/v1/converter/title_case' do
    post('Convert text to title case') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to convert to title case'

      response(200, 'successful') do
        let(:text) { 'hello world' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['output']).to eq('Hello World')
        end
      end
    end
  end

  path '/api/v1/converter/snake_case' do
    post('Convert text to snake_case') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to convert to snake_case'

      response(200, 'successful') do
        let(:text) { 'helloWorld' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['output']).to eq('hello_world')
        end
      end
    end
  end

  path '/api/v1/converter/camel_case' do
    post('Convert text to camelCase') do
      tags 'Converter'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :text, in: :query, type: :string, required: true, description: 'Text to convert to camelCase'

      response(200, 'successful') do
        let(:text) { 'hello_world' }

        schema type: :object,
          properties: {
            input: { type: :string },
            output: { type: :string }
          },
          required: [ "input", "output" ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['output']).to eq('helloWorld')
        end
      end
    end
  end
end
