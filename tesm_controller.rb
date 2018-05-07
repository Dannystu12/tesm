require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative 'models/inventory'
require_relative 'models/supplier'
require_relative 'models/item'
require_relative 'models/school'

get '/' do
  @inventory = Inventory.read_all
  erb :index
end
