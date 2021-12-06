defmodule AdventOfCode2020.Day07 do
  def part1(args) do
    bags = build_child_parent(args)
    colors = get_matches(bags, "shiny gold")
    Enum.count(colors)
  end

  def part2(args) do
    bags = build_parent_child(args)
    get_bag_count(bags, "shiny gold")
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " contain ", trim: true) end)
  end

  def build_parent_child(data) do
    parse(data)
    |> Enum.reduce(%{}, fn line, bags ->
      color = get_color(Enum.at(line, 0))
      Map.put(bags, color, get_children(Enum.at(line, 1), :include_count))
    end)
  end

  def build_child_parent(data) do
    parse(data)
    |> Enum.reduce(%{}, fn line, bags ->
      parent = get_color(Enum.at(line, 0))
      children = get_children(Enum.at(line, 1))

      Enum.reduce(children, bags, fn child, new_bags ->
        {_, new_bags} =
          Map.get_and_update(new_bags, child, fn current_value ->
            cond do
              current_value == nil -> {current_value, [parent]}
              true -> {current_value, [parent | current_value]}
            end
          end)

        new_bags
      end)
    end)
  end

  def get_matches(bags, color) do
    matches = Map.get(bags, color)
    get_matches(bags, color, [color], matches)
  end

  def get_matches(bags, color, checked, matches) do
    to_check =
      Enum.filter(matches, fn match ->
        match != color and
          Enum.any?(checked, fn checked_color -> checked_color == match end) == false
      end)

    cond do
      Enum.count(to_check) == 0 ->
        matches

      true ->
        new_matches =
          Enum.reduce(to_check, matches, fn color, new_matches ->
            matches = Map.get(bags, color)

            cond do
              matches == nil -> new_matches
              true -> Enum.concat(matches, new_matches) |> Enum.uniq()
            end
          end)

        checked = Enum.concat(checked, to_check)
        get_matches(bags, color, checked, new_matches)
    end
  end

  def get_bag_count(bags, color) do
    matches = Map.get(bags, color)

    cond do
      Enum.count(matches) == 0 ->
        1

      true ->
        totals =
          Enum.map(matches, fn match ->
            bag_count = elem(match, 1)
            child_bag_count = get_bag_count(bags, elem(match, 0))
            get_total(bag_count, child_bag_count)
          end)

        Enum.sum(totals)
    end
  end

  def get_total(bag_count, 1) do
    bag_count
  end

  def get_total(bag_count, child_count) do
    bag_count + bag_count * child_count
  end

  def get_color(bag) do
    %{"name" => name} = Regex.named_captures(~r/^([1-9]+ )?(?<name>.*) bag(.)?(s(.)?)?$/, bag)
    name
  end

  def get_color_and_count(bag) do
    Regex.named_captures(~r/^(?<count>[1-9]+)?\s?(?<name>.*)\sbag(.)?(s(.)?)?$/, bag)
  end

  def get_children(line) do
    bags = String.split(line, ", ")

    Enum.filter(bags, fn bag -> String.match?(bag, ~r/no other/) == false end)
    |> Enum.map(fn bag ->
      get_color(bag)
    end)
  end

  def get_children(line, :include_count) do
    bags = String.split(line, ", ")

    Enum.filter(bags, fn bag -> String.match?(bag, ~r/no other/) == false end)
    |> Enum.map(fn bag ->
      %{"name" => name, "count" => count} = get_color_and_count(bag)
      {name, String.to_integer(count)}
    end)
  end
end
