require 'sinatra'
require 'uri'
require 'csv'

get '/' do

  lackp_roster = {}

  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    if !lackp_roster.has_key?(row["team"])
      lackp_roster[row["team"]] = []
    end
    lackp_roster[row["team"]] << [row["first_name"], row["last_name"], row["position"]]
  end

  @teams = []
  @positions = []

  lackp_roster.each do |team, player|
    @teams << team
    player.each do |data|
      if !@positions.include?(data[2])
        @positions << data[2]
      end
    end
  end
  erb :index
end

get '/team/:team_name' do
  @teams = params[:team_name]
  # The :team_name is available in our params hash
  erb :teampage
end

get '/team/URI.encode(:team_name)' do
  @teams = params[:team_name]
  # The :team_name is available in our params hash
  erb :teampage
end

get '/position/:position_name' do
  @teams = params[:position_name]
  # The :position_name is available in our params hash
  erb :positionpage
end

get '/position/URI.encode(:position_name)' do
  @teams = params[:position_name]
  # The :position_name is available in our params hash
  erb :positionpage
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
