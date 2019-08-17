defmodule TgScrumPoker.Bot do
  @bot_name :tg_scrum_poker

  use ExGram.Bot, name: @bot_name

  def bot(), do: @bot_name

  def handle({:command, "start", _msg}, context) do
    answer(context, "Hello, deer!")
  end

  def handle({:command, "story", %{chat: %{id: id}, text: text} = _msg}, context) do
    TgScrumPoker.Chat.Supervisor.start_chat(id)
    TgScrumPoker.Chat.start_story(id, {id, text})
    answer(context, ~s"Story #{text} started")
  end

  def handle({:command, "end", %{chat: %{id: id}} = _msg}, context) do
    {_, text} = TgScrumPoker.Chat.get_story(id)
    answer(context, ~s"Story #{text} ended")
  end
end
