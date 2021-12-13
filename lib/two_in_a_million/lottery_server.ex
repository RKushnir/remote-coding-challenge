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
    opts =
      Keyword.merge(
        default_options(),
        Keyword.take(arg, [:round_duration, :number_generator, :randomize_points_fun])
      )

    state = %State{
      max_number: Keyword.get(arg, :max_number, 0),
      timestamp: Keyword.get(arg, :timestamp)
    }

    schedule_next_round(opts)

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

  @impl GenServer
  def handle_info({:start_new_round, opts}, state) do
    number_generator = Keyword.fetch!(opts, :number_generator)
    randomize_points_fun = Keyword.fetch!(opts, :randomize_points_fun)
    new_max_number = generate_random_number(number_generator)

    randomize_points_fun.(points_range())
    schedule_next_round(opts)

    new_state = %{state | max_number: new_max_number}
    {:noreply, new_state}
  end

  defp schedule_next_round(opts) do
    round_duration = Keyword.fetch!(opts, :round_duration)

    Process.send_after(
      self(),
      {:start_new_round, opts},
      round_duration
    )
  end

  defp generate_random_number(number_generator),
    do: number_generator.get_next_number(points_range())

  defp default_options do
    [
      round_duration: fetch_config!(:round_duration),
      number_generator: RandomNumberGenerator,
      randomize_points_fun: &Users.randomize_all_points/1
    ]
  end

  defp points_range, do: fetch_config!(:points_range)

  def fetch_config!(key) do
    config = Application.fetch_env!(:two_in_a_million, __MODULE__)
    Keyword.fetch!(config, key)
  end
end
