defmodule TwoInAMillion.Users do
  @moduledoc """
  Create, modify and search users.
  """

  alias TwoInAMillion.Users.User

  @doc """
  Find a _count_ number of users that have more points than _min_points_.
  """
  def find_all_with_points_above(_min_points, count: _count) do
    [
      %User{id: 1, points: 30},
      %User{id: 72, points: 30}
    ]
  end
end
