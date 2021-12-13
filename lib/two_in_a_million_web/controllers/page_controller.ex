defmodule TwoInAMillionWeb.PageController do
  use TwoInAMillionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
