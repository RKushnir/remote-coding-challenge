defmodule TwoInAMillion.LotteryServerTest do
  use TwoInAMillion.DataCase, async: true

  alias TwoInAMillion.LotteryServer
  alias TwoInAMillion.Repo

  describe "pick_winners/2" do
    def start_server(name) do
      server_spec = %{
        id: name,
        start: {LotteryServer, :start_link, [[], [name: name]]}
      }

      pid = start_supervised!(server_spec)
      Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), pid)
      pid
    end

    test "returns at most 2 users and the current timestamp" do
      pid = start_server(RiggedLottery1)

      assert %{
               users: users,
               timestamp: nil
             } = LotteryServer.pick_winners(2, pid)

      assert length(users) <= 2
    end

    test "updates the timestamp" do
      pid = start_server(RiggedLottery2)

      LotteryServer.pick_winners(2, pid)

      assert %{timestamp: %DateTime{} = timestamp1} = LotteryServer.pick_winners(2, pid)
      assert %{timestamp: %DateTime{} = timestamp2} = LotteryServer.pick_winners(2, pid)

      assert DateTime.compare(timestamp1, timestamp2) == :lt
    end
  end
end
