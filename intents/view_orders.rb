intent "ViewOrders" do
  orders = Pizza.first(4).map { |order| "a #{ order.size } pizza with #{ order.toppings.to_sentence }" }

  response_text = ["There are #{ Pizza.count } orders. ",
                   "#{ orders.to_sentence }.",
                   "You can ask to view orders again, or order a pizza."].join

  ask(response_text)
end