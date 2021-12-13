defmodule TwoInAMillionWeb.UserController do
  use TwoInAMillionWeb, :controller

  def index(conn, _params) do
    json(conn, %{
      users: [
        %{id: 1, points: 30},
        %{id: 72, points: 30}
      ],
      timestamp: "2020-07-30 17:09:33"
    })
  end
end
