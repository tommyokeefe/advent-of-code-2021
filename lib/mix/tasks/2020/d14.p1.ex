defmodule Mix.Tasks.Y20.D14.P1 do
  use Mix.Task

  import AdventOfCode2020.Day14

  @shortdoc "Day 14 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(14, 2020)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
