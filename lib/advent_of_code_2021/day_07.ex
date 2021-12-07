defmodule AdventOfCode.Day07 do
  def part1(args) do
    crabs = parse(args)
    positions = Enum.to_list(Enum.min(crabs)..Enum.max(crabs))
    find_most_efficient_position(crabs, positions, &calculate_constant_consumption/3)
  end

  def part2(args) do
    crabs = parse(args)
    positions = Enum.to_list(Enum.min(crabs)..Enum.max(crabs))
    find_most_efficient_position(crabs, positions, &calculate_variable_consumption/3)
  end

  def parse(data) do
    Enum.at(String.split(data, "\n"), 0)
    |> String.split(",", trim: true)
    |> Enum.map(fn number -> String.to_integer(number) end)
  end

  def find_most_efficient_position(crabs, positions, consumption) do
    Enum.reduce(positions, 0, fn position, minimum_fuel_consumption ->
      fuel_consumption =
        Enum.reduce(crabs, 0, fn crab, total ->
          consumption.(crab, position, total)
        end)

      cond do
        minimum_fuel_consumption == 0 -> fuel_consumption
        fuel_consumption < minimum_fuel_consumption -> fuel_consumption
        true -> minimum_fuel_consumption
      end
    end)
  end

  def calculate_constant_consumption(crab, position, total) do
    abs(position - crab) + total
  end

  def calculate_variable_consumption(crab, position, total) do
    distance = abs(position - crab)
    div(distance * (distance + 1), 2) + total
  end
end
