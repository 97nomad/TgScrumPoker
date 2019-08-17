defmodule Storage do
  use GenServer

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, [], name: :storage}
    }
  end

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(init_arg) do
    :ets.new(:stories, [:set, :public, :named_table])
    {:ok, init_arg}
  end

  def handle_call({:store, chat_id, text}) do
    :ets.insert(:stories, {chat_id, text})
  end

  def handle_call({:get, chat_id}) do
    {:reply, hd(:ets.lookup(:stories, chat_id))}
  end
end
