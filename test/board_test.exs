defmodule BoardTest do
  use ExUnit.Case
  doctest Tabletop.Board
  alias Tabletop.Board

  test "creates a square board" do
    expected_positions = %{
      {0, 0} => nil,
      {0, 1} => nil,
      {1, 0} => nil,
      {1, 1} => nil,
    }
    assert expected_positions == Board.square(2).pieces
  end

  test "assigns attribute" do
    result = Board.square(3)
      |> Board.assign(test: 1)
      |> Board.get(:test)
    assert result == 1
  end

  test "assigns multiple attributes" do
    %Tabletop.Board{attributes: attrs} = Board.square(3)
      |> Board.assign(winner: 1, loser: 2)
    assert Map.keys(attrs) == [:loser, :winner]
  end
end
