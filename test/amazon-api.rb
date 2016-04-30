require 'amazon/ecs'
require 'dotenv'
require 'pp'
require 'pry'

Dotenv.load
Amazon::Ecs.debug = true

Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
  options[:AWS_secret_key]    = ENV['AMAZON_SECRET_KEY']
  options[:associate_tag]     = ENV['AMAZON_ASSOCIATE_TAG']
end

res = Amazon::Ecs.item_search('', {
    :country  => 'jp',
})

binding.pry
