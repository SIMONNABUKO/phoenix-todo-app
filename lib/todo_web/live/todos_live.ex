defmodule TodoWeb.TodosLive do
  use TodoWeb, :live_view

  alias Todo.Items
  alias Todo.Items.Item

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-100 w-full flex items-center justify-center bg-teal-lightest font-sans">
      <div class="bg-white rounded shadow p-6 m-4 w-full lg:w-3/4 lg:max-w-lg">
        <div class="mb-4">
          <h1 class="text-grey-darkest">Todo List</h1>
          
          <.form phx-submit="add-item" for={@form}>
            <div class="flex mt-4">
              <.input
                class="shadow appearance-none border rounded w-full py-2 px-3 mr-4 text-grey-darker"
                placeholder="Todo Name"
                field={@form[:name]}
              />
              <.input
                class="shadow appearance-none border rounded w-full py-2 px-3 mr-4 text-grey-darker"
                placeholder="Description"
                field={@form[:description]}
              />
              <.button
                phx-disable-with="Saving"
                type="submit"
                class="flex-no-shrink p-2 border-2 rounded text-teal border-teal hover:text-white hover:bg-teal"
              >
                Add
              </.button>
            </div>
          </.form>
        </div>
        
        <div>
          <%!-- <pre>
         <%=inspect(@form, pretty: true) %>
        </pre> --%>
          <div :for={item <- @items} class="flex mb-4 items-center">
            <p class={"w-full text-grey-darkest #{if item.completed, do: "line-through"}"}>
              <%= item.name %>
            </p>
            
            <p class={"w-full text-grey-darkest #{if item.completed, do: "line-through"}"}>
              <%= item.description %>
            </p>
            
            <button
              class={"text-white  py-2 px-4 rounded bg-blue-500 hover:bg-blue-700  #{if item.completed, do: "bg-green-500 hover:bg-green-700 "} "}
              phx-click="toggle-status"
              phx-value-id={item.id}
            >
              <%= if item.completed, do: "Done", else: "Pending" %>
            </button>
            
            <button
              class="bg-red-500 hover:bg-red-700 text-white py-2 px-4 rounded"
              phx-click="delete"
              phx-value-id={item.id}
            >
              Del
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    items = Items.get_items()

    changeset = Items.change_item(%Item{})

    form = to_form(changeset)
    {:ok, assign(socket, form: form, items: items)}
  end

  @impl true
  def handle_event("add-item", %{"item" => item_params}, socket) do
    # IO.inspect(item_params)
    # IO.inspect(item_params, label: "PARAMS FROM THE FORM: ")

    case Items.create_item(item_params) do
      {:ok, item} ->
        socket = update(socket, :items, fn items -> [item | items] end)
        changeset = Items.change_item(%Item{})
        form = to_form(changeset)
        {:noreply, assign(socket, form: form)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("done", %{"id" => id}, socket) do
    IO.puts("Button clicked with ID: #{id}")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle-status", %{"id" => id}, socket) do
    item = Items.get_item!(id)

    {:ok, item} = Items.update_item(item, %{completed: !item.completed})
    items = Items.get_items()
    {:noreply, assign(socket, item: item, items: items)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    {:ok, _} = Items.delete_item(item)
    items = Items.get_items()

    {:noreply, assign(socket, items: items)}
  end
end
