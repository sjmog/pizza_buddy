require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "ConfirmPizzaOrder" do
  pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
  pizza.save

  response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                   "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
  
  card_title = "Your Pizza Order ##{ pizza.id }"
  card_body = "You ordered a #{ pizza.size } pizza with #{ pizza.toppings.to_sentence }!"
  card_image = "https://image.ibb.co/jeRZLv/alexa_pizza.png"
  pizza_card = card(card_title, card_body, card_image)

  tell(response_text, card: pizza_card)
end