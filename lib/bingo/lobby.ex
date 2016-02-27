defmodule Bingo.Lobby do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_game(name) do
    GenServer.call(__MODULE__, {:create_game, name})
  end

  def fetch(name) do
    GenServer.call(__MODULE__, {:fetch, name})
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def update(%Bingo.Game{} = game) do
    GenServer.call(__MODULE__, {:update, game})
  end

  def init(_) do
    table = :ets.new(:bingo_games, [:set, :protected])
    {:ok, table}
  end

  def handle_call({:create_game, name}, _sender, table) do
    game = Bingo.Game.new(name)
    :ets.insert(table, {name, game})

    {:reply, {:ok, game}, table}
  end

  def handle_call({:fetch, name}, _sender, table) do
    [{_name, game}] = :ets.lookup(table, name)

    {:reply, {:ok, game}, table}
  end

  def handle_call({:update, game}, _sender, table) do
    :ets.insert(table, {game.name, game})

    {:reply, {:ok, game}, table}
  end

  def handle_call(:all, _sender, table) do
    games = 
      :ets.match(table, :"$1")
      |> Enum.map(fn([{_name, game}]) -> game end)

    {:reply, {:ok, games}, table}
  end
end
