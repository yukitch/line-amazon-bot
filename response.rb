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
      res = Amazon::Ecs.item_search(word, {:country => 'jp', :response_group => 'Medium'})

      if res.total_pages == 0
        return 'お探しの書籍は見つかりませんでした。。'
      end

      book = res.items.first
      title = book.get('ItemAttributes/Title')
      message = title + "\n\n" + '通常版: ' + ShortURL.shorten(book.get("DetailPageURL"))

      res = Amazon::Ecs.item_search(title, {:country => 'jp', :search_index => 'KindleStore'})
      if res.total_pages != 0
        message += "\n" + 'kindle版: ' + ShortURL.shorten(res.items.first.get("DetailPageURL"))
      end
      message
  end
end
