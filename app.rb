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
    session[:lat] = 0
    session[:lon] = 0
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
    if params[:lat] == "" or params[:lon] == ""
        session[:lat] = "35.6812362"
        session[:lon] = "139.7649361"
    else
        session[:lat] = params[:lat]
        session[:lon] = params[:lon]
    end
    if user && user.authenticate(params[:password])
        session[:user] = user.id
        redirect '/main'
    end
    redirect '/'
end

get '/main' do
    @sento = Sento.all
    # @sento.each do |sento|
        # @spot = client.spot(params[:place_id], :language => "ja")
        # @url = @spot.photos[0].fetch_url(1000)
        # @transit_time = params[:transit_time]
    # end
    # url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+session[:lat]+"%2C"+session[:lon]+"&destinations=place_id:&key="+ENV['API_KEY'])
    # https = Net::HTTP.new(url.host, url.port)
    # https.use_ssl = true
    
    # request = Net::HTTP::Get.new(url)
    # response = https.request(request)
    # json = JSON.parse(response.read_body)
    # puts json
    # puts response.read_body
    # @elements = json["rows"][0]["elements"][0]["duration"]["text"]
    # puts json["rows"][0]["elements"][0]["duration"]["text"]
    
    transit_time = Array.new

    @sento.each do |sento|
        # photo = client.spot(c.place_id)
        # photo_urls.push(photo.photos[0].fetch_url(800))
        # puts c
        puts session[:lat]
        puts session[:lon]
        url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+session[:lat]+"%2C"+session[:lon]+"&destinations=place_id:"+sento.place_id+"&language=ja&avoid=tolls&key="+ENV['API_KEY'])
        puts 33333
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        puts 44444
        request = Net::HTTP::Get.new(url)
        # puts request
        response = https.request(request)
        json = JSON.parse(response.read_body)
        puts json["rows"][0]["elements"][0]["duration"]
        transit_time.push(json["rows"][0]["elements"][0]["duration"]["text"])
    end
    @transit_time = transit_time
    erb :main
end
    
get '/sento/add' do
    erb :sento_add
end

post '/sento/:user_id/add' do
    sento = Sento.create(
        user_id: params[:user_id],
        name: params[:name],
        osusume: params[:osusume],
        homepage_url: params[:homepage_url],
        img_url: params[:img_url],
        place_id: params[:place_id],
        cost: params[:cost]
    )
    if sento.persisted?
        redirect '/main'
    end
    redirect '/sento/add'
end

get '/mypage' do
    sentos = Sento.all
    like_sentos = Array.new
    my_sentos = Array.new
    transit_time = Array.new
    my_sento_transit_time = Array.new
    sentos.each do |sento|
        if sento.user_id==session[:user]
            my_sentos.push(sento)
            url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+session[:lat]+"%2C"+session[:lon]+"&destinations=place_id:"+sento.place_id+"&language=ja&avoid=tolls&key="+ENV['API_KEY'])
            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            request = Net::HTTP::Get.new(url)
            response = https.request(request)
            json = JSON.parse(response.read_body)
            puts json["rows"][0]["elements"][0]["duration"]
            my_sento_transit_time.push(json["rows"][0]["elements"][0]["duration"]["text"])
        end
        if sento.like_users.find_by(id: session[:user])
            like_sentos.push(sento)
            url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+session[:lat]+"%2C"+session[:lon]+"&destinations=place_id:"+sento.place_id+"&language=ja&avoid=tolls&key="+ENV['API_KEY'])
            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            request = Net::HTTP::Get.new(url)
            response = https.request(request)
            json = JSON.parse(response.read_body)
            puts json["rows"][0]["elements"][0]["duration"]
            transit_time.push(json["rows"][0]["elements"][0]["duration"]["text"])
        end
    end
    @like_sentos = like_sentos
    @my_sentos = my_sentos
    @transit_time = transit_time
    @my_sento_transit_time = my_sento_transit_time
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

get '/sento/search/list' do
    @client = client.spots_by_query(params[:name], language: 'ja')
    transit_time = Array.new
    # photo_urls = Array.new
    
    
    @client.each do |c|
        # photo = client.spot(c.place_id)
        # photo_urls.push(photo.photos[0].fetch_url(800))
        # puts c
        # url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=35.6711874%2C139.6260258&destinations=place_id:"+c.place_id+"&language=ja&avoid=tolls&key="+ENV['API_KEY'])
        url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+session[:lat]+"%2C"+session[:lon]+"&destinations=place_id:"+c.place_id+"&language=ja&avoid=tolls&key="+ENV['API_KEY'])
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        
        request = Net::HTTP::Get.new(url)
        # puts request
        response = https.request(request)
        json = JSON.parse(response.read_body)
        transit_time.push(json["rows"][0]["elements"][0]["duration"]["text"])
    end
    @transit_time = transit_time
    # @photo_urls = photo_urls
    uri = URI("https://maps.googleapis.com/maps/api/place/photo")
    uri.query = URI.encode_www_form({
        maxwidth: 400,
        photo_reference: @client[0].photos[0].photo_reference,
        key: ENV['API_KEY']
    })
    # p uri
    @uri = uri
    res = Net::HTTP.get_response(uri)
    # p res
    @res = res
    # json = JSON.parse(res.body)
    # p res
    erb :sento_search_list
end

get '/sento/search/list/:place_id/:transit_time/info' do
    @spot = client.spot(params[:place_id], :language => "ja")
    @url = @spot.photos[0].fetch_url(1000)
    @transit_time = params[:transit_time]
    erb :sento_search_list_info
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

get '/sento/:sento_id/:transit_time/info' do
    @sento = Sento.find(params[:sento_id])
    @spot = client.spot(@sento.place_id, :language => "ja")
    @url = @spot.photos[0].fetch_url(1000)
    @transit_time = params[:transit_time]
    @maps_url = "https://www.google.com/maps/dir/?api=1&origin="+session[:lat].to_s+","+session[:lon].to_s+"&destination="+"@spot.name"+"&destination_place_id="+@spot.place_id.to_s+"&travelmode=driving"
    erb :sento_info
end

get '/sento/:sento_id/like/add' do
    if LikeSento.find_by(user_id: session[:user], sento_id: params[:sento_id]).nil?
        LikeSento.create(user_id: session[:user], sento_id: params[:sento_id])
    end
    redirect '/main'
end

get '/sento/:sento_id/like/delete' do
    like_sento = LikeSento.find_by(user_id: session[:user], sento_id: params[:sento_id])
    like_sento.delete
    redirect '/main'
end 
get '/logout' do
    session[:user] = nil
    redirect '/'
end

get '/mysento/:sento_id/:transit_time/info' do
    @sento = Sento.find(params[:sento_id])
    @spot = client.spot(@sento.place_id, :language => "ja")
    @url = @spot.photos[0].fetch_url(1000)
    @transit_time = params[:transit_time]
    @maps_url = "https://www.google.com/maps/dir/?api=1&origin="+session[:lat].to_s+","+session[:lon].to_s+"&destination="+"@spot.name"+"&destination_place_id="+@spot.place_id.to_s+"&travelmode=driving"
    erb :my_sento_info
end

get '/sento/:sento_id/delete' do
    my_sento = Sento.find_by(id: params[:sento_id])
    my_sento.delete
    redirect '/main'
end 