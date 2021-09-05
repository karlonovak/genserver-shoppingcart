defmodule ShoppingCart.CartTest do
  alias ShoppingCart.Cart
  use ExUnit.Case
  doctest ShoppingCart.Cart

  test "clearing Cart removes all added articles" do
    Cart.clear()
    :shirt |> Cart.add_article()
    :jeans |> Cart.add_article()
    assert Cart.show_articles() == %{shirt: 1, jeans: 1}

    Cart.clear()

    assert Cart.show_articles() == %{}
  end

  test "increase number of articles if article added multiple time" do
    Cart.clear()

    :shirt |> Cart.add_article()
    :shirt |> Cart.add_article()

    assert Cart.show_articles() == %{shirt: 2}
  end

  test "decrease number of articles if article is removed " do
    Cart.clear()
    :shirt |> Cart.add_article()
    :shirt |> Cart.add_article()
    assert Cart.show_articles() == %{shirt: 2}

    :shirt |> Cart.remove_article()

    assert Cart.show_articles() == %{shirt: 1}
  end

  test "if non-exiting article removed, GenServer should terminate" do
    Cart.clear()

    try do
      :doesnt_exist |> Cart.remove_article()
      raise "GenServer didn't terminate"
    catch
      # GenServer terminated successfully as expected
      :exit, _ -> assert true
    end
  end

  test "terminated GenServer should perserve its state in the Recovery agent" do
    Cart.clear()
    :shirt |> Cart.add_article()
    :jeans |> Cart.add_article()
    assert Cart.show_articles() == %{shirt: 1, jeans: 1}

    try do
      :doesnt_exist |> Cart.remove_article()
      raise "GenServer didn't terminate"
    catch
      # GenServer terminated successfully as expected
      :exit, _ -> assert true
    end

    assert ShoppingCart.Recovery.get() == %{shirt: 1, jeans: 1}
  end

end
