defmodule ElectroDbWeb.HomePageLive do
  use ElectroDbWeb, :live_view

  alias ElectroDb.Utilities

  @impl true
  def mount(_params, _session, socket) do
    entry_count = Utilities.get_entry_count("swedish_question")

    columns = [
      %{name: "arabic_answer", label: "Arabic Answer"},
      %{name: "swedish_question", label: "Swedish Question"},
      %{name: "arabic_translate", label: "Arabic Translate"},
      %{name: "swedish_answer", label: "Swedish Answer"},
      %{name: "note", label: "Note"}
    ]

    socket =
      assign(socket,
        entry_count: entry_count,
        question: "",
        answers: [],
        loading: false,
        checked: "swedish_question",
        columns: columns,
        result_count: 0
      )

    {:ok, socket, temporary_assigns: [answers: []]}
  end

  @impl true
  def handle_event("search", %{"question" => question, "column" => column}, socket) do
    send(self(), {:run_search, question, column})
    socket = assign(socket, question: question, answers: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("get-count", params, socket) do
    count = Utilities.get_entry_count(params["value"])
    socket = assign(socket, entry_count: count, checked: params["value"])
    {:noreply, socket}
  end

  @impl true
  def handle_info({:run_search, question, column}, socket) do
    answers = Utilities.query_db(question, column)

    socket =
      assign(socket,
        question: question,
        answers: answers,
        loading: false,
        result_count: length(answers)
      )

    {:noreply, socket}
  end
end
