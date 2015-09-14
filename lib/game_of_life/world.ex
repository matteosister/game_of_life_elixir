defmodule GameOfLife.World do
  defstruct width: 10, height: 10, cells: []

  def new(width, height, alive_cells \\ []) do
    cells = create_cells(width, height, alive_cells)
    %GameOfLife.World{width: width, height: height, cells: cells}
  end

  defp create_cells(width, height, alive_cells) do
    1..height
    |> Enum.flat_map(fn (y) -> add_line(y, width, alive_cells) end)
  end

  defp add_line(y, width, alive_cells) do
    1..width
    |> Enum.map(fn (x) -> create_cell(x, y, alive_cells) end)
  end

  def create_cell(x, y, alive_cells) do
    GameOfLife.Cell.new(x, y, {x, y} in alive_cells)
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

  def count_alive(cells) do
    cells
    |> Enum.filter(fn (cell) -> cell.alive end)
    |> Enum.count
  end

  def next_cell_generation(world, cell = %GameOfLife.Cell{x: x, y: y, alive: false}) do
    near_cells_alive = count_alive(near_cells(world, cell))
    %GameOfLife.Cell{x: x, y: y, alive: near_cells_alive == 3}
  end

  def next_cell_generation(world, cell = %GameOfLife.Cell{x: x, y: y, alive: true}) do
    near_cells_alive = count_alive(near_cells(world, cell))
    %GameOfLife.Cell{x: x, y: y, alive: near_cells_alive == 2 || near_cells_alive == 3}
  end

  def next_generation(world = %GameOfLife.World{cells: cells}) do
    cells
    |> Enum.map(fn (cell) -> next_cell_generation(world, cell) end)
  end

  def generation(world = %GameOfLife.World{width: width, height: height}) do
    %GameOfLife.World{cells: next_generation(world), width: width, height: height}
  end

  def draw_world(w = %GameOfLife.World{width: width, height: height}) do
    1..height
    |> Enum.map(fn (y) -> draw_line(w, y, width) end)
  end

  defp draw_line(w, y, width) do
    1..width
    |> Enum.map(fn(x) -> draw_cell(find_cell(w, x, y)) end)
  end

  defp draw_cell(%GameOfLife.Cell{alive: true}) do
    "00"
  end

  defp draw_cell(%GameOfLife.Cell{alive: false}) do
    ".."
  end
end
