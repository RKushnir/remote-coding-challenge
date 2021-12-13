defmodule TwoInAMillionWeb.UserControllerTest do
  use TwoInAMillionWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert %{
             "timestamp" => _timestamp,
             "users" => [
               %{"id" => _id1, "points" => _points1},
               %{"id" => _id2, "points" => _points2}
             ]
           } = json_response(conn, 200)
  end
end
