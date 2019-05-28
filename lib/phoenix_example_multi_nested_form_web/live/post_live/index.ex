defmodule PhoenixExampleMultiNestedFormWeb.PostLive.Index do
  use Phoenix.LiveView

  alias PhoenixExampleMultiNestedFormWeb.PostLive
  alias PhoenixExampleMultiNestedFormWeb.Router.Helpers, as: Routes
  alias PhoenixExampleMultiNestedForm.Example
  alias PhoenixExampleMultiNestedForm.Example.Post
  alias PhoenixExampleMultiNestedForm.Example.Comment
  alias PhoenixExampleMultiNestedFormWeb.PostView

  def mount(_session, socket) do
    {:ok, assign(socket, posts: Example.list_posts())}
  end

  def render(assigns), do: PostView.render("index.html", assigns)

  def handle_event("delete_post", id, socket) do
    post = Example.get_post!(id)
    {:ok, _post} = Example.delete_post(post)

    {:noreply, assign(socket, posts: Example.list_posts())}
  end

end