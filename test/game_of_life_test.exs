defmodule GameOfLifeTest do
  use ExUnit.Case, async: true

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

  test "near_cells near vertex" do
    w = GameOfLife.World.new(10, 10)
    cell = GameOfLife.World.find_cell w, 1, 1
    near_cells = GameOfLife.World.near_cells(w, cell)
    assert length(near_cells) == 3
    assert hd(near_cells) == %GameOfLife.Cell{x: 2, y: 1, alive: false}
  end

  test "count alive" do
    c1 = GameOfLife.Cell.new(1,2,true)
    c2 = GameOfLife.Cell.new(1,2,true)
    c3 = GameOfLife.Cell.new(1,2,false)
    assert 2 == GameOfLife.World.count_alive([c1,c2])
    assert 2 == GameOfLife.World.count_alive([c1,c2, c3])
    assert 1 == GameOfLife.World.count_alive([c1])
    assert 0 == GameOfLife.World.count_alive([c3])
  end

  test "alive cells" do
    world = GameOfLife.World.new(2, 2, [{1, 2}, {2, 1}])
    c1 = GameOfLife.World.find_cell world, 1, 1
    c2 = GameOfLife.World.find_cell world, 1, 2
    c3 = GameOfLife.World.find_cell world, 2, 1
    c4 = GameOfLife.World.find_cell world, 2, 2
    refute c1.alive
    assert c2.alive
    assert c3.alive
    refute c4.alive
  end

  test "flasher" do
    world = GameOfLife.World.new(3, 1, [{1, 1}, {2, 1}, {3, 1}])
    new_world = GameOfLife.World.generation(world)
    assert_cell_status(world, 1, 1, true)
    assert_cell_status(world, 2, 1, true)
    assert_cell_status(world, 3, 1, true)
    assert_cell_status(new_world, 1, 1, false)
    assert_cell_status(new_world, 2, 1, true)
    assert_cell_status(new_world, 3, 1, false)
  end

  defp assert_cell_status(world, x, y, alive) do
    cell = GameOfLife.World.find_cell(world, x, y)
    assert cell.alive == alive
  end
end
