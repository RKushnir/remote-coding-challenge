defmodule TwoInAMillion.UsersTest do
  use TwoInAMillion.DataCase, async: true

  alias TwoInAMillion.Repo
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

  describe "randomize_all_points/1" do
    # This test, in theory, might fail (flaky).
    # Due to the randomness of generated numbers we cannot expect an exact distribution of values.
    # Even when setting a seed, implementations of random() may differ between DB servers.
    # In practice, we expect a reasonable generator to not produce the same value
    # in the majority of cases.
    test "updates each user's points with a random value within the valid range" do
      users = [
        create_user(points: 0),
        create_user(points: 0),
        create_user(points: 0),
        create_user(points: 0),
        create_user(points: 0),
        create_user(points: 0),
        create_user(points: 0)
      ]

      points_range = 10..90
      Users.reset_seed(0.5)

      Users.randomize_all_points(points_range)

      updated_points_list = Enum.map(users, &reload_record(&1).points)

      max_duplicates =
        updated_points_list
        |> Enum.group_by(& &1)
        |> Enum.map(&length(elem(&1, 1)))
        |> Enum.max()

      # Verify that no single value is assigned to the majority of users.
      assert max_duplicates < length(users) / 2

      assert Enum.all?(updated_points_list, &(&1 in points_range))
    end
  end

  describe "create_default/1" do
    test "creates _count_ users with 0 points" do
      assert Repo.aggregate(Users.User, :count) == 0

      Users.create_default(count: 2)

      assert Repo.aggregate(Users.User, :count) == 2

      users = Repo.all(Users.User)
      assert Enum.all?(users, &(&1.points == 0))
    end
  end
end
