defmodule AdventOfCode.Day16 do
  def part1(args) do
    data = parse(args)
    {main_packet, _} = decode_packet(data)
    sum_versions(main_packet, 0)
  end

  def part2(args) do
    data = parse(args)
    {packet, _} = decode_packet(data)
    eval_packet(packet)
  end

  def sum_versions({version, :literal, _}, sum) do
    sum + version
  end

  def sum_versions({version, _, packets}, sum) do
    Enum.reduce(packets, sum + version, &sum_versions/2)
  end

  def eval_packet({_, :literal, value}), do: value

  def eval_packet({_, id, packets}) do
    values = Enum.map(packets, &eval_packet/1)
    case id do
      0 ->
        Enum.sum(values)
      1 ->
        Enum.product(values)
      2 ->
        Enum.min(values)
      3 ->
        Enum.max(values)
      5 ->
        [first, second] = values
        if first > second, do: 1, else: 0
      6 ->
        [first, second] = values
        if first < second, do: 1, else: 0
      7 ->
        [first, second] = values
        if first == second, do: 1, else: 0
    end
  end

  def decode_packet(bitstring) do
    case bitstring do
      <<version::size(3), id::size(3), rest::bitstring>> ->
        case id do
          4 ->
            {literal, rest} = decode_literal_package(rest)
            {{version, :literal, literal}, rest}
          _ ->
            {packets, rest} = decode_operator_packet(rest)
            {{version, id, packets}, rest}
        end
      _ ->
        {:none, bitstring}
    end
  end

  def decode_literal_package(bitstring, acc \\ 0) do
    case bitstring do
      <<more::size(1), n::size(4), rest::bitstring>> ->
        acc = acc * 16 + n
        case more do
          0 -> {acc, rest}
          1 -> decode_literal_package(rest, acc)
        end
    end
  end

  def decode_operator_packet(bitstring) do
    case bitstring do
      <<0::size(1), total_size::size(15), rest::bitstring>> ->
        <<packets::bitstring-size(total_size), rest::bitstring>> = rest
        {packets, _} = decode_packets(packets, [])
        {packets, rest}
      <<1::size(1), num_packets::size(11), rest::bitstring>> ->
        decode_n_packets(rest, num_packets, [])
    end
  end

  def decode_packets(bitstring, acc) do
    case decode_packet(bitstring) do
      {:none, rest} ->
        {Enum.reverse(acc), rest}
      {packet, rest} ->
        decode_packets(rest, [packet | acc])
    end
  end

  def decode_n_packets(bitstring, 0, acc) do
    {Enum.reverse(acc), bitstring}
  end
  def decode_n_packets(bitstring, num_packets, acc) do
    {packet, rest} = decode_packet(bitstring)
    decode_n_packets(rest, num_packets - 1, [packet | acc])
  end

  def parse(input) do
    input = String.trim(input)
    int = String.to_integer(input, 16)
    bytes = byte_size(input)
    <<int::integer-size(bytes)-unit(4)>>
  end
end
