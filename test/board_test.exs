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
end
