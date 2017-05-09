require 'active_support/core_ext/array/conversions'

intent "PenultimatePizzaOrder" do
  size = request.session_attribute('size')

  toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
    topping = request.slot_value("topping#{ topping_number }")
    topping ? toppings + [topping] : toppings
  end

  ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. Is that right?", session_attributes: { size: size, toppings: toppings })
end