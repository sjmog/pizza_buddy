require 'data_mapper'
require 'net/http'
require 'uri'
require 'json'

class User
  AMAZON_API_URL = "https://api.amazon.com/user/profile".freeze
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :access_token, String

  def self.authenticate(access_token, client = Net::HTTP)
    uri = URI.parse("#{ AMAZON_API_URL }?access_token=#{ access_token }")
    first_name = JSON.parse(client.get_response(uri))["body"]["profile"]["name"].split(" ").first
    first_or_create(name: first_name, access_token: access_token)
  end
end