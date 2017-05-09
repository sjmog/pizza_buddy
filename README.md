# Pizza Buddy

An intermediate application demonstrating the use of persistence in an Alexa skill.

## Usage

Users can ask Alexa the following:

> Alexa, launch Pizza Buddy

Prompts the user to either order a pizza, or list previous orders.

> Order a pizza

Starts a conversation to order a pizza, including choice of size and toppings.

> List toppings

Lists available toppings.

> List orders

Lists the four most recent orders.

Once the user has confirmed their order, they receive a Card to their Amazon Alexa app, with details of their order and a picture.

## Developing

To get started with the develoment application:

- Install dependencies with `bundle install`;
- Create a new Postgres user called `pizzabuddy`;
- Create two new Postgres databases: `pizzabuddy` and `pizzabuddytest`, and
- Run the server with `ruby server.rb`.

You will need to create a new Amazon Alexa skill, with the following Intent Schema:

```json
{
  "intents": [
    {
      "intent": "StartPizzaOrder"
    },
    {
      "intent": "ContinuePizzaOrder",
      "slots": [
        {
          "name": "size",
          "type": "PIZZA_SIZE"
        }
      ]
    },
    {
      "intent": "PenultimatePizzaOrder",
      "slots": [
        {
          "name": "toppingOne",
          "type": "PIZZA_TOPPING"
        },
        {
          "name": "toppingTwo",
          "type": "PIZZA_TOPPING"
        },
        {
          "name": "toppingThree",
          "type": "PIZZA_TOPPING"
        },
        {
          "name": "toppingFour",
          "type": "PIZZA_TOPPING"
        },
        {
          "name": "toppingFive",
          "type": "PIZZA_TOPPING"
        }
      ]
    },
    {
      "intent": "ConfirmPizzaOrder"
    },
    {
      "intent": "ListOrders"
    },
    {
      "intent": "ListToppings"
    }
  ]
}
```

The following Utterances:

```
StartPizzaOrder new pizza
StartPizzaOrder order a pizza
StartPizzaOrder order me a pizza

ContinuePizzaOrder {size}
ContinuePizzaOrder a {size} pizza

PenultimatePizzaOrder {toppingOne}
PenultimatePizzaOrder {toppingOne} {toppingTwo}
PenultimatePizzaOrder {toppingOne} {toppingTwo} {toppingThree}
PenultimatePizzaOrder {toppingOne} {toppingTwo} {toppingThree} {toppingFour}
PenultimatePizzaOrder {toppingOne} {toppingTwo} {toppingThree} {toppingFour} {toppingFive}

ConfirmPizzaOrder confirm my order

ListOrders list orders

ListToppings list toppings
```

And the following Custom Types:

```
Type: PIZZA_SIZE
Values: small | medium | large
```

```
Type: PIZZA_TOPPING
Values: tomato sauce | barbecue sauce | cheese | ham | pineapple | pepperoni | mushrooms | sweetcorn | olives
```

You can then test the skill in the Service Simulator.