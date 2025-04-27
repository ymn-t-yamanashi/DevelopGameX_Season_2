defmodule DevelopGamexWeb.GameLive.Index do
  use DevelopGamexWeb, :live_view
  import DevelopGamex.Draw

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :update, 25)

    socket =
      socket
      |> assign(character_data: initialization_character_data())
      |> assign(data: [])

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 12)
    {:noreply, main(socket)}
  end

  defp main(socket) do
    character_data = update(socket.assigns.character_data)

    socket
    |> assign(character_data: character_data)
    |> assign(data: draw(character_data))
  end

  defp initialization_character_data() do
    %{player: %{x: 1, y: 1}}
  end

  defp update(character_data) do
    player = character_data.player

    player_x = if player.x < 1024, do: player.x + 5, else: 0

    character_data
    |> Map.merge(%{player: %{x: player_x, y: 100}})
  end

  defp draw(character_data) do

    player = character_data.player
    [
      # 背景を黒
      fill_style("#000000"),
      fill_rect(0, 0, 1024, 768),

      # キャラクターを緑
      fill_style("#00ff00"),
      fill_rect(player.x, player.y, 20, 20)
    ]
  end
end
