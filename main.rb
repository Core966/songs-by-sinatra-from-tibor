require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/flash'
require 'sass'
require 'v8'
require 'coffee-script'


get('/styles.css'){ scss :styles }

get('/javascripts/application.js'){ coffee :application }

require './sinatra/auth'

require './song'

helpers do
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
  
end

before do
  set_title #Anything inside a before filter block will be run before each request.
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

