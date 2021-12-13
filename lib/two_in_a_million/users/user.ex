defmodule TwoInAMillion.Users.User do
  @moduledoc """
  User is a participant in a lottery, where a winner is chosen based on their points.
  """

  use Ecto.Schema

  @derive {Jason.Encoder, only: [:id, :points]}

  schema "users" do
    field :points, :integer

    timestamps()
  end
end
