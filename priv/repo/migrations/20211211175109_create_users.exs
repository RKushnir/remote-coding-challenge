defmodule TwoInAMillion.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:points, :integer, null: false, default: 0)

      timestamps()
    end
  end
end
