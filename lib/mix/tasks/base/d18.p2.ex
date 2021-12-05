defmodule Mix.Tasks.Base.D18.P2 do
  use Mix.Task

  import AdventOfCodeBase.Day18

  @shortdoc "Day 18 Part 2"
  def run(args) do
    input = nil

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
