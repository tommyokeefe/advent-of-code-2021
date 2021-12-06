defmodule Mix.Tasks.Y20.D18.P1 do
  use Mix.Task

  import AdventOfCode2020.Day18

  @shortdoc "Day 18 Part 1"
  def run(args) do
    input = nil

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
