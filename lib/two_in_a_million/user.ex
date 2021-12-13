defmodule TwoInAMillion.User do
  @derive {Jason.Encoder, only: [:id, :points]}

  defstruct [:id, :points, :inserted_at, :updated_at]
end
