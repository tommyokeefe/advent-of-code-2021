defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn string_list -> Enum.map(string_list, &check_binary_value/1) end)
    |> Enum.reduce([], &binary_values_reducer/2)
    |> Enum.reduce(["", ""], &get_gamma_and_epsilon/2)
    |> get_power_consumption
  end

  def part2(args) do
    binary_as_maps =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn string_list -> Enum.map(string_list, &check_binary_value/1) end)

    oxygen_rating = get_rating(binary_as_maps, 0, :oxygen)
    co2_rating = get_rating(binary_as_maps, 0, :co2)
    oxygen_rating * co2_rating
  end

  def check_binary_value("0") do
    %{zeros: 1, ones: 0}
  end

  def check_binary_value("1") do
    %{zeros: 0, ones: 1}
  end

  def binary_values_reducer(list, []) do
    list
  end

  def binary_values_reducer(list, accumulator) do
    add_binary_values(list, accumulator, [])
  end

  def add_binary_values([], _sums, result) do
    Enum.reverse(result)
  end

  def add_binary_values([current_value | values], [current_sum | sums], result) do
    total = [
      %{
        zeros: current_value.zeros + current_sum.zeros,
        ones: current_value.ones + current_sum.ones
      }
      | result
    ]

    add_binary_values(values, sums, total)
  end

  def get_gamma_and_epsilon(count, [gamma | [epsilon]]) do
    cond do
      count.zeros > count.ones ->
        ["#{gamma}0", "#{epsilon}1"]

      count.ones > count.zeros ->
        ["#{gamma}1", "#{epsilon}0"]
    end
  end

  def get_power_consumption([gamma | [epsilon]]) do
    gamma_int = Integer.parse(gamma, 2) |> elem(0)
    epsilon_int = Integer.parse(epsilon, 2) |> elem(0)
    gamma_int * epsilon_int
  end

  def get_majority_value(data, location) do
    [item] =
      data
      |> Enum.map(fn item ->
        [Enum.at(item, location)]
      end)
      |> Enum.reduce([], &binary_values_reducer/2)

    cond do
      item.zeros > item.ones -> :zeros
      item.ones > item.zeros -> :ones
      item.ones == item.zeros -> :equal
    end
  end

  def get_rating([result | []], _location, _rating_type) do
    result
    |> Enum.reduce("", fn item, accumulator ->
      cond do
        item.zeros == 1 -> "#{accumulator}0"
        item.ones == 1 -> "#{accumulator}1"
      end
    end)
    |> Integer.parse(2)
    |> elem(0)
  end

  def get_rating(data, location, rating_type) do
    value = get_majority_value(data, location)
    new_data = rating_filter(value, data, location, rating_type)
    get_rating(new_data, location + 1, rating_type)
  end

  def rating_filter(value, data, location, rating_type) do
    data
    |> Enum.filter(fn item ->
      digit = Enum.at(item, location)
      matches_rating(rating_type, value, digit)
    end)
  end

  def matches_rating(:oxygen, value, item) do
    cond do
      value == :equal -> item.ones == 1
      value == :ones -> item.ones == 1
      value == :zeros -> item.zeros == 1
    end
  end

  def matches_rating(:co2, value, item) do
    cond do
      value == :equal -> item.zeros == 1
      value == :ones -> item.zeros == 1
      value == :zeros -> item.ones == 1
    end
  end
end
