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

get '/edit-school/:id' do
  @school = School.read_by_id params["id"]
  erb :"schools/edit_school"
end

post '/edit-school/:id' do
  school = School.read_by_id params["id"]
  school.name = params["name"]
  school.icon_url = params["icon_url"]
  school.description = params["description"]
  school.update
  redirect "/schools"
end

post '/delete-school/:id' do
  school = School.read_by_id params["id"]
  school.delete
  redirect "/schools"
end
