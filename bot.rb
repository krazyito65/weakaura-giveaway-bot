require 'discordrb'
token = File.read('token').strip
bot = Discordrb::Bot.new token: token

users = {}
all_winners = {}
all_winners_keys = {}
keys = []

File.foreach('keys').with_index do |line, index|
  keys[index] = line.strip
end

current = nil
last_current = 1

channel_id = 458811731699826689 # beta giveaway
# channel_id = 259888294039388160 # Bronze 6

while current != last_current
  puts "Last msg id = #{current}"
  last_current = current
  bot.channel(channel_id).history(100, before_id = current).each do |message|
    current = message.id
    u = message.user.distinct
    # next unless u.eql?("Krazyito#1696") #or u.eql?("Ora#9760")
    users[u] = message.user
  end
end
users.delete('Krazyito#1696')
puts users.keys
puts "entries: #{users.length}"

bot.message(with_text: 'parse', from: 92716502255439872) do |event|
  all_winners = {}
  entries = users.keys
  puts "# OF ENTRIES #{entries.length}"
  for i in 0..49
    winner = entries[rand(entries.size)]
    entries.delete(winner)
    all_winners[winner] = users[winner]
  end

  all_winners.delete(nil)
  event.respond 'Winners:'
  win_string = ''
  all_winners.each do |_name, user|
    win_string += "#{user.mention} "
  end

  # event.respond "#{win_string}"
  puts 'WINNERS:'
  i = 0
  all_winners.each do |name, user|
    all_winners_keys[name] = keys[i]
    # user.pm("Your beta key is: `#{keys[i]}`.
# You can redeem this code in your Battle.net account management interface https://battle.net/account/management/claim-code.html
# These messages are not monitored. Please message Krazyito#1696 if you have issues.")
    i += 1
  end
  puts all_winners_keys
  puts all_winners_keys.length
end

bot.ready do |_|
  puts 'ready'
end

bot.run
