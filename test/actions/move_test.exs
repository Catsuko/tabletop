defmodule Actions.MoveTest do
  use ExUnit.Case
  alias Tabletop.Actions

  test "moving an empty position does not change the board" do
    board = Tabletop.Board.square(3)
    assert Actions.apply(board, :move, {{0, 0}, {1, 1}}) == board
  end

  test "moves a piece to another position" do
    board = Tabletop.Board.square(3)
      |> Actions.apply(:add, {%Tabletop.Piece{id: "Knight"}, {0, 0}})
      |> Actions.apply(:move, {{0, 0}, {0, 1}})

    assert Tabletop.occupied?(board, {0, 1})
  end

  test "moving a piece to the same position does not change the board" do
    board = Tabletop.Board.square(3)
      |> Actions.apply(:add, {%Tabletop.Piece{id: "Rook"}, {0, 0}})

    assert Actions.apply(board, :move, {{0, 0}, {0, 0}}) == board
  end
end
