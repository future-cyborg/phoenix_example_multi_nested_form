defmodule PhoenixExampleMultiNestedFormWeb.PageController do
  use PhoenixExampleMultiNestedFormWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
