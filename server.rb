require 'sinatra'
require 'ralyxa'
load './database.rb'

post '/' do
  Ralyxa::Skill.handle(request)
end
