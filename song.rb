require 'dm-core'
require 'dm-migrations'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
  enable :sessions
  set :username, 'Frank'
  set :password, 'Sinatra'
end

class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :released_on, Date
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y') #Converts the string entered in the form to be formatted to a date
  end
end

DataMapper.finalize

DataMapper.auto_upgrade!

module SongHelpers
  def find_songs
    @songs = Song.all
  end
  def find_song
    Song.get(params[:id])
  end
  def create_song
    @song = Song.create(params[:song])
  end
end

helpers SongHelpers

get '/songs' do
  find_songs
  erb :songs
end

get '/songs/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = Song.new
  erb :new_song
end

get '/songs/:id' do
  @song = find_song
  erb :show_song
end

post '/songs' do
  if song = create_song
  flash[:notice] = "Song successfully added"
  else
  flash[:notice] = "Song adding unsuccessful"
  end
  redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do
  @song = find_song
  erb :edit_song
end

put '/songs/:id' do
  song = find_song
  if song.update(params[:song])
  flash[:notice] = "Song successfully updated"
  else
  flash[:notice] = "Song updating unsuccessful" 
  end
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  if find_song.destroy
  flash[:notice] = "Song deleted"
  else
  flash[:notice] = "Song deletion unsuccessful"
  end
  redirect to('/songs')
end

get '/login' do
  erb :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end
