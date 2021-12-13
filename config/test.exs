import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :two_in_a_million, TwoInAMillion.Repo,
  database: "two_in_a_million_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :two_in_a_million, TwoInAMillionWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Rc/Pkumf82oFJkUoyM3/eaSZPzGQ+eIhiJq6xI/V3WUH5P9q/tPjvxd2WaDC8T92",
  server: false

# In test we don't send emails.
config :two_in_a_million, TwoInAMillion.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
