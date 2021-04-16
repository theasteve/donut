class SlackAdapter
  attr_accessor :client

  def initialize
    @client = Slack::Web::Client.new
  end

  def views_open(args = {})
    @client.views_open(trigger_id: args[:trigger_id], view: args[:view])
  end

  def chat_message_to_user(args = {})
    channel_id = get_channel_id(user: args[:users])
    chat_post_message(channel: channel_id, text: args[:text])
  end

  def chat_post_message(args = {})
    @client.chat_postMessage(channel: args[:channel], text: args[:text])
  end

  def get_channel_id(user:)
    @client.conversations_open(users: user).channel.id
  end
end
