defmodule TwoInAMillionWeb.UserController do
  @moduledoc """
  UserController queries the LotteryServer and returns the server's response.
  """

  use TwoInAMillionWeb, :controller

  alias TwoInAMillion.LotteryServer

  def index(conn, _params) do
    json(conn, LotteryServer.pick_winners(2))
  end
end
