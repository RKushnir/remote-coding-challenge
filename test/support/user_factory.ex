defmodule TwoInAMillion.UserFactory do
  @moduledoc false

  @doc """
  Allows to conveniently create a user with the given number of points.
  """
  def create_user(points: points) do
    TwoInAMillion.Repo.insert!(%TwoInAMillion.Users.User{points: points})
  end

  @doc """
  Allows to create multiple users with the same given number of points.
  """
  def create_users(count, points: points) do
    Enum.each(1..count, fn _ -> create_user(points: points) end)
  end
end
