defmodule TwoInAMillion.LotteryServerTest do
  use ExUnit.Case, async: true

  alias TwoInAMillion.{LotteryServer, User}

  describe "pick_winners/2" do
    def start_server(name) do
      server_spec = %{
        id: name,
        start: {LotteryServer, :start_link, [[], [name: name]]}
      }

      start_supervised!(server_spec)
    end

    test "returns 2 users and the current timestamp" do
      pid = start_server(RiggedLottery1)

      assert %{
               users: [%User{}, %User{}],
               timestamp: nil
             } = LotteryServer.pick_winners(2, pid)
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
