defmodule Tabletop.Board do
  @moduledoc """
  This module provides the struct for representing the board of a tabletop game
  as well as the functions for creating and manipulating it.

  ## The Tabletop.Board Struct

  The public fields are:

    * `pieces` - A map comprised of position keys and piece values, empty positions
    contain `nil` values
    * `attributes` - A map of attributes held by the board
    * `turn` - A number that represents the current turn
    * `effects` - A list of functions that are applied at the end of each turn

  ## Effects

  At the end of each turn, the board will invoke each of its' effects in turn. Each effect
  should accept the board as input and return a board as output. This allows a game to perform
  updates before the end of each turn like spawning some zombies or determining if the game
  is over.

  """
  defstruct [pieces: %{}, attributes: %{}, turn: 1, effects: []]

  alias Tabletop.Actions

  @doc """
  Creates a `%Tabletop.Board` with empty positions forming a square grid. Each position
  is a tuple containing `x` and `y` coordinates.
  """
  def square(size) do
    positions = for x <- 0..size-1, do: List.flatten(for y <- 0..size-1, do: {x, y})
    pieces = Enum.reduce List.flatten(positions), %{}, fn pos, map ->
      Map.put(map, pos, nil)
    end
    %Tabletop.Board{pieces: pieces}
  end

  @doc """
  Assigns the provided `attributes` to the `board`. Any existing attributes that share
  a key will be overriden.
  """
  def assign(board, attributes) do
    %Tabletop.Board{board | attributes: Map.merge(board.attributes, attributes)}
  end

  @doc """
  Adds the provided `effects` to the `board`. Each effect should be a function that accepts a board
  and then returns a board.

  A single `effect` may also be provided.
  """
  def add_effects(board, effects) do
    %Tabletop.Board{board | effects: board.effects ++ List.wrap(effects)}
  end

  @doc """
  Increments the turn count of the `board` by 1.
  """
  def advance_turn(board) do
    %Tabletop.Board{board | turn: board.turn + 1}
  end

  @doc """
  Applies the list of `actions` to the `board` in order and then returns the resulting board.
  """
  def apply_actions(board, actions) do
    Enum.reduce actions, board, fn {action, args}, acc ->
      Actions.apply(acc, action, args)
    end
  end

  @doc """
  Invokes each of the board's effects in order and then returns the affected board.
  """
  def apply_effects(board) do
    Enum.reduce board.effects, board, fn effect, acc ->
      effect.(acc)
    end
  end
end
