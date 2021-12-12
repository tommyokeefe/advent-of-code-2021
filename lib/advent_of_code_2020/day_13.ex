defmodule AdventOfCode2020.Day13 do
  alias AdventOfCode.ChineseRemainder

  def part1(args) do
    {departure_time, route} = parse(args)

    get_route_departure_times(departure_time, route)
    |> route_multiplied_by_wait()
  end

  def part2(args) do
    parse(args, :part_two) |> ChineseRemainder.compute()
  end

  def parse(input, part \\ :part_one)

  def parse(input, :part_one) do
    [departure_time | [routes]] = String.split(input, "\n", trim: true)

    {
      String.to_integer(departure_time),
      String.split(routes, ",", trim: true)
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer(&1))
    }
  end

  def parse(input, :part_two) do
    input
    |> String.split("\n", trim: true)
    |> Enum.at(-1)
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {x, _} -> x == "x" end)
    |> Enum.map(fn {v, idx} -> {String.to_integer(v), String.to_integer(v) - idx} end)
  end

  def get_route_departure_times(departure_time, routes) do
    Enum.map(routes, fn route ->
      {(div(departure_time, route) + 1) * route - departure_time, route}
    end)
  end

  def route_multiplied_by_wait(routes) do
    {minutes, route} = Enum.min(routes)
    minutes * route
  end
end

# Taken from @code-shoily's ChineseRemainderTheorem implementation - https://github.com/code-shoily/advent_of_code/blob/master/lib/helpers/chinese_remainder.ex
defmodule AdventOfCode.ChineseRemainder do
  @moduledoc """
  This module implements Chinese Remainder Theorem
  """

  @doc """
  Chinese Remainder Theorem.
  ## Example
    iex> AdventOfCode.Helpers.ChineseRemainder.compute([{11, 10}, {12, 4}, {13, 12}])
    1000
    iex> AdventOfCode.Helpers.ChineseRemainder.compute([{11, 10}, {22, 4}, {19, 9}])
    nil
    iex> AdventOfCode.Helpers.ChineseRemainder.compute([{3, 2}, {5, 3}, {7, 2}])
    23
  """
  def compute(congruences) do
    {modulii, residues} = Enum.unzip(congruences)
    mod_pi = Enum.reduce(modulii, 1, &Kernel.*/2)
    crt_modulii = Enum.map(modulii, &div(mod_pi, &1))

    case calculate_inverses(crt_modulii, modulii) do
      nil ->
        nil

      inverses ->
        crt_modulii
        |> Enum.zip(
          residues
          |> Enum.zip(inverses)
          |> Enum.map(&Tuple.product/1)
        )
        |> Enum.map(&Tuple.product/1)
        |> Enum.sum()
        |> mod(mod_pi)
    end
  end

  defp mod_inverse(a, b) do
    {_, x, y} = Integer.extended_gcd(a, b)
    (a * x + b * y == 1 && x) || nil
  end

  defp mod(a, m) do
    x = rem(a, m)
    (x < 0 && x + m) || x
  end

  defp calculate_inverses([], []), do: []

  defp calculate_inverses([n | ns], [m | ms]) do
    case mod_inverse(n, m) do
      nil -> nil
      inv -> [inv | calculate_inverses(ns, ms)]
    end
  end
end
