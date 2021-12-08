defmodule AdventOfCode2020.Day10 do
  def part1(args) do
    list = parse(args)
    [max | _] = list
    list = [0 | Enum.reverse([max + 3 | list])]
    [first_item | list] = list
    {ones, _, threes} = get_jolt_differences(first_item, list, {0, 0, 0})
    ones * threes
  end

  def part2(args) do
    list = parse(args)
    [max | _] = list
    list = [0 | Enum.reverse([max + 3 | list])]
    get_number_of_possible_configurations(Enum.reverse(list))
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort(&(&1 >= &2))
  end

  def get_jolt_differences(item, [second_item | list], {ones, twos, threes}) do
    difference = abs(item - second_item)

    cond do
      difference == 1 -> get_jolt_differences(second_item, list, {ones + 1, twos, threes})
      difference == 2 -> get_jolt_differences(second_item, list, {ones, twos + 1, threes})
      difference == 3 -> get_jolt_differences(second_item, list, {ones, twos, threes + 1})
    end
  end

  def get_jolt_differences(_item, [], differences) do
    differences
  end

  def get_number_of_possible_configurations(list) do
    optional_adapters =
      Enum.reduce(Enum.chunk_every(list, 3, 1, :discard), [], fn chunk, optional ->
        {one, two, three} = List.to_tuple(chunk)

        cond do
          abs(one - three) <= 3 -> [two | optional]
          true -> optional
        end
      end)

    configurations =
      Enum.reduce(optional_adapters, 1, fn adapter, total ->
        cond do
          Enum.member?(optional_adapters, adapter + 1) and
              Enum.member?(optional_adapters, adapter + 2) ->
            total + 3 * total / 4

          true ->
            total * 2
        end
      end)

    round(configurations)
  end
end
