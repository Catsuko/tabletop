defmodule TabletopTest do
  use ExUnit.Case
  doctest Tabletop

  describe "in_bounds?" do
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
  end

  describe "taking turn" do
    test "advances the turn count" do
      board = Tabletop.Board.square(3)
        |> Tabletop.take_turn([])

      assert board.turn == 2
    end
  end

  describe "travel" do
    test "no moves when out of bounds" do
      result = Tabletop.Board.square(5)
        |> Tabletop.travel({-50, -50}, fn {x, y} -> {x + 1, y} end)

      assert Enum.count(result) == 0
    end

    test "does not move out of bounds" do
      result = Tabletop.Board.square(1)
        |> Tabletop.travel({0, 0}, fn {x, y} -> {x + 1, y} end)
        |> Enum.to_list()
      assert [{{0, 0}, nil}] == result
    end

    test "returns pieces on the path" do
      result = Tabletop.Board.square(3)
        |> Tabletop.Actions.apply(:add, {%Tabletop.Piece{id: "test"}, {0, 0}})
        |> Tabletop.travel({0, 2}, fn {x, y} -> {x, y - 1} end)
        |> Enum.to_list()

      assert result == [
        {{0, 2}, nil},
        {{0, 1}, nil},
        {{0, 0}, %Tabletop.Piece{id: "test"}}
      ]
    end
  end

  describe "neighbours" do
    test "does not provide pairs that are out of bounds" do
      board = Tabletop.Board.square(3)
      positions = Tabletop.neighbours(board, {1, 1}, &Tabletop.Grid.cardinal_points/1)
        |> Enum.flat_map(&Tuple.to_list/1)
      assert Enum.all? positions, fn pos -> Tabletop.in_bounds?(board, pos) end
    end

    test "middle tile has 4 neighbours" do
      middle = {1, 1}
      middle_pairs_count = Tabletop.Board.square(3)
        |> Tabletop.neighbours({0, 0}, &Tabletop.Grid.cardinal_points/1)
        |> Enum.count(fn {pos_a, pos_b} ->
          pos_a == middle or pos_b == middle
        end)
      assert middle_pairs_count == 4
    end

    test "corner tile has 2 neighbours" do
      corner = {2, 2}
      corner_pairs_count = Tabletop.Board.square(3)
        |> Tabletop.neighbours({1, 1}, &Tabletop.Grid.cardinal_points/1)
        |> Enum.count(fn {pos_a, pos_b} ->
          pos_a == corner or pos_b == corner
        end)
      assert corner_pairs_count == 2
    end
  end
end
