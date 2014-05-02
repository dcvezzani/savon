require 'savon'
require 'httpclient'
require 'debugger'

class SavonHttpsClient
  attr_reader :client, :ssl_options

  def initialize
    @client = nil

    @ssl_options = {
    ssl_version: :SSLv3, 
    ssl_verify_mode: :none, 
    ssl_cert_key_file: "some.key", 
    ssl_cert_file: "some.pub", 
    ssl_ca_cert_file: "some-truststore.pem", 
    ssl_cert_key_password: "some-password"
    }
  end


  def send_file(body_content)
    File.open("some.wsdl", "r"){|f|
      options = ssl_options.merge({wsdl: f})
      @client = Savon.client(options)
    }

    puts client.operations

    call_options = {body_content: body_content}
    response = client.call(:soap_operation, call_options)
    puts response.body
    puts response.body[:soap_response][:response_code]
  end
end

SavonHttpsClient.new().send_file("my-request.xml")
