require 'rubygems'
require 'sinatra/base'
require 'sass'
require 'v8'
require 'coffee-script'
require './asset-handler'
require 'sinatra/reloader'
require 'warden'
require 'rack-flash'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'

class DataModel < Sinatra::Base

    configure :development do
      DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    end
    configure :production do
      DataMapper.setup(:default, ENV['DATABASE_URL'])
    end

class User
      include DataMapper::Resource
      include BCrypt
      property :id, Serial
      property :first_name, String
      property :last_name, String
      property :username, String
      property :password, BCryptHash
      property :email, String
      has n, :songs
#      has n, :likes
      
      def authenticate(attempted_password)
        if self.password == attempted_password
          true
        else
          false
        end
      end
    end
    
#    class Like
#      include DataMapper::Resource
#      property :id, Serial
#      property :user_id, Integer
#      property :song_id, Integer
#      property :like, Integer, :default => 0
#      belongs_to :song
#      belongs_to :user
#    end
    
    class Song
      include DataMapper::Resource
      property :id, Serial
      property :title, String
      property :lyrics, Text
      property :length, Integer
      property :released_on, Date
      property :like, Integer, :default => 0
#      property :user_id, Integer
      belongs_to :user
#      has n, :likes
      
#      has n, :likes
#      has n, :users, :through => :likes
      
      def released_on=date
        super Date.strptime(date, '%m/%d/%Y') #Converts the string entered in the form to be formatted to a date
      end
      
#    validates_with_method :user_id, :method => :check_id
      
#    def check_id
      # in a 'real' example, the number of citations might be a property set by
      # a before :valid? hook.
#      actual_id = @actual_id
#      if actual_id == @song.user_id
#        return true
#      else
#        flash.error = "Invalid song creation detected!"
#      end
#    end
    end
    
    DataMapper.finalize
    
    if User.count == 0
      @user = User.create(username: "admin")
      @user.password = "admin"
      @user.save
    end
    
    module UserHelpers
      def find_users
        @users = User.all
      end
      def find_user
        User.get(params[:id])
      end
      def create_user
        @user = User.create(params[:user])
      end
    end
    
#    module LikeHelpers
#      def create_like
#        @like = Like.create(:user_id => env['warden'].user.id, :song_id => song.id) 
#      end
#      def find_like
#        @like = Like.all(:user_id => env['warden'].user.id || )
#      end
#    end

    module SongHelpers
      def find_songs
        @songs = Song.all(:user_id => env['warden'].user.id)
      end
      def find_song
        Song.get(params[:id])
      end
      def create_song
        #@song = Song.create(params[:song])
        @song = Song.create(:user_id => env['warden'].user.id, :title => params[:title], :length => params[:length], :released_on => params[:released_on], :lyrics => params[:lyrics])
      end
    end
end