defmodule TwoInAMillion.UsersTest do
  use TwoInAMillion.DataCase, async: true

  alias TwoInAMillion.Users

  describe "find_all_with_points_above/2" do
    test "returns at most _count_ users who have more points than _min_points_" do
      _user1 = create_user(points: 10)
      user2 = create_user(points: 20)
      user3 = create_user(points: 30)
      user4 = create_user(points: 40)
      _user5 = create_user(points: 50)

      users = Users.find_all_with_points_above(20, count: 2)

      assert length(users) == 2
      assert user3 in users
      assert user4 in users

      users = Users.find_all_with_points_above(15, count: 1)

      assert length(users) == 1
      assert user2 in users
    end
  end
end
