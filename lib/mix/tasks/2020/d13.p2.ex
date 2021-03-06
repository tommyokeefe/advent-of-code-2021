defmodule Mix.Tasks.Y20.D13.P2 do
  use Mix.Task

  import AdventOfCode2020.Day13

  @shortdoc "Day 13 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(13, 2020)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
