defmodule GameOfLife.Cell do
  defstruct alive: false, x: nil, y: nil

  def new(x, y, alive) do
    %GameOfLife.Cell{x: x, y: y, alive: alive}
  end
end
