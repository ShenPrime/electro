defmodule ElectroDb.Answers do
  use Ecto.Schema

  schema "answers" do
    field :swedish_question, :string
    field :arabic_translate, :string
    field :swedish_answer, :string
    field :arabic_answer, :string
    field :subject, :string
    field :note, :string
    field :pic, :string
  end

end
