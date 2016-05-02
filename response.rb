require 'amazon/ecs'
require 'shorturl'

class Response
  def initialize
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
      options[:AWS_secret_key]    = ENV['AMAZON_SECRET_KEY']
      options[:associate_tag]     = ENV['AMAZON_ASSOCIATE_TAG']
    end
    @amz = Amazon::Ecs
  end

  def search_amazon_book(word)
      res = @amz.item_search(word, :country => 'jp')

      first = res.items.first

      first.get('Title') + "\n" + ShortURL.shorten(first.get("DetailPageURL"))
  end
end
