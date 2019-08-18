defmodule TgScrumPoker.Bot do
  @bot_name :tg_scrum_poker

  use ExGram.Bot, name: @bot_name
  require Logger

  def bot(), do: @bot_name

  def handle({:command, "start", msg}, context) do
    context |> delete(msg) |> answer("Hello, sweety!")
  end

  def handle({:command, "story", %{chat: %{id: id}, text: text} = msg}, context) do
    Logger.info(~s"Start story #{text} for chat #{id}")
    TgScrumPoker.Chat.Supervisor.start_chat(id)
    TgScrumPoker.Chat.start_story(id, %TgScrumPoker.Chat.Story{text: text})

    context
    |> delete(msg)
    |> answer(TgScrumPoker.Printer.start_story(text), parse_mode: "markdown")
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

  def handle({:command, "end", %{chat: %{id: id}, text: text} = msg}, context) do
    Logger.info(~s"End story #{text} for chat #{id}")
    %{text: text, votes: votes} = TgScrumPoker.Chat.get_story(id)

    message =
      votes
      |> Map.values()
      |> TgScrumPoker.Printer.result(text)

    context
    |> delete(msg)
    |> answer(message, parse_mode: "markdown")
  end

  defp vote_score(id, score, msg) do
    {:ok, user} = extract_user(msg)

    TgScrumPoker.Chat.vote_story(id, %TgScrumPoker.Chat.Vote{
      user_id: user.id,
      name: TgScrumPoker.Utils.extract_name(user),
      score: TgScrumPoker.Poker.round_up(score)
    })
  end
end
