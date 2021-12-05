defmodule AdventOfCode2020.Day04 do
  def part1(args) do
    String.split(args, "\n\n")
    |> Enum.map(fn line -> String.replace(line, "\n", " ") end)
    |> Enum.map(&passport_builder/1)
    |> Enum.reduce(0, &calculate_valid_passports/2)
  end

  def part2(args) do
    String.split(args, "\n\n")
    |> Enum.map(fn line -> String.replace(line, "\n", " ") end)
    |> Enum.map(&passport_builder/1)
    |> Enum.reduce(0, &calculate_valid_passport_values/2)
  end

  def passport_builder(line) do
    list_of_fields = String.split(line, " ", trim: true)

    Enum.reduce(list_of_fields, %{}, fn field, passport ->
      field = String.split(field, ":")
      passport = Map.put(passport, Enum.at(field, 0), Enum.at(field, 1))
      passport
    end)
  end

  def calculate_valid_passports(passport, valid_count) do
    result = is_passport_valid(passport)

    case result do
      true -> valid_count + 1
      false -> valid_count
    end
  end

  def calculate_valid_passport_values(passport, valid_count) do
    result = is_passport_valid(passport, :check_values)

    case result do
      true -> valid_count + 1
      false -> valid_count
    end
  end

  def is_passport_valid(passport) do
    has_birth_year = Map.has_key?(passport, "byr")
    has_issue_year = Map.has_key?(passport, "iyr")
    has_expiration_year = Map.has_key?(passport, "eyr")
    has_height = Map.has_key?(passport, "hgt")
    has_hair_color = Map.has_key?(passport, "hcl")
    has_eye_color = Map.has_key?(passport, "ecl")
    has_passport_id = Map.has_key?(passport, "pid")
    _has_country_id = Map.has_key?(passport, "cid")

    cond do
      has_issue_year and
        has_expiration_year and
        has_height and
        has_hair_color and
        has_eye_color and
        has_birth_year and
          has_passport_id ->
        true

      true ->
        false
    end
  end

  def is_passport_valid(passport, :check_values) do
    cond do
      has_birth_year_value(passport) and
        has_issue_year_value(passport) and
        has_expiration_year_value(passport) and
        has_height_value(passport) and
        has_hair_color_value(passport) and
        has_eye_color_value(passport) and
          has_pid_value(passport) ->
        true

      true ->
        false
    end
  end

  def has_birth_year_value(passport) do
    birth_year = Map.get(passport, "byr", "")

    cond do
      String.length(birth_year) == 4 &&
        String.to_integer(birth_year) >= 1920 &&
          String.to_integer(birth_year) <= 2002 ->
        true

      true ->
        false
    end
  end

  def has_issue_year_value(passport) do
    issue_year = Map.get(passport, "iyr", "")

    cond do
      String.length(issue_year) == 4 &&
        String.to_integer(issue_year) >= 2010 &&
          String.to_integer(issue_year) <= 2020 ->
        true

      true ->
        false
    end
  end

  def has_expiration_year_value(passport) do
    expiration_year = Map.get(passport, "eyr", "")

    cond do
      String.length(expiration_year) == 4 &&
        String.to_integer(expiration_year) >= 2020 &&
          String.to_integer(expiration_year) <= 2030 ->
        true

      true ->
        false
    end
  end

  def has_height_value(passport) do
    height = Map.get(passport, "hgt", "")

    cond do
      String.match?(height, ~r/cm/) ->
        [height | _] = String.split(height, "cm")
        height = String.to_integer(height)
        height >= 150 and height <= 193

      String.match?(height, ~r/in/) ->
        [height | _] = String.split(height, "in")
        height = String.to_integer(height)
        height >= 59 and height <= 76

      true ->
        false
    end
  end

  def has_hair_color_value(passport) do
    hair_color = Map.get(passport, "hcl", "")

    String.match?(hair_color, ~r/^#[0-9a-f]{6}$/)
  end

  def has_eye_color_value(passport) do
    allowed_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    eye_color = Map.get(passport, "ecl", "")

    Enum.member?(allowed_colors, eye_color)
  end

  def has_pid_value(passport) do
    pid = Map.get(passport, "pid", "")

    String.match?(pid, ~r/^[0-9]{9}$/)
  end
end
