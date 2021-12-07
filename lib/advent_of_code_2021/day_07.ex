defmodule AdventOfCode.Day07 do
  def part1(args) do
    crabs = parse(args)
    positions = Enum.to_list(Enum.min(crabs)..Enum.max(crabs))
    find_most_efficient_position(crabs, positions, :constant_consumption)
  end

  def part2(args) do
    crabs = parse(args)
    positions = Enum.to_list(Enum.min(crabs)..Enum.max(crabs))
    find_most_efficient_position(crabs, positions, :variable_consumption)
  end

  def parse(data) do
    data = Enum.at(String.split(data, "\n"), 0)

    data
    |> String.split(",", trim: true)
    |> Enum.map(fn number -> String.to_integer(number) end)
  end

  def find_most_efficient_position(crabs, positions, :constant_consumption) do
    find_most_efficient_position(crabs, positions, 0, :constant_consumption)
  end

  def find_most_efficient_position(crabs, positions, :variable_consumption) do
    find_most_efficient_position(crabs, positions, 0, :variable_consumption)
  end

  def find_most_efficient_position(crabs, [position | positions], minimum_fuel_used, consumption) do
    fuel_used =
      Enum.reduce(crabs, 0, fn crab, total ->
        cond do
          consumption == :constant_consumption ->
            calculate_constant_consumption(crab, position, total)

          consumption == :variable_consumption ->
            calculate_variable_consumption(crab, position, total)
        end
      end)

    cond do
      minimum_fuel_used == 0 ->
        find_most_efficient_position(crabs, positions, fuel_used, consumption)

      fuel_used < minimum_fuel_used ->
        find_most_efficient_position(crabs, positions, fuel_used, consumption)

      true ->
        find_most_efficient_position(crabs, positions, minimum_fuel_used, consumption)
    end
  end

  def find_most_efficient_position(_crabs, [], minimum_fuel_used, _consumption) do
    minimum_fuel_used
  end

  def calculate_constant_consumption(crab, position, total) do
    abs(position - crab) + total
  end

  def calculate_variable_consumption(crab, position, total) do
    distance = abs(position - crab)
    div(distance * (distance + 1), 2) + total
  end
end
