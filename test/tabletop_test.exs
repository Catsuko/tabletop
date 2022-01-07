defmodule TabletopTest do
  use ExUnit.Case
  doctest Tabletop

  test "position is out of bounds" do
    result = Tabletop.Board.square(3)
      |> Tabletop.in_bounds?({-1, -1})

    assert not result
  end

  test "position is within bounds" do
    result = Tabletop.Board.square(3)
      |> Tabletop.in_bounds?({0, 0})

    assert result
  end

  test "taking a turn advances the turn count" do
    board = Tabletop.Board.square(3)
      |> Tabletop.take_turn([])

    assert board.turn == 2
  end
end
