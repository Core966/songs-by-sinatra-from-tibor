require 'dm-core'
require 'dm-migrations'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
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
  protected!
  @song = Song.new
  erb :new_song
end

get '/songs/:id' do
  @song = find_song
  erb :show_song
end

post '/songs' do
  protected!
  song = create_song
  redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do
  protected!
  @song = find_song
  erb :edit_song
end

put '/songs/:id' do
  protected!
  song = find_song
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  protected!
  find_song.destroy
  redirect to('/songs')
end

