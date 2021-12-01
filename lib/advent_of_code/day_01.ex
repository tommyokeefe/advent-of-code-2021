defmodule AdventOfCode.Day01 do
  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> depth_increase(0)
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> get_window_depths([])
    |> depth_increase(0)
  end

  def depth_increase([head | tail], accumulator) do
    depth_increase(tail, accumulator, head)
  end

  def depth_increase([head | tail], accumulator, last_depth) when head > last_depth do
    depth_increase(tail, accumulator + 1, head)
  end

  def depth_increase([head | tail], accumulator, _last_depth) do
    depth_increase(tail, accumulator, head)
  end

  def depth_increase([], accumulator, _last_depth) do
    accumulator
  end

  def get_window_depths([head | tail], window_depths) do
    get_window_depths(tail, window_depths, head)
  end

  def get_window_depths([head | tail], window_depths, window_one) do
    get_window_depths(tail, window_depths, window_one + head, head)
  end

  def get_window_depths([head | tail], window_depths, window_one, window_two) do
    window_depths = [window_one + head | window_depths]
    get_window_depths(tail, window_depths, window_two + head, head)
  end

  def get_window_depths([], window_depths, _window_one, _window_two) do
    Enum.reverse(window_depths)
  end
end
