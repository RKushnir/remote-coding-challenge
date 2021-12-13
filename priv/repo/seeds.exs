# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TwoInAMillion.Repo.insert!(%TwoInAMillion.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

TwoInAMillion.Repo.delete_all(TwoInAMillion.Users.User)
TwoInAMillion.Users.create_default(count: 1_000_000)
