defmodule TwoInAMillionWeb.Router do
  use TwoInAMillionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwoInAMillionWeb do
    pipe_through :api

    get "/", LotteryController, :index
  end
end
