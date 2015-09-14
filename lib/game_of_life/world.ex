defmodule GameOfLife.World do
  defstruct width: 10, height: 10, cells: []

  def new(width, height) do
    cells = create_cells(width, height)
    %GameOfLife.World{width: width, height: height, cells: cells}
  end

  defp create_cells(width, height) do
    1..height
    |> Enum.flat_map(fn (y) -> add_line(y, width) end)
  end

  defp add_line(y, width) do
    1..width
    |> Enum.map(fn (x) -> GameOfLife.Cell.new(x, y, true) end)
  end

  def find_cell(%GameOfLife.World{cells: cells}, x, y) do
    Enum.find(cells, fn (cell) -> cell.x == x && cell.y == y end)
  end

  def near_cells(world, cell) do
    cells = []
    cells = cells ++ [find_cell(world, cell.x - 1, cell.y)]
    cells = cells ++ [find_cell(world, cell.x - 1, cell.y - 1)]
    cells = cells ++ [find_cell(world, cell.x, cell.y - 1)]
    cells = cells ++ [find_cell(world, cell.x + 1, cell.y - 1)]
    cells = cells ++ [find_cell(world, cell.x + 1, cell.y)]
    cells = cells ++ [find_cell(world, cell.x - 1, cell.y + 1)]
    cells = cells ++ [find_cell(world, cell.x, cell.y + 1)]
    cells = cells ++ [find_cell(world, cell.x + 1, cell.y + 1)]
    cells |> Enum.filter(fn(cell) -> not is_nil(cell)  end)
  end
end
