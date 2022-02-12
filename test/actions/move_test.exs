defmodule Actions.MoveTest do
  use ExUnit.Case
  alias Tabletop.Actions

  describe "move" do
    test "moving an empty position does not change the board" do
      board = Tabletop.Board.square(3)
      assert Actions.apply(board, :move, {{0, 0}, {1, 1}}) == board
    end

    test "moves a piece to another position" do
      board = Tabletop.Board.square(3)
        |> Actions.apply(:add, {Tabletop.Piece.new("Knight"), {0, 0}})
        |> Actions.apply(:move, {{0, 0}, {0, 1}})
      assert Tabletop.occupied?(board, {0, 1})
    end

    test "moving a piece to the same position does not change the board" do
      board = Tabletop.Board.square(3)
        |> Actions.apply(:add, {Tabletop.Piece.new("Rook"), {0, 0}})
      assert Actions.apply(board, :move, {{0, 0}, {0, 0}}) == board
    end
  end

  describe "step" do
    test "does not change the board if the piece is not found" do
      board = Tabletop.Board.square(3)
      assert Actions.apply(board, :step, {"some piece", {0, 1}}) == board
    end

    test "does not move a piece out of bounds" do
      piece = Tabletop.Piece.new("Sparrow")
      board = Tabletop.Board.square(3)
        |> Actions.apply(:add, {piece, {0, 0}})

      assert Actions.apply(board, :step, {piece.id, {-1, -1}})
    end

    test "moves the piece" do
      piece = Tabletop.Piece.new("Sparrow")
      board = Tabletop.Board.square(3)
        |> Actions.apply(:add, {piece, {0, 0}})
        |> Actions.apply(:step, {piece.id, {1, 1}})
      assert not Tabletop.occupied?(board, {0, 0})
      assert Tabletop.Piece.equal?(Tabletop.get_piece(board, {1, 1}), piece)
    end
  end
end
