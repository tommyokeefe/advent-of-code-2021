defmodule AdventOfCode.Day10 do
  def part1(args) do
    parse(args)
    |> get_syntax_error_score()
  end

  def part2(args) do
    parse(args)
    |> discard_corrupted_lines()
    |> complete_lines()
    |> Enum.sort()
    |> then(fn scores ->
      index = div(Enum.count(scores), 2)
      Enum.at(scores, index)
    end)
  end

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def discard_corrupted_lines(lines) do
    Enum.filter(lines, fn line ->
      {score, _} = check_line(line, {0, []})

      case score do
        0 -> true
        _ -> false
      end
    end)
  end

  def complete_lines(lines) do
    scores = get_scores(:completion)

    Enum.map(lines, fn line ->
      {_, matches} = check_line(line, {0, []})

      Enum.reduce(matches, 0, fn match, total ->
        score = Map.get(scores, match)
        total * 5 + score
      end)
    end)
  end

  def get_syntax_error_score(data) do
    {total, _} =
      Enum.reduce(data, {0, []}, fn line, {score, _} ->
        check_line(line, {score, []})
      end)

    total
  end

  def check_line([character | characters], total) do
    {total, status} = check_character(character, total)

    case status do
      :ok -> check_line(characters, total)
      :error -> total
    end
  end

  def check_line([], total) do
    total
  end

  def check_character(character, {score, matches}) do
    openings = ["(", "[", "{", "<"]
    closings = [")", "]", "}", ">"]
    pairs = %{"(" => ")", "[" => "]", "{" => "}", "<" => ">"}
    scores = get_scores()

    cond do
      Enum.any?(openings, &(&1 == character)) ->
        {{score, [Map.get(pairs, character) | matches]}, :ok}

      Enum.any?(closings, &(&1 == character)) ->
        [last_match | matches] = matches

        cond do
          last_match == character -> {{score, matches}, :ok}
          last_match != character -> {{score + Map.get(scores, character), []}, :error}
        end
    end
  end

  def get_scores(type \\ :error) do
    case type do
      :error -> %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
      :completion -> %{")" => 1, "]" => 2, "}" => 3, ">" => 4}
    end
  end
end
