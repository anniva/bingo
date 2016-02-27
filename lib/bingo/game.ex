defmodule Bingo.Game do
  defstruct name: "", played_numbers: []

  @available_numbers 1..75

  def new(name) do
    %Bingo.Game{ name: name }
  end

  def draw(%Bingo.Game{ played_numbers: numbers} = game) when length(numbers) == 75 do
    {nil, game}
  end

  def draw(%Bingo.Game{ played_numbers: numbers} = game) do
    new_number = Enum.random(@available_numbers)

    case Enum.find(numbers, fn(x) -> x == new_number end) do
      nil -> draw(game, new_number)
      _   -> draw(game)
    end
  end

  def draw(%Bingo.Game{ played_numbers: numbers} = game, new_number) when new_number in 1..75 do
    {new_number, %Bingo.Game{ game | played_numbers: [new_number | numbers]}}
  end
end
