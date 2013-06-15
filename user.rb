require './main'


class UserController < Website
enable :method_override
    
    helpers UserHelpers
    
    get '/' do
      find_users
      erb :users
    end
    
    get '/new' do
      @user = User.new
      erb :new_user
    end
    
    get '/:id' do
      @user = find_user
      erb :show_user
    end
    
    post '/' do
      user = create_user
      redirect to("/#{user.id}")
    end
    
    get '/:id/edit' do
      @user = find_user
      erb :edit_user
    end
    
    put '/:id' do
      user = find_user
      user.update(params[:user])
      redirect to("/#{user.id}")
    end
    
    delete '/:id' do
      find_user.destroy
      redirect to('/')
    end

end