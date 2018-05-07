require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative '../models/supplier'

get '/suppliers' do
  @suppliers = Supplier.read_all
  erb :"suppliers/supplier_index"
end

get '/add-supplier' do
  erb :"suppliers/add_supplier"
end

get '/edit-supplier/:id' do
  @supplier = Supplier.read_by_id params["id"]
  erb :"suppliers/edit_supplier"
end

post '/edit-supplier/:id' do
  supplier = Supplier.read_by_id params["id"]
  supplier.name = params["name"]
  supplier.update
  redirect "/suppliers"
end

post '/add-supplier' do
  Supplier.new(params).create
  redirect "/suppliers"
end

post '/delete-supplier/:id' do
  supplier = Supplier.read_by_id params["id"]
  supplier.delete
  redirect '/suppliers'
end
