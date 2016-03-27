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
    random_id = 
      :crypto.hash(:sha256, [1, "#{name}-#{:os.system_time}" , "!"]) 
        |> Base.encode16 
        |> String.slice(0..10)

    game = Bingo.Game.new(name, random_id)
    :ets.insert(table, {random_id, game})

    {:reply, {:ok, game}, table}
  end

  def handle_call({:fetch, random_id}, _sender, table) do
    case :ets.lookup(table, random_id) do
      [{_random_id, game}] -> {:reply, {:ok, game}, table}
    end
  end

  def handle_call({:update, game}, _sender, table) do
    :ets.insert(table, {game.id, game})

    {:reply, {:ok, game}, table}
  end

  def handle_call(:all, _sender, table) do
    games = 
      :ets.match(table, :"$1")
      |> Enum.map(fn([{_name, game}]) -> game end)

    {:reply, {:ok, games}, table}
  end
end
