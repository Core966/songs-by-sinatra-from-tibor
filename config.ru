require 'sinatra/base'
require './main'
require './song'
require './user'

map('/songs') { run SongController }
map('/users') { run UserController }
map('/') { run Website }
