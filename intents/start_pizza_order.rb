require './lib/pizza'
require 'active_support/core_ext/array/conversions'

intent "StartPizzaOrder" do
  pizza_sizes_string = Pizza::SIZES.to_sentence

  ask("Great! What pizza would you like? You can pick from #{ Pizza::SIZES.to_sentence }")
end