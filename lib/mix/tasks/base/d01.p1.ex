defmodule Mix.Tasks.Base.D01.P1 do
  use Mix.Task

  import AdventOfCodeBase.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
