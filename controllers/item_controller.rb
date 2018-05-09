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
  Inventory.new({"item_id" => item.id, "quantity" => params["quantity"]}).create
  redirect '/'
end


get '/edit-item/:id' do
  @item = Item.read_by_id params["id"]
  @inventory = Inventory.read_by_item @item
  @schools = School.read_all.sort_by!{|school| school.name}
  @suppliers = Supplier.read_all.sort_by!{|supplier| supplier.name}
  erb :"items/edit_item"
end

post '/edit-item/:id' do
  item = Item.read_by_id params["id"]
  item.name = params["name"]
  item.description = params["description"]
  item.buy_price = params["buy_price"].to_i
  item.sell_price = params["sell_price"].to_i
  item.supplier_id = params["supplier_id"].to_i
  item.school_id = params["school_id"].to_i
  inventory = Inventory.read_by_item item
  inventory.quantity = params["quantity"].to_i
  item.update
  inventory.update
  redirect "/"
end

post '/delete-item/:id' do
  item = Item.read_by_id params["id"]
  inventory = Inventory.read_by_item item
  inventory.delete
  item.delete
  redirect "/"
end

get '/items-by-school/:id' do
  @inventory = Inventory.read_by_school params["id"]
  erb :"items/inventory_index"
end
