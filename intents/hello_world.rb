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
# There is only one state to this intent: "Default".
#
# Each example does the same thing, i.e. responds with "Hello World".
# The implementation of state is by writing and reading from a `state` key in the session.

### INTENT-FIRST CONTROLLER ###
### Each of the controller methods handles a different state

class HelloWorldIntent < Ralyxa::Intent
  def default
    respond("Hello World")
  end
end

### STATE-FIRST CONTROLLER ###
### each state gets its own controller, which may contain multiple intents

class DefaultState < Ralyxa::State
  def hello_world
    respond("Hello World")
  end
end

### SCRIPTED ###
### class use reduced and building stuff without states is easier

intent "HelloWorld", :default do
  respond("Hello World")
end

### STATE CONTROLLER - SCRIPTED COMBO
### state prioritised, but only if the user wants to use it: otherwise, they can just use intents

# This intent would actually be implicitly wrapped in a DefaultState, but I've expanded here
class DefaultState < Ralyxa::State
  intent "HelloWorld" do
    respond("Hello World")
  end
end

### Please see /intents/pizza_order.rb for a more comprehensive set of comparison cases.