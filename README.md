# Phoenix Nested Form with LiveView
This is an example repo of how to work with nested forms while using Phoenix LiveView.
(It's still in progress as of writing this, but check out [Phoenix LiveView!](https://github.com/phoenixframework/phoenix_live_view) Very fun framework!)

I spent awhile trying to get nested forms to work properly with, so I put this together to share what I got working. The conditions of this problem:
* One-to-many association
* Preload associations for edit form
* Create multiple nested associations dynamically (via LiveView) in one form
* Adding more of an association dynamically does not disrupt/reset form fields
* Utilize LiveView (no additional JS!)

I wanted a form where upon creating/updating you can add a variable number of a nested association. Each button press adds an additional association field to the form.
Check out the repo for details, but here's a short description of the key parts.

 ### Schema
 I use a one-many posts to comments association for this example.
 Add cast_assoc/3 to Post.changeset/2 so the association is included in the changeset.
```elixir
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:text])
    |> cast_assoc(:comments)
    |> validate_required([:text])
  end
```
Change the default Example.change_post/1 to change_post/2 so we can add pass attributes through.
```elixir
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
```
Edit Example.get_post!/1 to preload comments
```elixir
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:comments)
  end
```
### Template
##### Use phx_change tag in form
Utilizing LiveView's phx_change tag is necessary! Else the form fields resets when a new comment is added to the post.
As of writing this, there is little LiveView documentation on phx-change. What this example is doing: anytime a form field recieves a change, the event "validate" is sent, which is caught with handle_event/3.
```elixir
<%= form_for @post_changeset, "#", [phx_change: :validate, phx_submit: :save], fn f -> %>
```
##### Nested Form
Use Phoenix.HTML.Form.inputs_for/4 to create form inputs for the nested association.
```elixir
  <%= inputs_for f, :comments, fn cf -> %>
    <h3>Comment</h3>
    <%= label cf, :text %>
    <%= text_input cf, :text %>
    <%= error_tag cf, :text %>
  <% end %>
```
##### add_comment button

```elixir
<button phx-click="add_comment">Add comment</button>
```
### LiveView
##### add_comment
Catch that "add_comment" event via PostLive.New.handle_event/3.
First add a new comment changeset to the list of current comment changesets. Use Map.get/3 to set a default empty list.
Then update the post changeset and update the socket assigns.
```elixir
  def handle_event("add_comment", _, socket) do
    comment_changeset = %Comment{} |> Example.change_comment
    comments = Map.get(socket.assigns.post_changeset.changes, :comments, []) ++ [comment_changeset]

    post_changeset = socket.assigns.post_changeset
      |> Map.put(:changes, %{comments: comments})
    {:noreply, assign(socket, post_c  def handle_event("validate", %{"post" => params}, socket) do
    post_changeset = %Post{}
      |> Example.change_post(params)

    {:noreply, assign(socket, post_changeset: post_changeset)}
  endhangeset: post_changeset)}
  end
```
##### validate
Catch the "validate" event from the phx-change mentioned above.
Here the changeset is updated with every change of the form. Now when add_comment is handled and the changeset is updated, the form fields are not overwritten as empty.
```elixir
  def handle_event("validate", %{"post" => params}, socket) do
    post_changeset = %Post{}
      |> Example.change_post(params)

    {:noreply, assign(socket, post_changeset: post_changeset)}
  end
```
PostLive.Edit is similarly written to PostLive.New.

# Test It!

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/posts`](http://localhost:4000/posts) from your browser.