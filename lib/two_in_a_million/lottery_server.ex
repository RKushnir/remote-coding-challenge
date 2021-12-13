defmodule TwoInAMillion.LotteryServer do
  use GenServer

  @default_name __MODULE__

  defmodule State do
    defstruct [:max_number, :timestamp]
  end

  alias TwoInAMillion.User

  def start_link(arg, opts \\ []) do
    name = Keyword.get(opts, :name, @default_name)
    GenServer.start_link(__MODULE__, arg, name: name)
  end

  def pick_winners(count, name \\ @default_name) do
    GenServer.call(name, {:pick_winners, count})
  end

  # Callbacks

  @impl GenServer
  def init(arg) do
    state = %State{
      max_number: Keyword.get(arg, :max_number, generate_random_number()),
      timestamp: Keyword.get(arg, :timestamp)
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:pick_winners, _count}, _from, %State{timestamp: old_timestamp} = state) do
    response = %{
      users: [
        %User{id: 1, points: 30},
        %User{id: 72, points: 30}
      ],
      timestamp: old_timestamp
    }

    new_state = %{state | timestamp: DateTime.utc_now()}

    {:reply, response, new_state}
  end

  defp generate_random_number, do: Enum.random(0..100)
end
