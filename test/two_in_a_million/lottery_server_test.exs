defmodule TwoInAMillion.LotteryServerTest do
  use TwoInAMillion.DataCase, async: true

  alias TwoInAMillion.LotteryServer
  alias TwoInAMillion.Repo

  import TwoInAMillion.UserFactory

  defp start_server(name, opts \\ []) do
    opts = Keyword.put_new(opts, :max_number, 0)
    opts = Keyword.put_new(opts, :randomize_points_fun, fn _ -> [] end)

    server_spec = %{
      id: name,
      start: {LotteryServer, :start_link, [opts, [name: name]]}
    }

    server_pid = start_supervised!(server_spec)
    Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), server_pid)
    server_pid
  end

  describe "pick_winners/2" do
    test "returns users with more points than the current threshold", %{test: unique_name} do
      user1 = create_user(points: 10)
      user2 = create_user(points: 20)
      user3 = create_user(points: 30)
      user4 = create_user(points: 40)

      server_pid = start_server(unique_name, max_number: 15)

      assert %{
               users: users,
               timestamp: nil
             } = LotteryServer.pick_winners(5, server_pid)

      assert user2 in users
      assert user3 in users
      assert user4 in users
      refute user1 in users
    end

    test "returns at most the given number of users", %{test: unique_name} do
      create_user(points: 20)
      create_user(points: 30)
      create_user(points: 40)

      server_pid = start_server(unique_name, max_number: 15)

      assert %{
               users: users
             } = LotteryServer.pick_winners(2, server_pid)

      assert length(users) <= 2
    end

    test "returns the timestamp of the previous call", %{test: unique_name} do
      server_pid = start_server(unique_name)

      assert %{timestamp: nil} = LotteryServer.pick_winners(0, server_pid)
      assert %{timestamp: %DateTime{} = timestamp1} = LotteryServer.pick_winners(0, server_pid)
      assert %{timestamp: %DateTime{} = timestamp2} = LotteryServer.pick_winners(0, server_pid)

      assert DateTime.compare(timestamp1, timestamp2) == :lt
    end
  end

  test "init/1 schedules periodic updates", %{test: unique_name} do
    test_pid = self()
    message_ref = make_ref()

    fake_randomize_fun = fn _range ->
      send(test_pid, {:randomize_called, message_ref})
    end

    start_server(unique_name, round_duration: 5, randomize_points_fun: fake_randomize_fun)

    assert_receive {:randomize_called, ^message_ref}
    assert_receive {:randomize_called, ^message_ref}
  end

  describe "handle_info/2" do
    test "updates the user points" do
      test_pid = self()
      message_ref = make_ref()

      fake_randomize_fun = fn _range ->
        send(test_pid, {:randomize_called, message_ref})
      end

      state = %LotteryServer.State{}

      opts = [
        round_duration: 1_000,
        number_generator: fn _ -> 1 end,
        randomize_points_fun: fake_randomize_fun
      ]

      LotteryServer.handle_info({:start_new_round, opts}, state)

      assert_received {:randomize_called, ^message_ref}
    end

    test "updates the winning threshold" do
      old_state = %LotteryServer.State{max_number: 0}

      opts = [
        round_duration: 1_000,
        number_generator: fn _range -> 20 end,
        randomize_points_fun: fn _ -> [] end
      ]

      {_, new_state} = LotteryServer.handle_info({:start_new_round, opts}, old_state)

      assert new_state.max_number == 20
    end
  end
end
