defmodule TgScrumPoker.Printer do
  def help() do
    """
    Бот для покера планирования (Scrum Poker)

    Использование:
    1. Добавить в групповой чат
    2. Дать админские права на удаление сообщений (необязательно)

    Список команд:
    /help - выводит текст этого сообщения
    /story текст_истории - начать голосование за историю
    любая цифра - голосование за историю
    `?`, `inf` и `coffee` - голосование без циферок 
    /end - отображение статистики

    Особенности работы:
    Для подсчёта очков используется последовательность Фибоначчи
    При голосовании число округляется до ряда Фибоначчи в большую сторону
    Результат всегда округляется до ряда Фибоначчи в большую сторону

    Ряд фибоначчи:
    0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ?, inf, coffee
    """
  end

  def result(votes, text) do
    scores = votes |> Enum.map(fn vote -> vote.score end)
    integer_votes = votes |> Enum.filter(fn x -> is_integer(x.score) end)
    integer_scores = scores |> Enum.filter(&is_integer(&1))

    max_score = integer_votes |> Enum.max_by(fn x -> x.score end, fn -> :empty end)
    min_score = integer_votes |> Enum.min_by(fn x -> x.score end, fn -> :empty end)

    total =
      unless Enum.empty?(integer_scores) do
        (Enum.sum(integer_scores) / Enum.count(integer_scores))
        |> Kernel.trunc()
        |> TgScrumPoker.Poker.round_up()
      else
        0
      end

    [
      ~s"*\"#{text}\"*",
      "",
      ~s"#{votes(votes)}",
      "",
      ~s"Средняя оценка: *#{total}*",
      ""
    ]
    |> add_max_score(max_score)
    |> add_min_score(min_score)
    |> Enum.join("\n")
  end

  defp add_max_score(array, vote) do
    case vote do
      :empty -> array
      %{name: name, score: score} -> array ++ [~s"🡅 #{name}: #{score}"]
    end
  end

  defp add_min_score(array, vote) do
    case vote do
      :empty -> array
      %{name: name, score: score} -> array ++ [~s"🡇 #{name}: #{score}"]
    end
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
    symbol =
      case score do
        _ when is_integer(score) -> "#{score}"
        :coffee -> "☕️"
        :question -> "❔"
        :infinity -> "♾️"
      end

    ~s"#{name}: #{symbol}"
  end
end
