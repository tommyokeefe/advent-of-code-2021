defmodule AdventOfCode.Day16 do
  def part1(args) do
    parse(args)
    |> get_sum()
  end

  def part2(args) do
  end

  def get_sum(data, total \\ 0)

  def get_sum(data, total) do
    {version, data} = Enum.split(data, 3)
    {type, data} = Enum.split(data, 3)
    version = get_number(version)
    type = get_number(type)
    total = total + version

    case type do
      4 -> handle_literal_packet(data, total)
      _ -> handle_operator_packet(data, total)
    end
  end

  def get_number(binary_list) do
    {total, _} =
      Enum.reverse(binary_list)
      |> Enum.reduce({0, 1}, fn binary, {total, binary_value} ->
        case binary do
          "1" -> {total + binary_value, binary_value * 2}
          "0" -> {total, binary_value * 2}
        end
      end)

    total
  end

  def handle_literal_packet(data, total) do
    {[is_last | _], data} = Enum.split(data, 5)
    length = Enum.count(data)

    case is_last do
      "1" ->
        handle_literal_packet(data, total)

      "0" when length >= 11 ->
        get_sum(data, total)

      "0" ->
        total
    end
  end

  def handle_operator_packet(data, total) do
    {[length_id], data} = Enum.split(data, 1)

    case length_id do
      "0" ->
        {_, data} = Enum.split(data, 15)
        get_sum(data, total)

      "1" ->
        {_, data} = Enum.split(data, 11)
        get_sum(data, total)
    end
  end

  def parse(data) do
    hex_to_binary = %{
      "0" => "0000",
      "1" => "0001",
      "2" => "0010",
      "3" => "0011",
      "4" => "0100",
      "5" => "0101",
      "6" => "0110",
      "7" => "0111",
      "8" => "1000",
      "9" => "1001",
      "A" => "1010",
      "B" => "1011",
      "C" => "1100",
      "D" => "1101",
      "E" => "1110",
      "F" => "1111"
    }

    String.split(data, "\n", trim: true)
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.reduce("", fn hex, output -> output <> Map.get(hex_to_binary, hex) end)
    |> String.graphemes()
  end
end
