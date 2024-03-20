defmodule ElectroDbWeb.HomePageLive do
  use ElectroDbWeb, :live_view

  import ElectroDbWeb.HomePage.Components
  alias ElectroDb.Utilities

  def mount(_params, _session, socket) do
    entry_count = Utilities.get_entry_count("swedish_question")

    columns = [
      %{name: "arabic_answer", label: "Arabic Answer"},
      %{name: "swedish_question", label: "Swedish Question"},
      %{name: "arabic_translate", label: "Arabic Translate"},
      %{name: "swedish_answer", label: "Swedish Answer"},
      %{name: "note", label: "Note"},
      %{name: "pic", label: "Image"}
    ]

    socket =
      assign(socket,
        entry_count: entry_count,
        no_results: false,
        question: "",
        answers: [],
        loading: false,
        checked: "swedish_question",
        columns: columns,
        result_count: 0
      )

    {:ok, socket, temporary_assigns: [answers: []]}
  end

  def handle_event("search", %{"question" => question, "column" => column}, socket) do
    send(self(), {:run_search, question, column})
    socket = assign(socket, question: question, answers: [], loading: true, no_results: false)
    {:noreply, socket}
  end

  def handle_event("get-count", params, socket) do
    count = Utilities.get_entry_count(params["value"])
    socket = assign(socket, entry_count: count, checked: params["value"])
    {:noreply, socket}
  end

  def handle_event("copy-message-success", _, socket) do
    socket = put_flash(socket, :info, "Copied to clipboard!")
    send(self(), :clear_flash)
    {:noreply, socket}
  end

  def handle_info(:clear_flash, socket) do
    Process.sleep(2000)
    socket = clear_flash(socket)
    {:noreply, socket}
  end

  def handle_info({:run_search, question, column}, socket) do
    answers = Utilities.query_db(question, column)

    socket =
      if length(answers) == 0 do
        assign(socket, no_results: true, loading: false, answers: [])
      else
        assign(socket,
          question: question,
          answers: answers,
          loading: false,
          result_count: length(answers)
        )
      end

    {:noreply, socket}
  end
end
