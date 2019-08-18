defmodule TgScrumPoker.Bot do
  @bot_name :tg_scrum_poker

  use ExGram.Bot, name: @bot_name
  require Logger

  def bot(), do: @bot_name

  def handle({:message, msg}, context) do
    Logger.info(~s"Some strange message #{inspect(msg)}")
    context
  end

  def handle({:command, "start", msg}, context) do
    context |> delete(msg) |> answer("Hello, sweety!")
  end

  def handle({:command, "story", %{chat: %{id: id}, text: text} = msg}, context) do
    TgScrumPoker.Chat.Supervisor.start_chat(id)
    TgScrumPoker.Chat.start_story(id, %TgScrumPoker.Chat.Story{text: text})
    context |> delete(msg) |> answer(~s"Story \"#{text}\" started")
  end

  def handle({:text, text, %{chat: %{id: id}} = msg}, context) do
    case Integer.parse(text) do
      {score, _} ->
        vote_score(id, score, msg)
        context |> delete(msg)

      :error ->
        context
    end
  end

  def handle({:command, "end", %{chat: %{id: id}} = msg}, context) do
    %{text: text, votes: votes} = TgScrumPoker.Chat.get_story(id)

    votes_array = votes |> Map.values
    max_score = votes_array |> Enum.max_by(fn vote -> vote.score end)
    min_score = votes_array |> Enum.min_by(fn vote -> vote.score end)
    scores = votes_array |> Enum.map(fn vote -> vote.score end)
    total = Enum.sum(scores) / Enum.count(scores)

    message = [
      ~s"*\"#{text}\"*",
      "",
      ~s"#{prepare_votes(votes_array)}",
      "",
      ~s"Средняя оценка: *#{total}*",
      "",
      ~s"🡅 #{max_score.name}: #{max_score.score}",
      ~s"🡇 #{min_score.name}: #{min_score.score}"
    ] |> Enum.join("\n")

    context
    |> delete(msg)
    |> answer(message, [parse_mode: "markdown"])
  end

  defp vote_score(id, score, msg) do
    {:ok, user} = extract_user(msg)

    TgScrumPoker.Chat.vote_story(id, %TgScrumPoker.Chat.Vote{
      user_id: user.id,
      name: extract_name(user),
      score: score
    })
  end

  defp prepare_votes(votes) do
    votes
    |> Enum.map(fn vote -> prepare_vote(vote) end)
    |> Enum.join("\n")
  end

  defp prepare_vote(%{name: name, score: score}) do
    ~s"#{name}: #{score}"
  end

  defp extract_name(user) do
    case user do
      %{first_name: first_name, last_name: last_name} -> ~s"#{first_name} #{last_name}"
      %{first_name: first_name} -> first_name
    end
  end
end
