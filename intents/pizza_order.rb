require './lib/pizza'
require 'active_support/core_ext/array/conversions'

### WHICH READS BETTER? ###

# I'm thinking about how to introduce state management to Ralyxa.
# Right now I have four competing interfaces:
#
# Intent-first Controller
# State-first Controller
# Scripted
# State-first Controller - Scripted Combo
#
# Which do you think 'feels' better? Which is lightweight? Which conveys the idea of state?
# In a Voice UI, which is more important: Intent or State?
#
# In each example, there are four possible states to be handled by a single intent:
# 
# start/default
# continue
# penultimate
# confirm
#
# Each example does the same thing, i.e. walks the user through a pizza-ordering process.
# The implementation of state is by writing and reading from a `state` key in the session.

### INTENT-FIRST CONTROLLER ###
### Each of the controller methods handles a different state

class PizzaOrderIntent < Ralyxa::Intent
  def start
    ask("Great! What pizza would you like? You can pick from #{ pizza_sizes_string }")
  end

  def continue
    size = request.slot_value("size")
    response_text = ["OK, a #{ size } pizza. What would you like on that pizza? ",
                     "You can choose up to five items, or ask for a list of ",
                     "toppings. Or, choose another size: #{ pizza_sizes_string }"].join
    
    ask(response_text, session_attributes: { size: size })
  end

  def penultimate
    size = request.session_attribute('size')

    toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
      topping = request.slot_value("topping#{ topping_number }")
      topping ? toppings + [topping] : toppings
    end

    disallowed_toppings = Pizza.disallowed_toppings(toppings)

    if disallowed_toppings.empty?
      ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. To confirm, say 'confirm my order'. Otherwise, say 'start over'", session_attributes: { size: size, toppings: toppings })
    else
      response_text = "I'm afraid we don't have #{ disallowed_toppings.to_sentence }. Please choose your toppings again, or ask for a list of available toppings."
      ask(response_text, session_attributes: { size: size })
    end
  end

  def confirm
    pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
    pizza.save

    response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                     "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
    
    card_title = "Your Pizza Order ##{ pizza.id }"
    card_body = "You ordered a #{ pizza.size } pizza with #{ pizza.toppings.to_sentence }!"
    card_image = "http://www.cicis.com/media/1243/pizza_adven_zestypepperoni.png"

    tell(response_text, card: card(card_title, card_body, card_image))
  end

  private

  def pizza_sizes_string
    pizza_sizes_string = Pizza::SIZES.to_sentence
  end
end

### STATE-FIRST CONTROLLER ###
### each state gets its own controller, which may contain multiple intents

class DefaultState < Ralyxa::State
  def pizza_order
    pizza_sizes_string = Pizza::SIZES.to_sentence

    ask("Great! What pizza would you like? You can pick from #{ Pizza::SIZES.to_sentence }")
  end
end

class StartState < Ralyxa::State
  use :default, for: :pizza_order
end

class ContinueState < Ralyxa::State
  def pizza_order
    size = request.slot_value("size")
    response_text = ["OK, a #{ size } pizza. What would you like on that pizza? ",
                     "You can choose up to five items, or ask for a list of ",
                     "toppings. Or, choose another size: #{ Pizza::SIZES.to_sentence }"].join
    
    ask(response_text, session_attributes: { size: size })
  end
end

class PenultimateState < Ralyxa::State
  def pizza_order
    size = request.session_attribute('size')

    toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
      topping = request.slot_value("topping#{ topping_number }")
      topping ? toppings + [topping] : toppings
    end

    disallowed_toppings = Pizza.disallowed_toppings(toppings)

    if disallowed_toppings.empty?
      ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. To confirm, say 'confirm my order'. Otherwise, say 'start over'", session_attributes: { size: size, toppings: toppings })
    else
      response_text = "I'm afraid we don't have #{ disallowed_toppings.to_sentence }. Please choose your toppings again, or ask for a list of available toppings."
      ask(response_text, session_attributes: { size: size })
    end
  end
end

class ConfirmState < Ralyxa::State
  def pizza_order
    pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
    pizza.save

    response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                     "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
    
    card_title = "Your Pizza Order ##{ pizza.id }"
    card_body = "You ordered a #{ pizza.size } pizza with #{ pizza.toppings.to_sentence }!"
    card_image = "http://www.cicis.com/media/1243/pizza_adven_zestypepperoni.png"
    pizza_card = card(card_title, card_body, card_image)

    tell(response_text, card: pizza_card)
  end
end

### SCRIPTED ###
### class use reduced and building stuff without states is easier

intent "PizzaOrder", :start, :default do
  pizza_sizes_string = Pizza::SIZES.to_sentence

  ask("Great! What pizza would you like? You can pick from #{ Pizza::SIZES.to_sentence }")
end

intent "PizzaOrder", :continue do
  size = request.slot_value("size")
  response_text = ["OK, a #{ size } pizza. What would you like on that pizza? ",
                   "You can choose up to five items, or ask for a list of ",
                   "toppings. Or, choose another size: #{ Pizza::SIZES.to_sentence }"].join
  
  ask(response_text, session_attributes: { size: size })
end

intent "PizzaOrder", :penultimate do
  size = request.session_attribute('size')

  toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
    topping = request.slot_value("topping#{ topping_number }")
    topping ? toppings + [topping] : toppings
  end

  disallowed_toppings = Pizza.disallowed_toppings(toppings)

  if disallowed_toppings.empty?
    ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. To confirm, say 'confirm my order'. Otherwise, say 'start over'", session_attributes: { size: size, toppings: toppings })
  else
    response_text = "I'm afraid we don't have #{ disallowed_toppings.to_sentence }. Please choose your toppings again, or ask for a list of available toppings."
    ask(response_text, session_attributes: { size: size })
  end
end

intent "PizzaOrder", :confirm do
  pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
  pizza.save

  response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                   "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
  
  card_title = "Your Pizza Order ##{ pizza.id }"
  card_body = "You ordered a #{ pizza.size } pizza with #{ pizza.toppings.to_sentence }!"
  card_image = "http://www.cicis.com/media/1243/pizza_adven_zestypepperoni.png"
  pizza_card = card(card_title, card_body, card_image)

  tell(response_text, card: pizza_card)
end

### STATE CONTROLLER - SCRIPTED COMBO
### state prioritised, but only if the user wants to use it: otherwise, they can just use intents

# Implicitly wraps this in a DefaultState object
intent "PizzaOrder" do
  pizza_sizes_string = Pizza::SIZES.to_sentence

  ask("Great! What pizza would you like? You can pick from #{ Pizza::SIZES.to_sentence }")
end

class StartState < Ralyxa::State
  use DefaultState, for: "PizzaOrder"
end

class ContinueState < Ralyxa::State
  intent "PizzaOrder" do
    size = request.slot_value("size")
    response_text = ["OK, a #{ size } pizza. What would you like on that pizza? ",
                     "You can choose up to five items, or ask for a list of ",
                     "toppings. Or, choose another size: #{ Pizza::SIZES.to_sentence }"].join
    
    ask(response_text, session_attributes: { size: size })
  end
end

class PenultimateState < Ralyxa::State
 intent "PizzaOrder" do
   size = request.session_attribute('size')

   toppings = ['One', 'Two', 'Three', 'Four', 'Five'].inject([]) do |toppings, topping_number|
     topping = request.slot_value("topping#{ topping_number }")
     topping ? toppings + [topping] : toppings
   end

   disallowed_toppings = Pizza.disallowed_toppings(toppings)

   if disallowed_toppings.empty?
     ask("OK, a #{ size } pizza with #{ toppings.to_sentence }. To confirm, say 'confirm my order'. Otherwise, say 'start over'", session_attributes: { size: size, toppings: toppings })
   else
     response_text = "I'm afraid we don't have #{ disallowed_toppings.to_sentence }. Please choose your toppings again, or ask for a list of available toppings."
     ask(response_text, session_attributes: { size: size })
   end
 end
end

class ConfirmState < Ralyxa::State
  intent "PizzaOrder" do
    pizza = Pizza.new(size: request.session_attribute('size'), toppings: request.session_attribute('toppings'))
    pizza.save

    response_text = ["Thanks! Your #{ pizza.size } pizza with #{ pizza.toppings.to_sentence } is on ",
                     "its way to you. Your order ID is #{ pizza.id }. Thank you for using Pizza Buddy!"].join
    
    card_title = "Your Pizza Order ##{ pizza.id }"
    card_body = "You ordered a #{ pizza.size } pizza with #{ pizza.toppings.to_sentence }!"
    card_image = "http://www.cicis.com/media/1243/pizza_adven_zestypepperoni.png"
    pizza_card = card(card_title, card_body, card_image)

    tell(response_text, card: pizza_card)
  end
end