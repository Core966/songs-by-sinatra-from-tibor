require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'

get('/styles.css'){ scss :styles }

require './song'

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
