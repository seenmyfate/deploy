require 'twitter'
module Deploy
  module Notification
    class Twitter

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::notification")
      end

      def call(env)
        tweet
        @app.call(env)
      end

      def tweet
        ::Twitter.configure do |config|
          config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
          config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
          config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
        end
        @logger.info "Notifying"
        @logger.info "Message: #{status}"
        ::Twitter.update(status)
      end

      def status
        "#{Time.now.strftime("%d/%m/%y %H:%M")}: All the things have been deployed".slice(0..139)
      end

      def recover(env)
        @logger.info 'recovering'
      end
    end
  end
end
