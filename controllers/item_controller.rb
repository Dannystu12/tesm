require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative '../models/item'
require_relative '../models/school'
require_relative '../models/supplier'

get '/add-item' do
  @schools = School.read_all.sort_by!{|school| school.name}
  @suppliers = Supplier.read_all.sort_by!{|supplier| supplier.name}
  erb :"items/add_item"
end

post '/add-item' do
  Item.new(params).create
  redirect '/'
end
