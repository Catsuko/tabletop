defmodule Grid do
  @moduledoc """
  This module provides functions specific to traversing a square board
  where positions are represented by 2D coordinate Tuples.
  """

  @doc """
  Returns a list of neighbours from the given position, 1 unit in each
  cardinal direction.
  """
  def cardinal_points({x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  end

  @doc """
  Adds two coordinates together and returns the sum.
  """
  def add({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end
end
