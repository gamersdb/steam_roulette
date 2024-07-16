require 'httparty'
require 'json'
require 'pry'
require 'dotenv/load'

# Steam API Key
api_key = ENV['API_KEY']
# Steam ID (64-bit)
steam_id = ENV['STEAM_ID']

binding.pry

# Steam API URL for owned games
owned_games_url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{api_key}&steamid=#{steam_id}&format=json"

# APIリクエストを送信して、所有ゲームのリストを取得
owned_games_response = HTTParty.get(owned_games_url)
owned_games_data = JSON.parse(owned_games_response.body)

if owned_games_data['response'] && owned_games_data['response']['games']
  games = owned_games_data['response']['games']

  the_game = games.sample

  appid = the_game['appid']
  # Steam API URL for game details
  game_details_url = "http://store.steampowered.com/api/appdetails?appids=#{appid}"

  # ゲーム詳細情報を取得
  game_details_response = HTTParty.get(game_details_url)
  game_details_data = JSON.parse(game_details_response.body)
  name = game_details_data.values.first['data']['name']

  puts "今日は#{name}で遊ぶのがおすすめです"
else
  puts "No games found or an error occurred."
end
