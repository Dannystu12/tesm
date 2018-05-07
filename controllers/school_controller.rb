require 'sinatra'
require 'sinatra/contrib/all' if development?
require_relative '../models/school'

get '/schools' do
  @schools = School.read_all
  erb :"schools/school_index"
end

get '/add-school' do
  erb :"schools/add_school"
end

post '/add-school' do
  School.new(params).create
  redirect '/schools'
end
