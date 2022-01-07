defmodule Actions.RemoveTest do
  use ExUnit.Case
  alias Tabletop.Actions

  test "nothing happens when removing from an empty space" do
    board = Tabletop.Board.square(3)
    modified_board = board
      |> Actions.apply(:remove, {0, 0})

    assert board == modified_board
  end

  test "nothing happens when removing from an out of bounds space" do
    board = Tabletop.Board.square(3)
    modified_board = board
      |> Actions.apply(:remove, {99, 99})

    assert board == modified_board
  end

  test "piece at position is removed" do
    position = {0, 0}
    board = Tabletop.Board.square(3)
      |> Actions.apply(:add, {%Tabletop.Piece{id: "Rook"}, position})
      |> Actions.apply(:remove, position)

    assert not Tabletop.occupied?(board, position)
  end
end
