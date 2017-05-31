require 'data_mapper'
require './lib/pizza'
require './lib/user'

DataMapper.setup(:default, 'postgres://pizzabuddy@localhost/pizzabuddy')
DataMapper.finalize
Pizza.auto_migrate!
User.auto_migrate!