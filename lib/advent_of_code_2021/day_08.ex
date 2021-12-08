defmodule AdventOfCode.Day08 do
  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&right_of_pipe/1)
    |> Enum.map(&split_on_whitespace/1)
    |> count_uniques()
  end

  def part2(args) do
    input =
      Enum.zip(
        String.split(args, "\n", trim: true)
        |> Enum.map(&left_of_pipe/1)
        |> Enum.map(&split_on_whitespace/1),
        String.split(args, "\n", trim: true)
        |> Enum.map(&right_of_pipe/1)
        |> Enum.map(&split_on_whitespace/1)
      )

    get_total(input, 0)
  end

  def right_of_pipe(line) do
    [_ | [line]] = String.split(line, " | ", trim: true)
    line
  end

  def left_of_pipe(line) do
    [line | _] = String.split(line, " | ", trim: true)
    line
  end

  def split_on_whitespace(line) do
    String.split(line, " ", trim: true)
  end

  def count_uniques(list) do
    List.flatten(list)
    |> Enum.reduce(0, fn item, count ->
      length = String.length(item)

      case length do
        2 -> count + 1
        3 -> count + 1
        4 -> count + 1
        7 -> count + 1
        _ -> count
      end
    end)
  end

  def get_total(input, total) do
    Enum.reduce(input, total, fn {digits, output}, total ->
      numbers = get_numbers(digits)

      output_number =
        Enum.reduce(output, "", fn item, total ->
          item = List.to_string(Enum.sort(String.graphemes(item)))
          number = Map.get(numbers, item)
          total <> number
        end)

      String.to_integer(output_number) + total
    end)
  end

  def get_numbers(digits) do
    one = get_one(digits)
    four = get_four(digits)
    seven = get_seven(digits)
    eight = get_eight(digits)
    three = get_three(digits, one)
    top = get_top(seven, one)
    middle = get_middle(four, three, one)
    bottom = get_bottom(top, middle, one, three)
    top_left = get_top_left(four, one, middle)
    bottom_left = get_bottom_left(three, four, eight)
    bottom_right = get_bottom_right(top, middle, bottom, top_left, bottom_left, digits)
    top_right = get_top_right(bottom_right, one)

    zero_code =
      List.to_string(Enum.sort([top, top_left, top_right, bottom_left, bottom_right, bottom]))

    one_code = List.to_string(Enum.sort(one))
    two_code = List.to_string(Enum.sort([top, top_right, middle, bottom_left, bottom]))
    three_code = List.to_string(Enum.sort(three))
    four_code = List.to_string(Enum.sort(four))
    five_code = List.to_string(Enum.sort([top, top_left, middle, bottom_right, bottom]))

    six_code =
      List.to_string(Enum.sort([top, top_left, middle, bottom_left, bottom_right, bottom]))

    seven_code = List.to_string(Enum.sort(seven))
    eight_code = List.to_string(Enum.sort(eight))

    nine_code =
      List.to_string(Enum.sort([top, top_left, top_right, middle, bottom_right, bottom]))

    %{
      zero_code => "0",
      one_code => "1",
      two_code => "2",
      three_code => "3",
      four_code => "4",
      five_code => "5",
      six_code => "6",
      seven_code => "7",
      eight_code => "8",
      nine_code => "9"
    }
  end

  def get_one(digits) do
    Enum.find(digits, fn item -> String.length(item) == 2 end)
    |> String.split("", trim: true)
  end

  def get_four(digits) do
    Enum.find(digits, fn item -> String.length(item) == 4 end)
    |> String.split("", trim: true)
  end

  def get_seven(digits) do
    Enum.find(digits, fn item -> String.length(item) == 3 end)
    |> String.split("", trim: true)
  end

  def get_eight(digits) do
    Enum.find(digits, fn item -> String.length(item) == 7 end)
    |> String.split("", trim: true)
  end

  def get_three(digits, one) do
    one = List.to_tuple(one)

    Enum.find(digits, fn item ->
      String.length(item) == 5 and
        String.contains?(item, elem(one, 0)) and
        String.contains?(item, elem(one, 1))
    end)
    |> String.split("", trim: true)
  end

  def get_top(seven, one) do
    set = MapSet.new(one)
    Enum.find(seven, fn item -> !MapSet.member?(set, item) end)
  end

  def get_middle(four, three, one) do
    possible_middles = MapSet.to_list(MapSet.intersection(MapSet.new(four), MapSet.new(three)))
    ones = MapSet.new(one)
    Enum.find(possible_middles, fn item -> !MapSet.member?(ones, item) end)
  end

  def get_bottom(top, middle, one, three) do
    set = MapSet.new(List.flatten([one, top, middle]))
    Enum.find(three, fn item -> !MapSet.member?(set, item) end)
  end

  def get_top_left(four, one, middle) do
    set = MapSet.new(List.flatten([middle, one]))
    Enum.find(four, fn item -> !MapSet.member?(set, item) end)
  end

  def get_bottom_left(three, four, eight) do
    set = MapSet.new(List.flatten([three, four]))
    Enum.find(eight, fn item -> !MapSet.member?(set, item) end)
  end

  def get_bottom_right(top, middle, bottom, top_left, bottom_left, digits) do
    six =
      Enum.find(digits, fn item ->
        String.length(item) == 6 and
          String.contains?(item, top) and
          String.contains?(item, middle) and
          String.contains?(item, bottom) and
          String.contains?(item, top_left) and
          String.contains?(item, bottom_left)
      end)
      |> String.split("", trim: true)

    set = MapSet.new([top, middle, bottom, top_left, bottom_left])
    Enum.find(six, fn item -> !MapSet.member?(set, item) end)
  end

  def get_top_right(bottom_right, one) do
    Enum.find(one, fn item -> item != bottom_right end)
  end
end
