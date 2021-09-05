defmodule ShoppingCart.Cart do
  use GenServer

  ### Public API
  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def show_articles, do: GenServer.call(__MODULE__, :show)
  def add_article(article) when is_atom(article), do: GenServer.cast(__MODULE__, {:add, article})

  def remove_article(article) when is_atom(article),
    do: GenServer.call(__MODULE__, {:remove, article})

  def clear, do: GenServer.call(__MODULE__, :clear)

  ### Private API
  def init(_state), do: {:ok, ShoppingCart.Recovery.get()}

  def handle_call({:remove, article}, _from, state) do
    case Map.get(state, article) do
      x when x == nil ->
        raise "Can't delete non-existing article"

      x when x == 1 ->
        new_state = state |> Map.delete(article)
        {:reply, new_state, new_state}

      _ ->
        new_state = state |> Map.update(article, nil, &(&1 - 1))
        {:reply, new_state, new_state}
    end
  end

  def handle_call(:show, _from, state), do: {:reply, state, state}

  def handle_call(:clear, _from, _state), do: {:reply, %{}, %{}}

  def handle_cast({:add, article}, state) do
    {:noreply, Map.update(state, article, 1, &(&1 + 1))}
  end

  def terminate(_reason, state) do
    ShoppingCart.Recovery.update(state)
  end
end
