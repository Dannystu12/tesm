require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative 'models/inventory'

get '/' do
  @inventory = Inventory.read_all
  erb :inventory_index
end
