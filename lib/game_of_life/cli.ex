defmodule GameOfLife.CLI do
  require Integer

  def main(args) do
    {parsed, argv, errors} = args
    |> parse
    {w, _} = Integer.parse(Enum.at(argv, 0))
    {h, _} = Integer.parse(Enum.at(argv, 1))
    IO.puts "Game of life"
    IO.puts "width: #{w}, height: #{h}"
    w = GameOfLife.World.new(w, h, [
      {5,5},{7,5},{9,5},
      {5,6},{9,6},
      {5,7},{9,7},
      {5,8},{9,8},
      {5,9},{7,9},{9,9},
    ])

    Enum.reduce(1..50, w, fn (i, world) ->
      IO.puts "\e[2J"
      IO.puts "Iterazione #{i}"
      output = GameOfLife.World.draw_world(world)
      Enum.each(output, &IO.puts/1)
      new_world = GameOfLife.World.generation(world)
      :timer.sleep(100)
      new_world
    end)
  end

  defp parse(args) do
    OptionParser.parse(args, switches: [:w, :h])
  end
end
