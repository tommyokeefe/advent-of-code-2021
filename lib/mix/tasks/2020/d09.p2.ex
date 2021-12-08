defmodule Mix.Tasks.Y20.D09.P2 do
  use Mix.Task

  import AdventOfCode2020.Day09

  @shortdoc "Day 09 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(9, 2020)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2(25) end}),
      else:
        input
        |> part2(25)
        |> IO.inspect(label: "Part 2 Results")
  end
end
