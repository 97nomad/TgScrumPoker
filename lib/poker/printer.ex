defmodule TgScrumPoker.Printer do
  def result(votes, text) do
    max_score = votes |> Enum.max_by(fn vote -> vote.score end)
    min_score = votes |> Enum.min_by(fn vote -> vote.score end)
    scores = votes |> Enum.map(fn vote -> vote.score end)

    total =
      (Enum.sum(scores) / Enum.count(scores))
      |> Kernel.trunc()
      |> TgScrumPoker.Poker.round_up()

    [
      ~s"*\"#{text}\"*",
      "",
      ~s"#{votes(votes)}",
      "",
      ~s"Средняя оценка: *#{total}*",
      "",
      ~s"🡅 #{max_score.name}: #{max_score.score}",
      ~s"🡇 #{min_score.name}: #{min_score.score}"
    ]
    |> Enum.join("\n")
  end

  def start_story(text) do
    ~s"*\"#{text}\"*"
  end

  def votes(votes) do
    votes
    |> Enum.map(fn vote -> vote(vote) end)
    |> Enum.join("\n")
  end

  def vote(%{name: name, score: score}) do
    ~s"#{name}: #{score}"
  end
end
