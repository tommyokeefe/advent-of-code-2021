defmodule AdventOfCode.Day04 do
  def part1(args) do
    input = String.split(args, "\n\n")
    [numbers_drawn | bingo_cards] = input
    numbers = String.split(numbers_drawn, ",")

    bingo_cards =
      Enum.map(bingo_cards, fn card -> String.split(card, "\n", trim: true) end)
      |> Enum.map(fn card -> Enum.map(card, fn line -> String.split(line, ~r/\s+/) end) end)
      |> Enum.map(fn card ->
        Enum.map(card, fn line ->
          Enum.map(line, fn space -> %{number: space, marked: false} end)
        end)
      end)

    play_game(bingo_cards, numbers, :first, 0)
  end

  def part2(args) do
    input = String.split(args, "\n\n")
    [numbers_drawn | bingo_cards] = input
    numbers = String.split(numbers_drawn, ",")

    bingo_cards =
      Enum.map(bingo_cards, fn card -> String.split(card, "\n", trim: true) end)
      |> Enum.map(fn card ->
        Enum.map(card, fn line -> String.split(line, ~r/\s+/, trim: true) end)
      end)
      |> Enum.map(fn card ->
        Enum.map(card, fn line ->
          Enum.map(line, fn space -> %{number: space, marked: false} end)
        end)
      end)

    play_game(bingo_cards, numbers, :last, 0)
  end

  def mark_cards([bingo_card | bingo_cards], new_number) do
    marked_card = mark_card(bingo_card, new_number)
    mark_cards(bingo_cards, new_number, [marked_card])
  end

  def mark_cards([bingo_card | bingo_cards], new_number, marked_cards) do
    marked_card = mark_card(bingo_card, new_number)
    mark_cards(bingo_cards, new_number, [marked_card | marked_cards])
  end

  def mark_cards([], _new_number, marked_cards) do
    Enum.reverse(marked_cards)
  end

  def mark_card(bingo_card, new_number) do
    Enum.map(bingo_card, fn line ->
      Enum.map(line, fn space ->
        cond do
          space.number == new_number -> Map.put(space, :marked, true)
          space.number != new_number -> space
        end
      end)
    end)
  end

  def check_cards([bingo_card | bingo_cards]) do
    result = check_card(bingo_card)

    cond do
      result == false -> check_cards(bingo_cards)
      true -> result
    end
  end

  def check_cards([]) do
    false
  end

  def check_card(bingo_card) do
    result = check_card(bingo_card, bingo_card)

    cond do
      result == false ->
        vertical_card = Enum.zip(bingo_card) |> Enum.map(fn line -> Tuple.to_list(line) end)
        check_card(vertical_card, bingo_card)

      true ->
        result
    end
  end

  def check_card([line | working_card], original_card) do
    result = check_line(line)

    cond do
      result == true -> original_card
      result == false -> check_card(working_card, original_card)
    end
  end

  def check_card([], _original_card) do
    false
  end

  def check_line(line) do
    Enum.all?(line, fn space -> space.marked == true end)
  end

  def play_game(cards, [number | numbers], style, last_score) do
    card_count = Enum.count(cards)
    marked_cards = mark_cards(cards, number)

    result = check_cards(marked_cards)

    cond do
      result == false ->
        play_game(marked_cards, numbers, style, last_score)

      style == :first ->
        calculate_score(result, number)

      style == :last and card_count > 1 ->
        marked_cards = drop_card(marked_cards, result)
        score = calculate_score(result, number)
        check_cards_and_play_again(marked_cards, numbers, number, style, score)

      style == :last ->
        calculate_score(result, number)
    end
  end

  def play_game(_cards, [], _style, last_score) do
    last_score
  end

  def calculate_score(card, number) do
    semi_total = unmarked_total(card, 0)
    score = String.to_integer(number) * semi_total
    score
  end

  def unmarked_total([line | lines], running_total) do
    line_total =
      Enum.reduce(line, 0, fn space, total ->
        cond do
          space.marked == false ->
            total + String.to_integer(space.number)

          true ->
            total
        end
      end)

    unmarked_total(lines, running_total + line_total)
  end

  def unmarked_total([], total) do
    total
  end

  def drop_card(cards, card) do
    index =
      Enum.find_index(cards, fn current_card ->
        card == current_card
      end)

    List.delete_at(cards, index)
  end

  def check_cards_and_play_again(cards, numbers, number, style, score) do
    card_count = Enum.count(cards)
    result = check_cards(cards)

    cond do
      result == false ->
        play_game(cards, numbers, style, score)

      card_count > 1 ->
        marked_cards = drop_card(cards, result)
        score = calculate_score(result, number)
        check_cards_and_play_again(marked_cards, numbers, number, style, score)

      true ->
        calculate_score(result, number)
    end
  end
end
