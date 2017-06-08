require './lib/pizza'

intent "ListOrders" do
  return tell("To list your orders, please authenticate Pizza Buddy via the Alexa app.", card: link_account_card) unless request.user_access_token_exists?

  user = User.authenticate(request.user_access_token)
  if user.pizzas.any?
    orders = user.pizzas.first(4).map { |order| "a #{ order.size } pizza with #{ order.toppings.to_sentence }" }
    response_text = ["You have made #{ user.pizzas.count } orders. ",
                     "#{ orders.to_sentence }. ",
                     "You can ask to list orders again, or order a pizza."].join
  else
    response_text = "You haven't made any orders yet. To start, say 'order a pizza'."
  end

  ask(response_text)
end