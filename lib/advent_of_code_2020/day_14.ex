defmodule AdventOfCode2020.Day14 do
  def part1(args) do
    bit_map = get_36_bit_map()

    parse(args)
    |> process_instructions(bit_map)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args) do
    bit_map = get_36_bit_map()

    parse(args)
    |> process_instructions(bit_map, :two)
    |> Map.values()
    |> Enum.sum()
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn line ->
      [instruction | [detail]] = String.split(line, " = ", trim: true)
      {instruction, detail}
    end)
  end

  def process_instructions(instructions, bit_map, version \\ :one, bitmask \\ "", memory \\ %{})

  def process_instructions([{location, value} | instructions], bit_map, :one, bitmask, memory) do
    case location do
      "mask" ->
        process_instructions(instructions, bit_map, :one, value, memory)

      _ ->
        value =
          to_36_bit_int(value, bit_map)
          |> apply_bitmask(bitmask)
          |> to_decimal(bit_map)

        memory = Map.put(memory, location, value)
        process_instructions(instructions, bit_map, :one, bitmask, memory)
    end
  end

  def process_instructions([{location, value} | instructions], bit_map, :two, bitmask, memory) do
    case location do
      "mask" ->
        process_instructions(instructions, bit_map, :two, value, memory)

      _ ->
        %{"location" => location} = Regex.named_captures(~r/mem\[(?<location>[0-9]+)\]/, location)

        memory =
          to_36_bit_int(location, bit_map)
          |> apply_bitmask(bitmask, :two)
          |> Enum.map(&to_decimal(&1, bit_map))
          |> Enum.reduce(memory, fn location, memory ->
            Map.put(memory, location, String.to_integer(value))
          end)

        process_instructions(instructions, bit_map, :two, bitmask, memory)
    end
  end

  def process_instructions([], _, _, _, memory), do: memory

  def get_36_bit_map() do
    {_, bit_map} =
      Enum.to_list(1..36)
      |> Enum.reduce({1, %{}}, fn item, {previous_value, bit_map} ->
        value = previous_value * 2
        {value, Map.put(bit_map, item, previous_value)}
      end)

    bit_map
  end

  def to_36_bit_int(value, bit_map) do
    highest_bit = find_highest_bit(String.to_integer(value), Enum.sort(Enum.to_list(bit_map)))

    cond do
      highest_bit == 0 -> "0"
      true -> calculate_number(String.to_integer(value), bit_map, highest_bit)
    end
  end

  def find_highest_bit(value, [{bit_location, bit_value} | bits]) do
    result = div(value, bit_value)

    cond do
      result == 0 -> 0
      result > 1 -> find_highest_bit(value, bits)
      result == 1 -> bit_location
    end
  end

  def calculate_number(value, bit_map, highest_bit) do
    {_, binary_string} =
      Enum.to_list(highest_bit..1)
      |> Enum.reduce({value, ""}, fn bit, {remainder, bit_string} ->
        bit_value = Map.get(bit_map, bit)
        binary_bit = div(remainder, bit_value)
        remainder = rem(remainder, bit_value)
        {remainder, bit_string <> Integer.to_string(binary_bit)}
      end)

    binary_string
  end

  def apply_bitmask(bit_string, bitmask, version \\ :one)

  def apply_bitmask(bit_string, bitmask, :one) do
    empty_bit_string = List.duplicate("0", 36)
    bit_string = String.graphemes(bit_string)
    bitmask = String.graphemes(bitmask)
    bit_string = Enum.concat(Enum.take(empty_bit_string, 36 - Enum.count(bit_string)), bit_string)

    Enum.zip(bit_string, bitmask)
    |> Enum.map(fn {bit, mask} ->
      case mask do
        "X" -> bit
        _ -> mask
      end
    end)
    |> Enum.join()
  end

  def apply_bitmask(bit_string, bitmask, :two) do
    empty_bit_string = List.duplicate("0", 36)
    bit_string = String.graphemes(bit_string)
    bitmask = String.graphemes(bitmask)
    bit_string = Enum.concat(Enum.take(empty_bit_string, 36 - Enum.count(bit_string)), bit_string)

    Enum.zip(bit_string, bitmask)
    |> Enum.reduce([""], fn {bit, mask}, results ->
      case mask do
        "0" ->
          Enum.map(results, fn result -> result <> bit end)

        "1" ->
          Enum.map(results, fn result -> result <> "1" end)

        "X" ->
          Enum.reduce(results, [], fn result, new_results ->
            [result <> "1", result <> "0" | new_results]
          end)
      end
    end)
  end

  def to_decimal(bit_string, bit_map) do
    bit_string = String.graphemes(bit_string)
    length = Enum.count(bit_string)

    Enum.to_list(length..1)
    |> Enum.zip(bit_string)
    |> Enum.reduce(0, fn {bit_location, bit_value}, total ->
      case bit_value do
        "0" -> total
        "1" -> Map.get(bit_map, bit_location) + total
      end
    end)
  end
end
