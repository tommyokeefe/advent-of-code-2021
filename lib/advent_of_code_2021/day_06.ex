defmodule AdventOfCode.Day06 do
  def part1(args) do
    lantern_fish = parse(args)
    run_simulation(lantern_fish, 80)
  end

  def part2(args) do
    lantern_fish = parse(args)
    run_simulation(lantern_fish, 256)
  end

  def parse(data) do
    String.trim(data)
    |> String.split(",", trim: true)
    |> Enum.map(fn item -> String.to_integer(item) end)
    |> Enum.reduce(
      %{8 => 0, 7 => 0, 6 => 0, 5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0, 0 => 0},
      fn fish, fish_collection ->
        {_, fish_collection} =
          Map.get_and_update(fish_collection, fish, fn current_value ->
            {current_value, current_value + 1}
          end)

        fish_collection
      end
    )
  end

  def simulate_day(fish) do
    update_count(fish, %{})
  end

  def update_count(fish, fish_for_tomorrow) do
    update_count(fish, fish_for_tomorrow, 8)
  end

  def update_count(fish, fish_for_tomorrow, 0) do
    count = Map.get(fish, 0)
    fish_for_tomorrow = Map.put(fish_for_tomorrow, 8, count)

    {_, fish_for_tomorrow} =
      Map.get_and_update(fish_for_tomorrow, 6, fn current_value ->
        {current_value, current_value + count}
      end)

    fish_for_tomorrow
  end

  def update_count(fish, fish_for_tomorrow, type) do
    count = Map.get(fish, type)
    fish_for_tomorrow = Map.put(fish_for_tomorrow, type - 1, count)
    update_count(fish, fish_for_tomorrow, type - 1)
  end

  def run_simulation(fish, 0) do
    get_count(fish)
  end

  def run_simulation(fish, days) do
    days = days - 1
    fish = simulate_day(fish)
    run_simulation(fish, days)
  end

  def get_count(fish) do
    type = 8
    count = 0
    get_count(fish, type, count)
  end

  def get_count(fish, 0, count) do
    count + Map.get(fish, 0)
  end

  def get_count(fish, type, count) do
    count = count + Map.get(fish, type)

    get_count(fish, type - 1, count)
  end
end
