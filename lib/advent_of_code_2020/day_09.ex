defmodule AdventOfCode2020.Day09 do
  def part1(args, number) do
    parse(args)
    |> find_invalid_number(number)
  end

  def part2(args, number) do
    list = parse(args)
    invalid_number = find_invalid_number(list, number)
    find_encryption_weakness(list, invalid_number)
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn number -> String.to_integer(number) end)
  end

  def find_invalid_number(input, number) do
    Enum.chunk_every(input, number + 1, 1, :discard)
    |> is_valid()
  end

  def is_valid([first_chunk | chunks]) do
    [sum, x | integers] = Enum.reverse(first_chunk)
    result = is_valid(sum, x, integers, integers)

    cond do
      result -> is_valid(chunks)
      true -> sum
    end
  end

  def is_valid(sum, x, [y | integers], reserve) do
    cond do
      x + y == sum -> true
      true -> is_valid(sum, x, integers, reserve)
    end
  end

  def is_valid(sum, _, [], [x | integers]) do
    is_valid(sum, x, integers, integers)
  end

  def is_valid(_sum, _x, [], []) do
    false
  end

  def find_encryption_weakness(list, invalid_number) do
    [_ | new_list] = list
    find_encryption_weakness(list, invalid_number, [], new_list)
  end

  def find_encryption_weakness([x | list], invalid_number, weakness_integers, reserve) do
    weakness_integers = [x | weakness_integers]
    sum = Enum.sum(weakness_integers)

    cond do
      sum == invalid_number ->
        Enum.min(weakness_integers) + Enum.max(weakness_integers)

      sum < invalid_number ->
        find_encryption_weakness(list, invalid_number, weakness_integers, reserve)

      sum > invalid_number ->
        [_ | new_reserve] = reserve
        find_encryption_weakness(reserve, invalid_number, [], new_reserve)
    end
  end
end
