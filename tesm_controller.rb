require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative 'models/inventory'
require_relative 'models/supplier'
require_relative 'models/item'
require_relative 'models/school'

get '/' do
  @inventory = Inventory.read_all
  erb :inventory_index
end

get '/suppliers' do
  @suppliers = Supplier.read_all
  erb :supplier_index
end

get '/schools' do
  @schools = School.read_all
  erb :school_index
end

get '/add-supplier' do
  erb :add_supplier
end

post '/add-supplier' do
  Supplier.new(params).create
  redirect "/suppliers"
end

get '/add-school' do
  erb :add_school
end

post '/add-school' do
  School.new(params).create
  redirect '/schools'
end
