defmodule ElectroDb.Utilities do
  import Ecto.Query

  alias ElectroDb.Answers
  alias ElectroDb.Repo

  def get_entry_count(column) do
    Answers
    |> where([a], fragment("? IS NOT NULL", literal(^column)))
    |> Repo.aggregate(:count)
  end

  def query_db(question, column) do
    Answers
    |> where(
      [a],
      fragment("? @@ websearch_to_tsquery(?)", literal(^column), ^question)
    )
    |> Repo.all()
  end
end
