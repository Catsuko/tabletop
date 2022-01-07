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
      iex>   |> Tabletop.take_turn(add: {%Tabletop.Piece{id: "Rook"}, {0, 0}})
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

      iex> %Tabletop.Board{pieces: %{1 => %Tabletop.Piece{id: "Rook"}}}
      iex>   |> Tabletop.get_piece(1)
      %Tabletop.Piece{attributes: %{}, id: "Rook"}

      iex> Tabletop.Board.square(3)
      iex>   |> Tabletop.get_piece({0, 0})
      nil

  """
  def get_piece(%Tabletop.Board{pieces: pieces}, position) do
    Map.get(pieces, position)
  end

  @doc """
  Checks if the provided `position` on the `board` is occupied by a piece.

  ## Examples

      iex> board = %Tabletop.Board{pieces: %{1 => %Tabletop.Piece{id: "Rook"}}}
      iex> Tabletop.occupied?(board, 1)
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
  def in_bounds?(%Tabletop.Board{pieces: pieces}, position) do
    Map.has_key?(pieces, position)
  end

end
