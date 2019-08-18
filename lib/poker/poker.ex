defmodule TgScrumPoker.Poker do
  @allowed_scores [0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

  def is_score_allowed(score) do
    Enum.member?(@allowed_scores, score)
  end

  def round_up(score) do
    cond do
      is_score_allowed(score) -> score
      score > 144 -> 144
      true -> round_up(score + 1)
    end
  end
end
