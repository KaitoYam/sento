# myapp.rb
require 'sinatra'
require './models'
enable :session

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
  erb :index
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    confirm = User.find_by(name: params[:name])
    if confirm.nil?
        user = User.create(
            name: params[:name],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            point: 0,
            rank: "normal"
        )
        if user.persisted?
            session[:user] = user.id
        end
        redirect '/main'
    end
    redirect '/signup'
end

post '/login' do
    user = User.find_by(name: params[:name])
     if user && user.authenticate(params[:password])
         session[:user] = user.id
     end
     redirect '/main'
end

get '/main' do
    erb :main
end

get '/logout' do
    session[:user] = nil
    redirect '/'
end
