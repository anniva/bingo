defmodule Bingo.LobbyTest do
  use ExUnit.Case

  test "the lobby can create a new game" do
    {:ok, _} = Bingo.Lobby.start_link

    name = "Name of the game"
    {:ok, %Bingo.Game{} = game} = Bingo.Lobby.create_game(name)

    {:ok, %Bingo.Game{} = game} = Bingo.Lobby.fetch(game.id)

    assert game.name == name
    assert game.id != nil
  end

  test "the lobby can be used to update the state of a game" do
    {:ok, _} = Bingo.Lobby.start_link

    name = "Name of the game"
    {:ok, %Bingo.Game{} = game} = Bingo.Lobby.create_game(name)
    {new_number, game} = Bingo.Game.draw(game)

    {:ok, %Bingo.Game{}} = Bingo.Lobby.update(game)
    {:ok, game} = Bingo.Lobby.fetch(game.id)

    assert game.name == name
    assert game.played_numbers == [new_number]

    {second_new_number, game} = Bingo.Game.draw(game)

    {:ok, game} = Bingo.Lobby.update(game)
    assert game.name == name
    assert game.played_numbers == [second_new_number, new_number]
  end

  test "it gets all the currently running games" do
    {:ok, _} = Bingo.Lobby.start_link

    {:ok, %Bingo.Game{} = foo_game} = Bingo.Lobby.create_game("Foo")
    {:ok, %Bingo.Game{} = bar_game} = Bingo.Lobby.create_game("Bar")

    {:ok, games} = Bingo.Lobby.all
    assert games == [bar_game, foo_game]
  end
end
