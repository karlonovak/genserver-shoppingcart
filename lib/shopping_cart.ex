defmodule ShoppingCart.Cart do
  use GenServer

  ### Public API
  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def show_articles, do: GenServer.call(__MODULE__, :show)
  def add_article(article) when is_atom(article), do: GenServer.cast(__MODULE__, {:add, article})
  def remove_article(article) when is_atom(article), do: GenServer.call(__MODULE__, {:remove, article})
  def clear, do: GenServer.call(__MODULE__, :clear)

  ### Private API
  def init(state), do: {:ok, state}

  def handle_call({:remove, article}, _from, state) do
    case Map.get(state, article) do
      x when x == nil -> raise "Can't delete non-existing article"
      x when x == 1 -> {:reply, Map.delete(state, article), Map.delete(state, article)}
      _ -> {:reply, Map.update(state, article, nil, &(&1 -1 )),  Map.update(state, article, nil, &(&1 -1 ))}
    end
  end

  def handle_call(:show, _from, state), do: {:reply, state, state}

  def handle_call(:clear, _from, _state), do: {:reply, %{}, %{}}

  def handle_cast({:add, article}, state) do
    {:noreply, Map.update(state, article, 1, &(&1 + 1))}
  end

end
