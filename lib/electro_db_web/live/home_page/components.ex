defmodule ElectroDbWeb.HomePage.Components do
  use ElectroDbWeb, :component

  def copy_button(assigns) do
    ~H"""
    <div class="flex justify-center text-center">
      <button
        class="mr-2 flex justify-center text-center"
        id={"copy-#{@column}-#{@id}"}
        phx-hook="Copy"
        data-to={"##{@column}-#{@id}"}
        phx-click="copy-message-success"
        title="Copy to clipboard"
      >
        📋
        <h2 class="font-bold text-sky-400 text-center hover:text-sky-300"><%= @label %>:</h2>
      </button>
    </div>
    <p id={"#{@column}-#{@id}"} class="m-1"><%= @content %></p>
    """
  end
end
