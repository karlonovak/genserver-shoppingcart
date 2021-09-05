# ShoppingCart GenServer Example

**Demonstrates GenServer usage in Elixir with a simple ShoppingCart as well as using Agent as a state recovery mechanism.**

## Usage

```elixir
➜ iex -S mix         
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)

iex(1)> alias ShoppingCart.Cart
ShoppingCart.Cart

iex(2)> Cart.show_articles
%{}

iex(3)> Cart.add_article(:shirt)
:ok

iex(4)> Cart.add_article(:shirt)
:ok

iex(5)> Cart.add_article(:jeans)
:ok

iex(6)> Cart.show_articles      
%{jeans: 1, shirt: 2}

iex(7)> Cart.remove_article(:shirt)
%{jeans: 1, shirt: 1}
```

