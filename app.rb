# myapp.rb
require 'sinatra'
require './models'
enable :session


get '/' do
  erb :index
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    
end