defmodule ElectroDb.Answers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :swedish_question, :string
    field :arabic_translate, :string
    field :swedish_answer, :string
    field :arabic_answer, :string
    field :subject, :string
    field :note, :string
    field :pic, :string
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> cast(params, [
      :id,
      :swedish_question,
      :arabic_translate,
      :swedish_answer,
      :arabic_answer,
      :subject,
      :note,
      :pic
    ])
    |> validate_required(:id)
  end
end
