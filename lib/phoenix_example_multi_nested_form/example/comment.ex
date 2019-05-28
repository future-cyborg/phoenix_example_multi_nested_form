defmodule PhoenixExampleMultiNestedForm.Example.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment" do
    field :text, :string
    belongs_to :post, PhoenixExampleMultiNestedForm.Example.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> assoc_constraint(:post)
  end
end
