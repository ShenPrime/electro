defmodule ElectroDbWeb.HomePage.Components do
  use ElectroDbWeb, :component

  def copy_button(assigns) do
    ~H"""
    <div class="flex justify-center">
      <button
        class="w-6 mr-2"
        id={"copy-#{@column}-#{@id}"}
        phx-hook="Copy"
        data-to={"##{@column}-#{@id}"}
        phx-click="copy-message-success"
      >
        📋
      </button>
      <h2 class="font-bold text-sky-400"><%= @label %>:</h2>
    </div>
    <p id={"#{@column}-#{@id}"} class="m-1"><%= @content %></p>
    """
  end
end
