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

  def create_default(count: count) do
    Ecto.Adapters.SQL.query!(
      Repo,
      """
      INSERT INTO users(points, inserted_at, updated_at)
      SELECT 0, NOW(), NOW()
      FROM generate_series(1, $1)
      """,
      [count]
    )
  end
end
