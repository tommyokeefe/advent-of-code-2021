defmodule AdventOfCode2020.Day02 do
  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn item -> String.split(item, " ", trim: true) end)
    |> Enum.reduce(0, &test_password_count/2)
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn item -> String.split(item, " ", trim: true) end)
    |> Enum.reduce(0, &test_password_locations/2)
  end

  def test_password_count([range, character, password], results) do
    [first_number, second_number] = String.split(range, "-")
    [character | _] = String.split(character, ":")
    password_list = String.graphemes(password)
    count = Enum.count(password_list, fn item -> item == character end)

    cond do
      count >= String.to_integer(first_number) and count <= String.to_integer(second_number) ->
        results + 1

      true ->
        results
    end
  end

  def test_password_locations([range, character, password], results) do
    [first_number, second_number] = String.split(range, "-")
    [character | _] = String.split(character, ":")
    password_list = String.graphemes(password)
    first_number = String.to_integer(first_number) - 1
    second_number = String.to_integer(second_number) - 1
    character_one = Enum.at(password_list, first_number)
    character_two = Enum.at(password_list, second_number)

    cond do
      (character == character_one and character != character_two) or
          (character != character_one and character == character_two) ->
        results + 1

      true ->
        results
    end
  end
end
