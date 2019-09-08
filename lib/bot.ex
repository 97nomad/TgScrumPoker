defmodule TgScrumPoker.Bot do
  @bot_name :tg_scrum_poker

  alias TgScrumPoker.Printer
  alias TgScrumPoker.Chat
  alias TgScrumPoker.Poker

  use ExGram.Bot, name: @bot_name
  require Logger

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot_name

  def handle({:command, "start", msg}, context) do
    context |> delete(msg) |> answer(Printer.help())
  end

  def handle({:command, "help", msg}, context) do
    context |> delete(msg) |> answer(Printer.help())
  end

  def handle({:command, "story", %{chat: %{id: id}, text: text} = msg}, context) do
    Logger.info(~s"Start story #{text} for chat #{id}")
    Chat.Supervisor.start_chat(id)
    Chat.start_story(id, %Chat.Story{text: text})

    context
    |> delete(msg)
    |> answer(Printer.start_story(text), parse_mode: "markdown")
  end

  def handle({:text, text, %{chat: %{id: id}} = msg}, context) do
    case parse_score(text) do
      :error ->
        context

      result ->
        vote_score(id, result, msg)
        context |> delete(msg)
    end
  end

  def handle({:command, "coffee", %{chat: %{id: id}} = msg}, context) do
    vote_score(id, :coffee, msg)
    context |> delete(msg)
  end

  def handle({:command, "infinity", %{chat: %{id: id}} = msg}, context) do
    vote_score(id, :infinity, msg)
    context |> delete(msg)
  end

  def handle({:command, "end", %{chat: %{id: id}, text: text} = msg}, context) do
    Logger.info(~s"End story #{text} for chat #{id}")
    %{text: text, votes: votes} = Chat.get_story(id)

    message =
      votes
      |> Map.values()
      |> Printer.result(text)

    context
    |> delete(msg)
    |> answer(message, parse_mode: "markdown")
  end

  defp vote_score(id, score, msg) do
    {:ok, user} = extract_user(msg)

    Chat.vote_story(id, %Chat.Vote{
      user_id: user.id,
      name: TgScrumPoker.Utils.extract_name(user),
      score: score
    })
  end

  defp parse_score(score) do
    maybe_score = Integer.parse(score)

    case score do
      "?" ->
        :question

      "coffee" ->
        :coffee

      "inf" ->
        :infinity

      _ when maybe_score != :error ->
        {score, _} = maybe_score
        Poker.round_up(score)

      _ ->
        :error
    end
  end
end
