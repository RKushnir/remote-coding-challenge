defmodule TwoInAMillion.RandomNumberGenerator do
  defmodule Behaviour do
    @callback get_next_number(Range.t()) :: integer()
  end

  @behaviour Behaviour

  @impl true
  def get_next_number(range) do
    Enum.random(range)
  end
end
