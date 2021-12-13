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

  @doc """
  Changes points of every user to a new random value.
  """
  def randomize_all_points(range) do
    %{first: min_value, last: max_value} = range

    Repo.update_all(
      from(User,
        update: [
          set: [
            points: fragment("floor(random() * ? + ?)", ^(max_value - min_value + 1), ^min_value)
          ]
        ]
      ),
      []
    )
  end

  @doc """
  Sets a new seed for the database random generator.
  """
  def reset_seed(seed) do
    Ecto.Adapters.SQL.query!(Repo, "SELECT setseed($1)", [seed])
  end
end
