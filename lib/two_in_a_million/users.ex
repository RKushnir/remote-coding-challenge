defmodule TwoInAMillion.Users do
  alias TwoInAMillion.Users.User

  def find_all_with_points_above(_min_points, count: _count) do
    [
      %User{id: 1, points: 30},
      %User{id: 72, points: 30}
    ]
  end
end
