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

post '/add-supplier' do
  Supplier.new(params).create
  redirect "/suppliers"
end
