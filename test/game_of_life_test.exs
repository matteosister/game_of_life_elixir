defmodule GameOfLifeTest do
  use ExUnit.Case

  test "draw" do
    w = GameOfLife.World.new(10, 10)
    assert length(w.cells) == w.width * w.height
  end

  test "find_cell" do
    w = GameOfLife.World.new(10, 10)
    cell = GameOfLife.World.find_cell w, 2, 2
    assert cell.x == 2
    assert cell.y == 2
  end

  test "near_cells length" do
    w = GameOfLife.World.new(10, 10)
    cell = GameOfLife.World.find_cell w, 5, 5
    near_cells = GameOfLife.World.near_cells(w, cell)
    assert length(near_cells) == 8
  end

  test "near_cells in vertex" do
    w = GameOfLife.World.new(10, 10)
    cell = GameOfLife.World.find_cell w, 1, 1
    near_cells = GameOfLife.World.near_cells(w, cell)
    assert length(near_cells) == 3
    assert hd(near_cells) == %GameOfLife.Cell{x: 2, y: 1, alive: true}
  end
end
