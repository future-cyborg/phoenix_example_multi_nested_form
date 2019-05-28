defmodule PhoenixExampleMultiNestedFormWeb.PostLive.Edit do
  use Phoenix.LiveView

  alias PhoenixExampleMultiNestedFormWeb.PostLive
  alias PhoenixExampleMultiNestedFormWeb.Router.Helpers, as: Routes
  alias PhoenixExampleMultiNestedForm.Example
  alias PhoenixExampleMultiNestedForm.Example.Post
  alias PhoenixExampleMultiNestedForm.Example.Comment
  alias PhoenixExampleMultiNestedFormWeb.PostView

  def mount(%{path_params: %{"id" => id}}, socket) do
    post = Example.get_post!(id)
    post_changeset = Example.change_post(post)
    {:ok, assign(socket, post: post, post_changeset: post_changeset)}
  end

  def render(assigns), do: PostView.render("edit.html", assigns)

  def handle_event("add_comment", _, socket) do
    comment_changeset = %Comment{} |> Example.change_comment
    comments = Map.get(socket.assigns.post_changeset.changes, :comments, []) ++ [comment_changeset]

    post_changeset = socket.assigns.post_changeset
      |> Map.put(:changes, %{comments: comments})
    {:noreply, assign(socket, post_changeset: post_changeset)}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    post_changeset =
      socket.assigns.post
      |> Example.change_post(params)
      |> Map.put(:action, :update)
    {:noreply, assign(socket, post_changeset: post_changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    case Example.update_post(socket.assigns.post, params) do
      {:ok, post} ->
        {:stop,
         socket
         |> put_flash(:info, "Post updated successfully.")
         |> redirect(to: Routes.live_path(socket, PostLive.Show, post))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, post_changeset: changeset)}
    end
  end

end