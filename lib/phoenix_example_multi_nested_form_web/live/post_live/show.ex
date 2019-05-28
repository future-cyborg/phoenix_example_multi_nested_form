defmodule PhoenixExampleMultiNestedFormWeb.PostLive.Show do
  use Phoenix.LiveView
  alias Phoenix.LiveView.Socket

  alias PhoenixExampleMultiNestedFormWeb.PostLive
  alias PhoenixExampleMultiNestedFormWeb.Router.Helpers, as: Routes
  alias PhoenixExampleMultiNestedForm.Example
  alias PhoenixExampleMultiNestedForm.Example.Post
  alias PhoenixExampleMultiNestedForm.Example.Comment
  alias PhoenixExampleMultiNestedFormWeb.PostView

  def render(assigns), do: PostView.render("show.html", assigns)

  def mount(%{path_params: %{"id" => id}}, socket) do
    post = Example.get_post!(id)
    {:ok, assign(socket, post: post)}
  end

end