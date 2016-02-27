defmodule Bingo.GameTest do
  use ExUnit.Case

  test "a new game has no numbers" do
    game = Bingo.Game.new("The name")

    assert game.played_numbers == []
  end

  test "a game stores numbers it draws" do
    game = Bingo.Game.new("The name")

    {number, game} = Bingo.Game.draw(game)

    assert game.played_numbers == [number]

    {second_number, game} = Bingo.Game.draw(game)

    assert game.played_numbers == [second_number, number]
  end

  test "it can be given a specific number to draw" do
    game = Bingo.Game.new("The name")

    {13, game} = Bingo.Game.draw(game, 13)

    assert game.played_numbers == [13]
  end

  test "cannot draw numbers above the bingo range" do
    game = Bingo.Game.new("The name")

    {13, game} = Bingo.Game.draw(game, 13)

    assert_raise FunctionClauseError, "no function clause matching in Bingo.Game.draw/2", fn ->
      {76, _} = Bingo.Game.draw(game, 76)
    end

    assert_raise FunctionClauseError, "no function clause matching in Bingo.Game.draw/2", fn ->
      {0, _} = Bingo.Game.draw(game, 0)
    end

    assert_raise FunctionClauseError, "no function clause matching in Bingo.Game.draw/2", fn ->
      {9000, _} = Bingo.Game.draw(game, 9000)
    end
  end

  test "a game has a name" do
    game = Bingo.Game.new("The name")
  
    assert game.name == "The name"
  end
end
