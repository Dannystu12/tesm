require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative '../models/item'
require_relative '../models/school'
require_relative '../models/supplier'
require_relative '../models/inventory'

get '/add-item' do
  @schools = School.read_all.sort_by!{|school| school.name}
  @suppliers = Supplier.read_all.sort_by!{|supplier| supplier.name}
  erb :"items/add_item"
end

post '/add-item' do
  item = Item.new(params)
  item.create
  Inventory.new({"item_id" => item.id, "quantity" => params["initial_stock"]}).create
  redirect '/'
end
