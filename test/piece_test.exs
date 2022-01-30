defmodule PieceTest do
  use ExUnit.Case
  doctest Tabletop.Piece

  describe "equals?" do
    test "one side is nil" do
      piece_a = %Tabletop.Piece{id: "a"}
      piece_b = nil
      assert not Tabletop.Piece.equal?(piece_a, piece_b)
    end

    test "other side is nil" do
      piece_a = nil
      piece_b = %Tabletop.Piece{id: "b"}
      assert not Tabletop.Piece.equal?(piece_a, piece_b)
    end

    test "pieces share id" do
      piece_a = %Tabletop.Piece{id: "a"}
      piece_b = %Tabletop.Piece{id: "a"}
      assert Tabletop.Piece.equal?(piece_a, piece_b)
    end

    test "pieces do not share id" do
      piece_a = %Tabletop.Piece{id: "a"}
      piece_b = %Tabletop.Piece{id: "b"}
      assert not Tabletop.Piece.equal?(piece_a, piece_b)
    end
  end

end
