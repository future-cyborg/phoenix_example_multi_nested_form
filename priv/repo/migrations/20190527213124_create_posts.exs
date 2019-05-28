defmodule PhoenixExampleMultiNestedForm.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :text, :text

      timestamps()
    end

    create table(:comment) do
      add :text, :text
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comment, [:post_id])
  end
end
