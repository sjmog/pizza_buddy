require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "PenultimatePizzaOrder" do
  size = request.session_attribute('size')

  toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
    topping = request.slot_value("topping#{ topping_number }")
    topping ? toppings + [topping] : toppings
  end

  disallowed_toppings = Pizza.disallowed_toppings(toppings)

  if disallowed_toppings.empty?
    ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. Is that right?", session_attributes: { size: size, toppings: toppings })
  else
    response_text = "I'm afraid we don't have #{ disallowed_toppings.to_sentence }. Please choose your toppings again, or ask for a list of available toppings."
    ask(response_text, session_attributes: { size: size })
  end
end