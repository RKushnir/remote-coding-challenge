defmodule TwoInAMillionWeb.UserController do
  use TwoInAMillionWeb, :controller

  alias TwoInAMillion.LotteryServer

  def index(conn, _params) do
    json(conn, LotteryServer.pick_winners(2))
  end
end
