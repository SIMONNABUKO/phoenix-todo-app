defmodule Todo.Items do
  import Ecto.Query, warn: false

  alias Todo.Repo

  alias Todo.Items.Item

  def get_items do
    Repo.all(Item)
  end

  def get_item!(id) do
    Repo.get!(Item, id)
  end

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
