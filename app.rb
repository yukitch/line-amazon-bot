# Mostly taken from http://qiita.com/masuidrive/items/1042d93740a7a72242a3

require 'sinatra/base'
require 'json'
require 'rest-client'
require 'amazon/ecs'

class App < Sinatra::Base
  post '/callback' do
    params = JSON.parse(request.body.read)
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
      options[:AWS_secret_key]    = ENV['AMAZON_SECRET_KEY']
      options[:associate_tag]     = ENV['AMAZON_ASSOCIATE_TAG']
    end

    params['result'].each do |msg|

     res = Amazon::Ecs.item_search(msg['content']['text'], :country => 'jp')

      request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: {
          contentType: 1,
          toType: 1,
          text: res.items.first.get('DetailPageURL')
        }
      }

      endpoint_uri = 'https://trialbot-api.line.me/v1/events'
      content_json = request_content.to_json

      RestClient.proxy = ENV['FIXIE_URL'] if ENV['FIXIE_URL']
      RestClient.post(endpoint_uri, content_json, {
        'Content-Type'                 => 'application/json; charset=UTF-8',
        'X-Line-ChannelID'             => ENV["LINE_CHANNEL_ID"],
        'X-Line-ChannelSecret'         => ENV["LINE_CHANNEL_SECRET"],
        'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"],
      })
    end

    "OK"
  end
end

