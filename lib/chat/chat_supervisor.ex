defmodule TgScrumPoker.Chat.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :chat_supervisor)
  end

  def start_chat(id) do
    Supervisor.start_child(:chat_supervisor, [id])
  end

  def init(_) do
    children = [
      worker(TgScrumPoker.Chat, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
