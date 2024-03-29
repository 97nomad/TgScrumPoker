defmodule TgScrumPoker.Chat do
  use GenServer, restart: :temporary

  defmodule Story do
    defstruct text: "", votes: %{}
  end

  defmodule Vote do
    defstruct user_id: 0, name: "", score: 0
  end

  def start_link(id) do
    GenServer.start_link(__MODULE__, %Story{}, name: via_tuple(id))
  end

  defp via_tuple(id) do
    {:via, :gproc, {:n, :l, {:chat, id}}}
  end

  def start_story(id, story) do
    GenServer.cast(via_tuple(id), {:start_story, story})
  end

  def get_story(id) do
    GenServer.call(via_tuple(id), :get_story)
  end

  def vote_story(id, vote) do
    GenServer.cast(via_tuple(id), {:vote, vote})
  end

  def init(story) do
    {:ok, story}
  end

  def handle_cast({:start_story, story}, _) do
    {:noreply, story}
  end

  def handle_cast({:vote, %{user_id: user_id} = vote}, %{votes: votes} = story) do
    {:noreply, %{story | votes: Map.put(votes, user_id, vote)}}
  end

  def handle_call(:get_story, _from, story) do
    {:reply, story, story}
  end
end
