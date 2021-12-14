defmodule AdventOfCode.Day14 do
  def part1(args) do
    {state, rules} = parse(args)
    {_, letters} = develop_polymers(state, rules, 10)
    get_total(letters)
  end

  def part2(args) do
    {state, rules} = parse(args)
    {_, letters} = develop_polymers(state, rules, 40)
    get_total(letters)
  end

  def parse(data) do
    [polymers | [rules]] = String.split(data, "\n\n", trim: true)

    polymers =
      String.codepoints(polymers)
      |> Enum.map(&String.to_atom/1)

    pairs =
      Enum.zip(polymers, tl(polymers))
      |> Enum.frequencies()

    letters = Enum.frequencies(polymers)

    state = {pairs, letters}

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, " -> ")
      end)
      |> Enum.map(fn transformation ->
        [[a, b], [c]] =
          Enum.map(transformation, fn string ->
            string
            |> String.codepoints()
            |> Enum.map(&String.to_atom/1)
          end)

        {{a, b}, c}
      end)

    {state, rules}
  end

  def develop_polymers(state, rules, count) do
    iterations = Enum.to_list(1..count)

    Enum.reduce(iterations, state, fn _, state ->
      apply_rules(state, rules)
    end)
  end

  defp apply_rules({oldpairs, letters}, rules) do
    Enum.reduce(rules, {oldpairs, letters}, fn {{a, b}, c}, {pairs, letters} ->
      count = Map.get(oldpairs, {a, b}, 0)

      pairs =
        pairs
        |> Map.update({a, b}, -count, &(&1 - count))
        |> Map.update({a, c}, count, &(&1 + count))
        |> Map.update({c, b}, count, &(&1 + count))

      letters = Map.update(letters, c, count, &(&1 + count))

      {pairs, letters}
    end)
  end

  def get_total(polymers) do
    polymers
    |> Map.values()
    |> then(fn values -> Enum.max(values) - Enum.min(values) end)
  end
end
