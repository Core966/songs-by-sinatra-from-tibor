require './main'


class SongController < Website
enable :method_override

    helpers SongHelpers

    get '/' do
      env['warden'].authenticate!
      find_songs
      erb :songs
    end
    
    get '/new' do
      env['warden'].authenticate!
      @song = Song.new
      erb :new_song
    end
    
    get '/:id' do
      env['warden'].authenticate!
      @song = find_song
      erb :show_song
    end
    
    post '/' do
      env['warden'].authenticate!
#      if env['warden'].user.id == #{params[:user_id]}
          song = create_song
          redirect to("/#{song.id}")
#      else
#          flash.error = "Invalid song creation detected!"
#          redirect '/'
#      end
    end
    
    get '/:id/edit' do
      env['warden'].authenticate!
      @song = find_song
      erb :edit_song
    end
    
    put '/:id' do
      env['warden'].authenticate!
      song = find_song
      song.update(params[:song])
      redirect to("/#{song.id}")
    end
    
    delete '/:id' do
      env['warden'].authenticate!
      find_song.destroy
      redirect to('/')
    end
    
    post '/:id/like' do
      env['warden'].authenticate!
      @song = find_song
      @song.like = @song.like.next #Incrementing the number of likes by one.
      @song.save
      redirect to"/#{@song.id}" unless request.xhr?
      erb :like, :layout => false
    end

   
end