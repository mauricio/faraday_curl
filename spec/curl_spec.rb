require 'spec_helper'
require 'faraday'
require 'faraday_middleware'
require 'faraday_curl'
require 'faraday/request/url_encoded'

Faraday::Request.register_middleware( :url_encoded => Faraday::Request::UrlEncoded )

describe Faraday::Curl::Middleware do

  let(:version) { "-H 'User-Agent: Faraday v0.9.0'" }

  def create_connection( *request_middlewares )
    Faraday.new( :url => 'http://example.com' ) do |b|
      request_middlewares.each do |middleware|
        b.request middleware
      end
      b.request :curl
      b.adapter :test do |stub|
        ['get', 'post', 'put', 'head'].each do |method|
          stub.send( method, '/echo') do |env|
            posted_as = env[:request_headers]['Content-Type']
            [200, {'Content-Type' => posted_as}, env[:body]]
          end
        end
      end
    end
  end

  def match_command( response, method, *parts )
    expect(response.env[:curl_command]).to eq(["curl", "-v", "-X #{method}", version] + parts)
  end

  it 'should correctly render a GET request command' do
    connection = create_connection
    response = connection.get( "/echo", :name => 'some person' )
    match_command(response, "GET", '"http://example.com/echo?name=some+person"')
  end

  it 'should render a JSON for a http POST request' do
    connection = create_connection :json
    response = connection.post("/echo", :name => 'some person', :some_other => 'me')
    match_command(response, "POST", "-H 'Content-Type: application/json'", "-d '{\"name\":\"some person\",\"some_other\":\"me\"}'", "\"http://example.com/echo\"")
  end

  it 'should render the URL encoded params for the POST request' do
    connection = create_connection :url_encoded
    response = connection.put( "/echo", :name => ['john', 'doe'], :age => 50 )
    match_command(response, "PUT", "-H 'Content-Type: application/x-www-form-urlencoded'", "-d 'age=50&name%5B%5D=john&name%5B%5D=doe'", '"http://example.com/echo"')
  end

end