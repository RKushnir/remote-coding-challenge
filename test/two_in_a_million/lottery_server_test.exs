defmodule TwoInAMillion.LotteryServerTest do
  use ExUnit.Case, async: true

  alias TwoInAMillion.{LotteryServer, User}

  test "pick_winners/2 returns 2 users and a timestamp" do
    server_spec = %{
      id: RiggedLottery,
      start: {LotteryServer, :start_link, [[], [name: RiggedLottery]]}
    }

    start_supervised(server_spec)

    assert %{
             users: [%User{}, %User{}],
             timestamp: _timestamp
           } = LotteryServer.pick_winners(2, RiggedLottery)
  end
end
