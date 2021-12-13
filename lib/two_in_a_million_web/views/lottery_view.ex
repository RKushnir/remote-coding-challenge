defmodule TwoInAMillionWeb.LotteryView do
  @moduledoc """
  UserView renders the controller's response as JSON.
  """

  use TwoInAMillionWeb, :view

  def render("index.json", %{timestamp: timestamp, users: users}) do
    %{
      timestamp: format_timestamp(timestamp),
      users: users
    }
  end

  defp format_timestamp(nil), do: nil

  defp format_timestamp(timestamp) do
    year = format_number(timestamp.year, 4)
    month = format_number(timestamp.month, 2)
    day = format_number(timestamp.day, 2)
    hour = format_number(timestamp.hour, 2)
    minute = format_number(timestamp.minute, 2)
    second = format_number(timestamp.second, 2)

    "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
  end

  defp format_number(number, width) do
    String.pad_leading("#{number}", width, "0")
  end
end
