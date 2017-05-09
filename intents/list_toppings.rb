require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "ListToppings" do
  response_text = [
    "We have the following available toppings: ",
    "#{ Pizza::TOPPINGS.map { |topping| topping.to_s.gsub("_", " ") }.to_sentence }. ",
    "You can order a pizza, or list previous orders."
  ].join

  ask(response_text)
end