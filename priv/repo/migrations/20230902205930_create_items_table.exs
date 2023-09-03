defmodule Todo.Repo.Migrations.CreateItemsTable do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :string
      add :completed, :boolean, default: false

      timestamps()
    end

  end
end
