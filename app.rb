# myapp.rb
require 'sinatra'
require './models'
require 'json'
require 'uri'
require 'net/http'
enable :sessions
Dotenv.load
client = GooglePlaces::Client.new ENV['API_KEY']


helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    # navigator.geolocation.getCurrnentPosition(function (position){
    #     LatLng = new gooel.maps.latLng(position.coords.latitude, position.coords.longitude);
    #     p LatLng
    # })
  erb :index
end

get '/sento/search/list' do
    # @client = client.spots(params[:lat], params[:lon], :language => 'ja', :name => params[:name],  :radius => 10000)
    @client = client.spots_by_query(params[:name], language: 'ja')
    p 11111111111111111111
    p 11111111111111111111
    p 11111111111111111111
    
    @client.each do |c|
        puts c.place_id
    end
    
    uri = URI("https://maps.googleapis.com/maps/api/place/photo")
    uri.query = URI.encode_www_form({
        maxwidth: 100,
        photo_reference: @client[0].photos[0].photo_reference,
        key: ENV['API_KEY']
    })
    p uri
    res = Net::HTTP.get_response(uri)
    p res
    
    @res = res
    # json = JSON.parse(res.body)
    # p res
    erb :sento_search_list
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
    
    # uri = URI("https://maps.googleapis.com/maps/api/distancematrix/json")
    # uri.query = URI.encode_www_form({
    #     destinations: "Washington%2C%20DC",
    #     origins: "New%20York%20City%2C%20NY",
    #     unites: "imperial",
    #     key: ENV['API_KEY']
    # })
    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true
    # request = Net::HTTP::Get.new(url)
    # response = https.request(request)
    # puts response.read_body


    url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+params[:lat]+"%2c"+params[:lon]+"&destinations=place_id:ChIJkY4i9-aMGGAREeJTfchRKao&key=AIzaSyA06isUJXgeAyaZoQ7XNsiKQezLaSsb3rM")
    
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    
    response = https.request(request)
    json = JSON.parse(response.read_body)
    # puts json
    # puts response.read_body
    @elements = json["rows"][0]["elements"][0]["duration"]["text"]
    puts json["rows"][0]["elements"][0]["duration"]["text"]
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

get '/sento/search' do
    erb :sento_search
end


# post 'sento/search' do
#     @client = client
#     redirect '/post/search'
# end

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
