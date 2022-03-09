# myapp.rb
require 'sinatra'
require './models'
enable :sessions
Dotenv.load
client = GooglePlaces::Client.new ENV['API_KEY']

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
  client.spots(34.7055051, 135.4983028).each do |spot|
      puts spot.name
  end
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
         redirect '/main'
     end
    redirect '/'
end

get '/main' do
    @sento = Sento.all
    erb :main
end

get '/sento/add' do
    erb :sento_add
end

post '/sento/:id/add' do
    sento = Sento.create(
        name: params[:name],
        osusume: params[:osusume],
        homepage_url: params[:homepage_url],
        map_url: params[:map_url],
        open_time: params[:open_time],
        cost: params[:cost]
    )
    if sento.persisted?
        redirect '/main'
    end
    redirect '/sento/add'
end

get '/mypage' do
   erb :my_page 
end

get '/post' do 
    @post = Post.all
    erb :post_list
end
    
get '/post/:user_id/add' do
    @sento = Sento.all
    erb :post_add
end

post '/post/:user_id/add' do
    post = Post.create(
        comment: params[:comment],
        sento_id: params[:sento],
        user_id: :user_id
    )
    if post.persisted?
        redirect '/post'
    end
    redirect 'post/:user_id/add'
end

post '/sento/:sento_id/delete' do
    sento = Sento.find(params[:sento_id])
    sento.destroy
    redirect '/main'
end

get '/logout' do
    session[:user] = nil
    redirect '/'
end
