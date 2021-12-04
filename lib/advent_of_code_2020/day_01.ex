defmodule AdventOfCode2020.Day01 do
  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_numbers
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_numbers(:three)
  end

  def find_numbers([first_number | list]) do
    result = Enum.find(list, nil, fn second_number -> first_number + second_number == 2020 end)

    case result do
      nil -> find_numbers(list)
      _ -> result * first_number
    end
  end

  def find_numbers([first_number | list], :three) do
    find_numbers(list, first_number, list)
  end

  def find_numbers([second_number | list], first_number, reserve_list) do
    result =
      Enum.find(list, nil, fn third_number ->
        first_number + second_number + third_number == 2020
      end)

    case result do
      nil -> find_numbers(list, first_number, reserve_list)
      _ -> result * first_number * second_number
    end
  end

  def find_numbers([], _first_number, reserve_list) do
    [new_first_number | list] = reserve_list
    find_numbers(list, new_first_number, list)
  end
end
