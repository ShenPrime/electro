defmodule ElectroDb.Utilities do
  import Ecto.Query

  alias ElectroDb.Answers
  alias ElectroDb.Repo
  alias NimbleCSV.RFC4180, as: CSV

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

  def parse_csv(path) do
    path
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.map(fn [
                       id,
                       swedish_question,
                       arabic_translate,
                       swedish_answer,
                       arabic_answer,
                       subject,
                       note,
                       pic
                     ] ->
      if id != "" do
        %{
          id: String.to_integer(id),
          swedish_question: swedish_question,
          arabic_translate: arabic_translate,
          swedish_answer: swedish_answer,
          arabic_answer: arabic_answer,
          subject: subject,
          note: note,
          pic: pic
        }
      else
        %{
          id: id,
          swedish_question: swedish_question,
          arabic_translate: arabic_translate,
          swedish_answer: swedish_answer,
          arabic_answer: arabic_answer,
          subject: subject,
          note: note,
          pic: pic
        }
      end
    end)
    |> Enum.into([])
  end

  def insert_rows(rows) do
    Enum.reduce(rows, %{inserted: 0, errors: []}, fn row, acc ->
      changeset = Answers.changeset(%ElectroDb.Answers{}, row)

      acc =
        if changeset.valid? do
          case Repo.insert(changeset, on_conflict: :replace_all, conflict_target: :id) do
            {:ok, _} ->
              %{acc | inserted: acc.inserted + 1}

            {:error, changeset} ->
              #TODO: save faulty rows to return to user
              %{acc | errors: [changeset.errors | acc.errors]}
          end
        else
          %{acc | errors: [changeset.errors | acc.errors]}
        end

      acc
    end)
  end

  # def pretty_print_errors(error) do
  #   Ecto.Changeset.traverse_errors(error, fn {msg, opts} ->
  #     Enum.reduce(opts, msg, fn {key, value}, acc ->
  #       String.replace(acc, "%{#{key}}", to_string(value))
  #     end)
  #   end)
  # end
end
