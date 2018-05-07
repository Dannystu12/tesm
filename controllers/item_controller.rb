require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative '../models/item'




get '/add-item' do
  erb :"items/add_item"
end

post '/add-item' do
  Item.new(params).create
  redirect '/'
end
