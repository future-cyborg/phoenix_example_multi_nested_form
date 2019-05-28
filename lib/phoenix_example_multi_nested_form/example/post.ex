defmodule PhoenixExampleMultiNestedForm.Example.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :text, :string
    has_many :comments, PhoenixExampleMultiNestedForm.Example.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:text])
    |> cast_assoc(:comments)
    |> validate_required([:text])
  end
end
