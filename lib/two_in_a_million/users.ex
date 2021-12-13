defmodule TwoInAMillion.Users do
  @moduledoc """
  Create, modify and search users.
  """

  alias TwoInAMillion.Repo
  alias TwoInAMillion.Users.User
  import Ecto.Query, only: [from: 2]

  @doc """
  Find at most a _count_ number of users that have more points than _min_points_.
  """
  def find_all_with_points_above(min_points, count: count) do
    from([u] in User, where: u.points > ^min_points, limit: ^count)
    |> Repo.all()
  end
end
