defmodule TwoInAMillionWeb.UserController do
  @moduledoc """
  UserController queries the LotteryServer and returns the server's response.
  """

  use TwoInAMillionWeb, :controller

  alias TwoInAMillion.LotteryServer

  def index(conn, _params) do
    response = LotteryServer.pick_winners(2)
    render(conn, "index.json", response)
  end
end
