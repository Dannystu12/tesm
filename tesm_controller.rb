require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative 'models/inventory'
require_relative 'controllers/item_controller'
require_relative 'controllers/school_controller'
require_relative 'controllers/supplier_controller'

get '/' do
  @inventory = Inventory.read_all
  erb :"items/inventory_index"
end
