require 'sinatra/base'
require 'sinatra/flash'
require 'sass'
require 'v8'
require 'coffee-script'
require './sinatra/auth'
require './asset-handler'

class Website < Sinatra::Base
    
use AssetHandler
    
register Sinatra::Auth
register Sinatra::Flash

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

before do
  set_title #Anything inside a before filter block will be run before each request.
end
  
  def current?(path='/') #This will return the path of the page that’s currently being visited, relative to the root URL
    (request.path==path || request.path==path+'/') ? "current" : nil
  end
  
  def set_title
    @title ||= "Songs By Sinatra"
  end

get '/' do
  @title = "Home page"
  erb :home
end

get '/about' do
  @title = "About page"
  erb :about
end

get '/contact' do
  @title = "Contact page"
  erb :contact
end

not_found do
  @title = "Whoops, page not found!"
  erb :not_found
end

end