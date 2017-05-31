require './lib/pizza'

configure :development do
  DataMapper.setup(:default, 'postgres://pizzabuddy@localhost/pizzabuddy')
end

DataMapper.finalize
Pizza.auto_migrate!
User.auto_migrate!