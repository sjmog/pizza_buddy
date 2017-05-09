require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "ConfirmPizzaOrder" do
  pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
  pizza.save

  response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                   "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
  tell(response_text)
end