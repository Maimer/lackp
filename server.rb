require 'sinatra'
require 'uri'
require 'csv'

def make_data()
  @lackp_roster = {}

  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    if !@lackp_roster.has_key?(row["team"])
      @lackp_roster[row["team"]] = []
    end
    @lackp_roster[row["team"]] << [row["first_name"], row["last_name"], row["position"]]
  end
  @lackp_roster
end

def make_teams(roster)
  @teams = []
  roster.each do |team, player|
    @teams << team
  end
  @teams
end

def make_positions(roster)
  @positions = []
  roster.each do |team, player|
    player.each do |data|
      if !@positions.include?(data[2])
        @positions << data[2]
      end
    end
  end
  @positions
end

def make_roster(data, teamname)
  @rosterhash = {}
  data[teamname].each do |player|
    @rosterhash[player[0] + " " + player[1]] = player[2]
  end
  @rosterhash
end

def make_position(data, position)
  @positionarray = []
  data.each do |team, players|
    players.each do |player|
      if player[2] == position
        @positionarray << [(player[0] + " " + player[1]), team]
      end
    end
  end
  @positionarray
end

get '/' do
  @data = make_data()
  @teams = make_teams(@data)
  @positions = make_positions(@data)

  erb :index
end

get '/team/:team_name' do
  @team_name = params[:team_name]
  @data = make_data()
  @roster = make_roster(@data, @team_name)
  # The :team_name is available in our params hash
  erb :teampage
end

get '/team/URI.encode(:team_name)' do
  @team_name = params[:team_name]
  # The :team_name is available in our params hash
  erb :teampage
end

get '/position/:position_name' do
  @position_name = params[:position_name]
  @data = make_data()
  @position = make_position(@data, @position_name)
  # The :position_name is available in our params hash
  erb :positionpage
end

get '/position/URI.encode(:position_name)' do
  @position_name = params[:position_name]
  # The :position_name is available in our params hash
  erb :positionpage
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
