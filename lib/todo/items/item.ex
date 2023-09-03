defmodule Todo.Items.Item do

  use Ecto.Schema

  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :name, :string
    field :completed, :boolean, default: false

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |>cast(attrs, [:description, :name, :completed])
    |>validate_required([:description, :name])

  end

end
