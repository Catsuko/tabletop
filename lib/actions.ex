defmodule Tabletop.Actions do
  @moduledoc """
  This module provides the fundamental actions involved in any tabletop game. Each action
  consists of a key and then an arguments value:

    * `:move   => {from, to}`
    * `:add    => {piece, position}`
    * `:remove => position`
    * `:assign => {position, attributes}`

  A game will take a combination of these actions which will then form a turn. For more information
  see the `Tabletop.take_turn/2` function.
  """

  @doc """

  Applies a particular action to the `board`. The type of action is determined by the atom
  provided with `arg2`. This will then be mapped to a specific behaviour such as Moving
  or Adding a piece. If the type of action has not been implemented then the board will
  be returned with no changes made.

  ## Moving a Piece

    * `arg2`      => `:move`
    * `arguments` => `{from, to}`

  Moves the piece at the `from` position to the `to` position. Any existing pieces at the
  `to` position will be removed from the board and replaced by the moving piece.

  In the case that there is no piece to move, nothing will happen and the unchanged
  board struct will be returned.

  ## Adding a Piece

    * `arg2`     => `:add`
    * `arguments` => `{%Tabletop.Piece{}, position}`

  Adds the provided `piece` to the `position` on the `board`. Existing pieces will be
  removed from the `board` and replaced.

  If the `position` is not within the bounds of the `board`, the unchanged `board`
  will be returned.

  ## Removing a Piece

    * `arg2`     => `:remove`
    * `arguments` => `position`

  Removes the piece at the provided `position` if it is occupied. Does nothing to the `board`
  if the `position` does not contain a piece.

  ## Assigning Attributes to a Piece

    * `arg2`     => `:assign`
    * `arguments` => `%{}`

  Assigns the provided `attributes` to the piece at the provided `position`. If
  it does not exist then the unchanged `board` will be returned.
  """
  def apply(board, :move, {from, to}) do
    case Tabletop.get_piece(board, from) do
      %Tabletop.Piece{} = piece ->
        updated_pieces = Map.merge board.pieces, %{
          from => nil,
          to => piece
        }
        %Tabletop.Board{board | pieces: updated_pieces}
      nil ->
        board
    end
  end

  def apply(board, :add, {%Tabletop.Piece{} = piece, position}) do
    if Tabletop.in_bounds?(board, position) do
      updated_pieces = Map.merge(board.pieces, %{position => piece})
      %Tabletop.Board{board | pieces: updated_pieces}
    else
      board
    end
  end

  def apply(board, :remove, position) do
    if Tabletop.occupied?(board, position) do
      updated_pieces = Map.merge(board.pieces, %{position => nil})
      %Tabletop.Board{board | pieces: updated_pieces}
    else
      board
    end
  end

  def apply(board, :assign, {position, attributes}) do
    case Tabletop.get_piece(board, position) do
      %Tabletop.Piece{} = piece ->
        updated_pieces = Map.merge(board.pieces, %{
          position => Tabletop.Piece.assign(piece, attributes)
        })
        %Tabletop.Board{board | pieces: updated_pieces}
      nil ->
        board
    end
  end

  def apply(board, _key, _args) do
    board
  end

end
