defmodule TwoInAMillion.Repo.Migrations.IndexUsersOnPoints do
  use Ecto.Migration

  def change do
    create(index(:users, [:points]))
  end
end
