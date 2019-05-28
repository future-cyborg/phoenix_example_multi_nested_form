defmodule PhoenixExampleMultiNestedFormWeb.PostLive.New do
  use Phoenix.LiveView

  alias PhoenixExampleMultiNestedFormWeb.PostLive
  alias PhoenixExampleMultiNestedFormWeb.Router.Helpers, as: Routes
  alias PhoenixExampleMultiNestedForm.Example
  alias PhoenixExampleMultiNestedForm.Example.Post
  alias PhoenixExampleMultiNestedForm.Example.Comment
  alias PhoenixExampleMultiNestedFormWeb.PostView

  def mount(_session, socket) do
    post_changeset = Example.change_post(%Post{})
    {:ok, assign(socket, post_changeset: post_changeset)}
  end

  def render(assigns), do: PostView.render("new.html", assigns)

  def handle_event("add_comment", _, socket) do
    comment_changeset = %Comment{} |> Example.change_comment
    comments = Map.get(socket.assigns.post_changeset.changes, :comments, []) ++ [comment_changeset]

    post_changeset = socket.assigns.post_changeset
      |> Map.put(:changes, %{comments: comments})
    {:noreply, assign(socket, post_changeset: post_changeset)}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    post_changeset = %Post{}
      |> Example.change_post(params)

    {:noreply, assign(socket, post_changeset: post_changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    case Example.create_post(params) do
      {:ok, _post} ->
        {:stop,
         socket
         |> put_flash(:info, "post created")
         |> redirect(to: Routes.live_path(socket, PostLive.Index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, post_changeset: changeset)}
    end
  end

end