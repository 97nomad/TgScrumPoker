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
    context |> delete(msg) |> answer(~s"Story #{text} started")
  end

  def handle({:text, text, %{chat: %{id: id}} = msg}, context) do
    case Integer.parse(text) do
      {score, _} ->
        vote_score(id, score)
        context |> delete(msg)

      :error ->
        context
    end
  end

  def handle({:command, "end", %{chat: %{id: id}} = msg}, context) do
    %{text: text, votes: votes} = TgScrumPoker.Chat.get_story(id)
    context |> delete(msg) |> answer(~s"Story #{text} ended with votes #{inspect(votes)}")
  end

  defp vote_score(id, score) do
    TgScrumPoker.Chat.vote_story(id, score)
  end
end
