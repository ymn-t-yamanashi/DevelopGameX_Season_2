defmodule DevelopGamexWeb.GameLive.Index do
  use DevelopGamexWeb, :live_view
  import DevelopGamex.Draw

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :update, 25)

    socket =
      socket
      |> assign(data: [])

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 12)

    socket =
      socket
      |> assign(data: create_data())

    {:noreply, socket}
  end

  def create_data() do
    [
      fill_style("#000000"),
      fill_rect(0, 0, 1024, 768),
      stroke_style("#00FF00"),
      begin_path(),
      move_to(0, 0),
      line_to(300, 300),
      stroke()
    ]
  end
end
