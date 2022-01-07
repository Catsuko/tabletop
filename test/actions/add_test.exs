defmodule Actions.AddTest do
  use ExUnit.Case
  alias Tabletop.Actions

  test "piece can be placed on the board" do
    position = {0, 0}
    board = Tabletop.Board.square(3)
      |> Actions.apply(:add, {%Tabletop.Piece{id: "Knight"}, position})

    assert Tabletop.occupied?(board, position)
  end

  test "piece cannot be placed off the board" do
    original_board = Tabletop.Board.square(3)
    modified_board = original_board
      |> Actions.apply(:add, {%Tabletop.Piece{id: "Knight"}, {99, 99}})

    assert original_board == modified_board
  end
end
