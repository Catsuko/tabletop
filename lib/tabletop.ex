defmodule Tabletop do
  @moduledoc """
  Tabletop contains functions for playing a board game and querying the state of the game.

  ## Taking Turns

  Taking a turn involves calling the `take_turn/2` function which follows these steps:

  1. Apply provided actions - e.g. add a piece, move a piece
  2. Apply board effects - e.g. check if a player has won
  3. Increment the turn counter

  To find out more about actions or effects, check the `Tabletop.Actions` or `Tabletop.Board`
  modules respectively.
  """

  alias Tabletop.Board

  @doc """
  Applies the provided `actions` to the board and then advances to the next turn.
  Actions consist of a combination of the following:

    * `:move   => {from, to}`
    * `:add    => {piece, position}`
    * `:remove => position`
    * `:assign => {position, attributes}`

  For example, a Chess turn might see a single `:move` action or two `:move` actions in the
  case of castling.

  ## Examples

      iex> %Tabletop.Board{}
      iex>   |> Tabletop.take_turn(%{})
      %Tabletop.Board{turn: 2}

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.take_turn(add: {Tabletop.Piece.new("Rook"), {0, 0}})
      iex>   |> Tabletop.take_turn(move: {{0, 0}, {0, 1}})
      iex>   |> Tabletop.get_piece({0, 1})
      %Tabletop.Piece{id: "Rook"}

  """
  def take_turn(board, actions) do
    board
      |> Board.apply_actions(actions)
      |> Board.apply_effects()
      |> Board.advance_turn()
  end

  @spec get_piece(atom | %{:pieces => map, optional(any) => any}, any) :: any
  @doc """
  Returns the piece on the `board` at `position`.

  ## Examples

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.Actions.apply(:add,  {Tabletop.Piece.new("Rook"), {0, 0}})
      iex>   |> Tabletop.get_piece({0, 0})
      %Tabletop.Piece{id: "Rook"}

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.get_piece({1, 0})
      nil

  """
  def get_piece(%Board{pieces: pieces}, position) do
    Map.get(pieces, position)
  end

  @doc """
  Checks if the provided `position` on the `board` is occupied by a piece.

  ## Examples

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.Actions.apply(:add, {Tabletop.Piece.new("Rook"), {0, 0}})
      iex>   |> Tabletop.occupied?({0, 0})
      true

  """
  def occupied?(board, position) do
    get_piece(board, position) != nil
  end

  @doc """
  Checks if the provided `position` is within the bounds of the `board`.

  ## Examples

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.in_bounds?({0, 0})
      true

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.in_bounds?({99, 99})
      false

  """
  def in_bounds?(%Board{pieces: pieces}, position) do
    Map.has_key?(pieces, position)
  end

  @doc """
  Lazily moves through positions on the board starting from `starting_position`. Each element
  returned be a Tuple containing the position and piece at that position.

  Invokes `fun` with the current position in order to determine the next position.

  If the position does not contain a piece, the second element of the returned
  Tuple will be `nil` instead.

  Once the position is out of bounds, no more elements will be returned.

  ## Examples

    iex> Tabletop.Board.square(3)
    iex>   |> Tabletop.travel({0, 0}, fn {x, y} -> {x + 1, y + 1} end)
    iex>   |> Enum.to_list()
    [{{0, 0}, nil}, {{1, 1}, nil}, {{2, 2}, nil}]

  """
  def travel(board, starting_position, fun) do
    Stream.unfold(starting_position, fn pos ->
      if in_bounds?(board, pos), do: {pos, fun.(pos)}, else: nil
    end)
      |> Stream.map(fn pos -> {pos, get_piece(board, pos)} end)
  end

  @doc """
  Lazily moves through positions on the board starting from `starting_position` and
  returns sets of neighbouring positions. Each element will be a tuple containing
  two positions.

  Invokes `fun` with the current position in order to determine the positions of
  neighbours.

  Once every set of neighbouring positions are covered, no more elements will be returned.

  ## Examples

    iex> Tabletop.Board.square(3)
    iex>   |> Tabletop.neighbours({0, 0}, &Grid.cardinal_points/1)
    iex>   |> Enum.take(2)
    [{{0, 0}, {1, 0}}, {{0, 0}, {0, 1}}]

  """
  def neighbours(board, starting_position, fun) do
    Stream.unfold({[starting_position], MapSet.new()}, fn
      {[head | tail], checked} ->
        neighbouring_positions = fun.(head)
          |> Stream.filter(fn pos -> in_bounds?(board, pos) end)
          |> Enum.reject(fn pos -> MapSet.member?(checked, pos) end)
        pairs = Stream.map(neighbouring_positions, fn pos -> {head, pos} end)
        {pairs, {Enum.uniq(neighbouring_positions ++ tail), MapSet.put(checked, head)}}
      _ ->
        nil
    end)
      |> Stream.flat_map(fn item -> item end)
  end

end
