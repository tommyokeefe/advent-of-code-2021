defmodule AdventOfCode.Day13 do
  def part1(args) do
    {dots, folds} = parse(args)
    dot_map = generate_map(dots)
    [{axis, location} | _] = folds

    do_fold(axis, location, dot_map)
    |> Map.values()
    |> Enum.filter(fn item -> item == "1" end)
    |> Enum.count()
  end

  def part2(args) do
    {dots, folds} = parse(args)
    dot_map = generate_map(dots)

    do_folds(folds, dot_map)
    |> print_grid()
  end

  def parse(data) do
    dots_regex = ~r/(?<x>[0-9]+),(?<y>[0-9]+)/
    folds_regex = ~r/^fold along (?<axis>[a-z]+)=(?<location>[0-9]+)/

    String.split(data, "\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {dots, folds} ->
      cond do
        String.match?(line, dots_regex) ->
          %{"x" => x, "y" => y} = Regex.named_captures(dots_regex, line)
          {[{String.to_integer(x), String.to_integer(y)} | dots], folds}

        String.match?(line, folds_regex) ->
          %{"axis" => axis, "location" => location} = Regex.named_captures(folds_regex, line)
          {dots, [{axis, String.to_integer(location)} | folds]}

        true ->
          {dots, folds}
      end
    end)
    |> then(fn {dots, folds} -> {Enum.reverse(dots), Enum.reverse(folds)} end)
  end

  def generate_map(dots) do
    {max_x, max_y} =
      Enum.reduce(dots, fn {x, y}, {max_x, max_y} ->
        {Enum.max([x, max_x]), Enum.max([y, max_y])}
      end)

    x_axis = Enum.to_list(0..max_x)
    y_axis = Enum.to_list(0..max_y)

    dot_map =
      Enum.reduce(y_axis, %{}, fn y, map ->
        Enum.reduce(x_axis, map, fn x, map ->
          Map.put(map, {x, y}, "0")
        end)
      end)

    Enum.reduce(dots, dot_map, fn dot, map -> Map.put(map, dot, "1") end)
  end

  def do_folds([{axis, location} | folds], dot_map) do
    folds_left = Enum.count(folds) + 1
    dot_map = do_fold(axis, location, dot_map)

    do_folds(folds, dot_map)
  end

  def do_folds([], dot_map), do: dot_map

  def do_fold("x", location, dot_map) do
    x_sort = fn {{x1, _}, _}, {{x2, _}, _} -> x1 <= x2 end

    sorted_x =
      Enum.map(dot_map, fn item -> item end)
      |> Enum.sort(x_sort)

    right_half =
      Enum.filter(sorted_x, fn {{x, _}, _} -> x > location end)
      |> Enum.chunk_by(fn {{x, _}, _} -> x end)
      |> Enum.with_index()
      |> Enum.map(fn {list, index} ->
        Enum.map(list, fn {{_, y}, z} -> {{index, y}, z} end)
      end)
      |> List.flatten()
      |> Map.new()

    Enum.filter(sorted_x, fn {{x, _}, z} -> x < location end)
    |> Enum.sort(x_sort)
    |> Enum.reverse()
    |> Enum.chunk_by(fn {{x, _}, _} -> x end)
    |> Enum.with_index()
    |> Enum.map(fn {list, index} ->
      Enum.map(list, fn {{_, y}, z} -> {{index, y}, z} end)
    end)
    |> List.flatten()
    |> Enum.reduce(right_half, fn {key, value}, map ->
      case value do
        "1" -> Map.put(map, key, "1")
        _ -> map
      end
    end)
  end

  def do_fold("y", location, dot_map) do
    y_sort = fn {{_, y1}, _}, {{_, y2}, _} -> y1 <= y2 end

    sorted_y =
      Enum.map(dot_map, fn item -> item end)
      |> Enum.sort(y_sort)

    top_half =
      Enum.filter(sorted_y, fn {{_, y}, _} -> y < location end)
      |> Map.new()

    Enum.filter(sorted_y, fn {{_, y}, z} -> y > location end)
    |> Enum.sort(y_sort)
    |> Enum.reverse()
    |> Enum.chunk_by(fn {{_, y}, _} -> y end)
    |> Enum.with_index()
    |> Enum.map(fn {list, index} ->
      Enum.map(list, fn {{x, _}, z} -> {{x, index}, z} end)
    end)
    |> List.flatten()
    |> Enum.reduce(top_half, fn {key, value}, map ->
      case value do
        "1" -> Map.put(map, key, "1")
        _ -> map
      end
    end)
  end

  defp print_grid(grid) do
    Enum.sort(grid, fn {{x1, y1}, _}, {{x2, y2}, _} ->
      cond do
        y1 < y2 -> true
        y1 == y2 -> x1 >= x2
        y1 > y2 -> false
      end
    end)
    |> Enum.chunk_by(fn {{_, y}, _} -> y end)
    |> Enum.map(fn line ->
      Enum.map(line, fn {_, x} ->
        case x do
          "1" -> ?\#
          "0" -> ?\.
        end
      end)
      |> :io.put_chars()

      :io.nl()
    end)
  end
end
