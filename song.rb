require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require 'sass'
require 'sinatra/flash'
require './sinatra/auth'



class SongController < Sinatra::Base
enable :method_override
register Sinatra::Flash
register Sinatra::Auth

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

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

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
  property :like, Integer, :default => 0
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y') #Converts the string entered in the form to be formatted to a date
  end
end

DataMapper.finalize

DataMapper.auto_upgrade!

helpers SongHelpers

before do
  set_title #Anything inside a before filter block will be run before each request.
end

  def css(*stylesheets) #Helper method to generate html tag for each of the scss files.
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end
  
  def current?(path='/') #This will return the path of the page that’s currently being visited, relative to the root URL
    (request.path==path || request.path==path+'/') ? "current" : nil
  end
  
  def set_title
    @title ||= "Songs By Sinatra"
  end
  
get '/' do
  find_songs
  erb :songs
end

get '/new' do
  protected!
  @song = Song.new
  erb :new_song
end

get '/:id' do
  @song = find_song
  erb :show_song
end

post '/' do
  protected!
  song = create_song
  redirect to("/#{song.id}")
end

get '/:id/edit' do
  protected!
  @song = find_song
  erb :edit_song
end

put '/:id' do
  protected!
  song = find_song
  song.update(params[:song])
  redirect to("/#{song.id}")
end

delete '/:id' do
  protected!
  find_song.destroy
  redirect to('/')
end

post '/:id/like' do
  @song = find_song
  @song.like = @song.like.next #Incrementing the number of likes by one.
  @song.save
  redirect to"/#{@song.id}" unless request.xhr?
  erb :like, :layout => false
end

end