defmodule TwoInAMillionWeb.LotteryControllerTest do
  use TwoInAMillionWeb.ConnCase

  import TwoInAMillion.UserFactory, only: [create_users: 2]

  test "GET /", %{conn: conn} do
    create_users(3, points: 101)

    conn = get(conn, "/")

    assert %{
             "timestamp" => nil,
             "users" => [
               %{"id" => _id1, "points" => _points1},
               %{"id" => _id2, "points" => _points2}
             ]
           } = json_response(conn, 200)

    conn = get(conn, "/")

    assert %{
             "timestamp" => timestamp,
             "users" => [
               %{"id" => _id1, "points" => _points1},
               %{"id" => _id2, "points" => _points2}
             ]
           } = json_response(conn, 200)

    assert String.match?(timestamp, ~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/)
  end
end
