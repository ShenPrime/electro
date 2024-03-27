defmodule ElectroDb.Repo.Migrations.AlterAnswerToText do
  use Ecto.Migration

  def change do
    drop table(:answers)

    create table(:answers) do
      add :swedish_question, :text
      add :arabic_translate, :text
      add :swedish_answer, :text
      add :arabic_answer, :text
      add :subject, :text
      add :note, :text
      add :pic, :text
    end
  end
end
