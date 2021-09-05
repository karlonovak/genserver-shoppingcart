defmodule ShoppingCart.Recovery do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def update(new_state) do
    Agent.update(__MODULE__, fn _state -> new_state end)
  end
end
