defmodule Tabletop.Piece do
  @moduledoc """
  This module provides the struct for representing pieces on the board
  as well as functions to manipulate them.

  ## The Tabletop.Piece Struct

  The public fields are:

    * `id`         - An identifier used for display or querying
    * `attributes` - A map of attributes held by the piece

  """

  @enforce_keys [:id]
  defstruct [:id, attributes: %{}]

  @doc """
  Assigns the provided `attributes` to the `piece`. Any existing attributes that
  share a key will be overridden.
  """
  def assign(piece, attributes) do
    %Tabletop.Piece{piece | attributes: Enum.into(attributes, piece.attributes)}
  end

  @doc """
  Checks if two pieces are the same by comparing ids.
  """
  def equal?(%Tabletop.Piece{id: a}, %Tabletop.Piece{id: b}) do
    a == b
  end

  def equal?(_, _) do
    false
  end
end
