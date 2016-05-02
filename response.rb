require 'amazon/ecs'
require 'shorturl'
require 'dotenv'

class Response
  def initialize
    Dotenv.load
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
      options[:AWS_secret_key]    = ENV['AMAZON_SECRET_KEY']
      options[:associate_tag]     = ENV['AMAZON_ASSOCIATE_TAG']
    end
  end

  def search_amazon_book(word)
      res = Amazon::Ecs.item_search(word, :country => 'jp')

      if res.total_pages == 0
        return 'not found'
      end

      first = res.items.first

      first.get('ItemAttributes/Title') + "\n" + ShortURL.shorten(first.get("DetailPageURL"))
  end
end
