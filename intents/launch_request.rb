intent "LaunchRequest" do
  if request.user_access_token_exists?
    ask("Welcome to Pizza Buddy. Would you like a new pizza, or to list orders?")
  else
    tell("Please authenticate Pizza Buddy via the Alexa app.", card: link_account_card)
  end
end