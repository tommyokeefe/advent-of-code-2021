defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&binary_to_tuple/1)
    |> Enum.reduce([], &value_reducer/2)
    |> Enum.reduce({"", ""}, &gamma_and_epsilon/2)
    |> gamma_and_epsilon_to_integer
    |> Tuple.product()
  end

  def part2(args) do
    binary_as_tuples =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&binary_to_tuple/1)

    oxygen_rating = get_rating(binary_as_tuples, 0, :oxygen)
    co2_rating = get_rating(binary_as_tuples, 0, :co2)
    oxygen_rating * co2_rating
  end

  def binary_to_tuple(list) do
    Enum.map(list, fn
      "0" -> {1, 0}
      "1" -> {0, 1}
    end)
  end

  def value_reducer(list, []) do
    list
  end

  def value_reducer(list, accumulator) do
    line_reducer(list, accumulator, [])
  end

  def line_reducer([], _sums, result) do
    Enum.reverse(result)
  end

  def line_reducer([{1, 0} | items], [{zeros, ones} | sums], result) do
    total = [{zeros + 1, ones} | result]
    line_reducer(items, sums, total)
  end

  def line_reducer([{0, 1} | items], [{zeros, ones} | sums], result) do
    total = [{zeros, ones + 1} | result]
    line_reducer(items, sums, total)
  end

  def gamma_and_epsilon({zeros, ones}, {gamma, epsilon}) do
    cond do
      zeros > ones -> {gamma <> "0", epsilon <> "1"}
      zeros < ones -> {gamma <> "1", epsilon <> "0"}
    end
  end

  def gamma_and_epsilon_to_integer({gamma, epsilon}) do
    {Integer.parse(gamma, 2) |> elem(0), Integer.parse(epsilon, 2) |> elem(0)}
  end

  def get_majority_value(data, location) do
    [{zeros, ones}] =
      data
      |> Enum.map(fn item ->
        [Enum.at(item, location)]
      end)
      |> Enum.reduce([], &value_reducer/2)

    cond do
      zeros > ones -> :zeros
      ones > zeros -> :ones
      ones == zeros -> :equal
    end
  end

  def get_rating([result | []], _index, _rating_type) do
    result
    |> Enum.reduce("", fn {zeros, ones}, accumulator ->
      cond do
        zeros == 1 -> "#{accumulator}0"
        ones == 1 -> "#{accumulator}1"
      end
    end)
    |> Integer.parse(2)
    |> elem(0)
  end

  def get_rating(data, index, rating_type) do
    value = get_majority_value(data, index)
    new_data = rating_filter(value, data, index, rating_type)
    get_rating(new_data, index + 1, rating_type)
  end

  def rating_filter(value, data, location, rating_type) do
    data
    |> Enum.filter(fn item ->
      digit = Enum.at(item, location)
      matches_rating(rating_type, value, digit)
    end)
  end

  def matches_rating(:oxygen, value, {zeros, ones}) do
    cond do
      value == :equal -> ones == 1
      value == :ones -> ones == 1
      value == :zeros -> zeros == 1
    end
  end

  def matches_rating(:co2, value, {zeros, ones}) do
    cond do
      value == :equal -> zeros == 1
      value == :ones -> zeros == 1
      value == :zeros -> ones == 1
    end
  end
end
