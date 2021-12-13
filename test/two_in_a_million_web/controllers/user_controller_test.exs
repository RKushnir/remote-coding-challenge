defmodule TwoInAMillionWeb.UserControllerTest do
  use TwoInAMillionWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert %{
             "timestamp" => _timestamp,
             "users" => _users
           } = json_response(conn, 200)
  end
end
