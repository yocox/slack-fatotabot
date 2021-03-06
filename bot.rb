require_relative "secret"
require_relative "db_helpers"
require "slack-ruby-bot"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

SlackRubyBot.configure do |config|
  config.aliases = ['肥宅霸']
end

class Fatotabot < SlackRubyBot::Bot
  match /肥宅霸\s*set (?<weight>\d+(\.\d+)?)$/i do |client, data, match|
    if DBHelper.insert_weight(data.user, match[:weight])
      client.say(channel: data.channel, text: "<@#{data.user}> 你現在重 #{match[:weight]}kg，不想讓人看到的話可以私訊")
    else
      client.say(channel: data.channel, text: "啊啊啊我壞掉惹")
    end
  end

  match /肥宅霸\s*\+(?<weight>\d+(\.\d+)?)$/i do |client, data, match|
    if DBHelper.incr_weight(data.user, match[:weight])
      client.say(channel: data.channel, text: "<@#{data.user}> 你怎麼又胖 #{match[:weight]}kg 惹")
    else
      client.say(channel: data.channel, text: "啊啊啊我壞掉惹")
    end
  end

  match /肥宅霸\s*\-(?<weight>\d+(\.\d+)?)$/i do |client, data, match|
    if DBHelper.decr_weight(data.user, match[:weight])
      client.say(channel: data.channel, text: "<@#{data.user}> 你瘦了 #{match[:weight]}kg 好棒棒")
    else
      client.say(channel: data.channel, text: "啊啊啊我壞掉惹")
    end
  end
end

Fatotabot.run