defmodule TwoInAMillion.Repo do
  use Ecto.Repo,
    otp_app: :two_in_a_million,
    adapter: Ecto.Adapters.Postgres
end
