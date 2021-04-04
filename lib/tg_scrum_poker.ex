defmodule TgScrumPoker do
  use Application

  require Logger

  import Supervisor.Spec

  def start(_type, _args) do
    token = System.get_env("TG_BOT_TOKEN")

    children = [
      supervisor(TgScrumPoker.Chat.Supervisor, []),
      supervisor(ExGram, []),
      {TgScrumPoker.Bot, [method: :polling, token: token]}
    ]

    opts = [strategy: :one_for_one, name: TgScrumPoker]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting TgScrumPoker bot")
        ok

      error ->
        IO.inspect(error)
        Logger.error(~s"Error starting TgScrumPoker bot")
    end
  end
end
