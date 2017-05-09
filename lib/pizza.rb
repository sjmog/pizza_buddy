class Pizza
  SIZES = [:small, :medium, :large]
  TOPPINGS = [
    :tomato_sauce, 
    :barbecue_sauce, 
    :cheese, 
    :ham, 
    :pineapple, 
    :pepperoni, 
    :mushrooms, 
    :sweetcorn, 
    :olives
  ]

  def self.disallowed_toppings(toppings)
    toppings.reject { |topping| allowed_topping?(topping) }
  end

  private

  def self.allowed_topping?(topping)
    TOPPINGS.include? topping.gsub(" ", "_").to_sym
  end
end