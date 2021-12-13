defmodule TwoInAMillion.LotteryServer do
  @moduledoc """
  LotteryServer regularly randomizes the points of all users and the winning threshold.
  It responds with a list of users who satisfy the winning criteria
  and a timestamp of a previous request.
  """

  use GenServer

  @default_name __MODULE__

  defmodule State do
    defstruct [:max_number, :timestamp]
  end

  alias TwoInAMillion.Users
  alias TwoInAMillion.RandomNumberGenerator

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
    number_generator = Keyword.get(arg, :number_generator, RandomNumberGenerator)

    state = %State{
      max_number:
        Keyword.get_lazy(arg, :max_number, fn -> generate_random_number(number_generator) end),
      timestamp: Keyword.get(arg, :timestamp)
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call(
        {:pick_winners, count},
        _from,
        %State{timestamp: old_timestamp, max_number: max_number} = state
      ) do
    response = %{
      users: Users.find_all_with_points_above(max_number, count: count),
      timestamp: old_timestamp
    }

    new_state = %{state | timestamp: DateTime.utc_now()}

    {:reply, response, new_state}
  end

  defp generate_random_number(number_generator),
    do: number_generator.get_next_number(0..100)
end
