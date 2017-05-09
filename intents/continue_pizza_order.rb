require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "ContinuePizzaOrder" do
  size = request.slot_value("size")
  response_text = ["OK, a #{ size } pizza. What would you like on that pizza? ",
                   "You can choose up to five items, or ask for a list of ",
                   "choices. Or, choose another size: #{ Pizza::SIZES.to_sentence }"].join
  
  ask(response_text, session_attributes: { size: size })
end