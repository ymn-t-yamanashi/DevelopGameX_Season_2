defmodule DevelopGamex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DevelopGamexWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:develop_gamex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DevelopGamex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DevelopGamex.Finch},
      # Start a worker by calling: DevelopGamex.Worker.start_link(arg)
      # {DevelopGamex.Worker, arg},
      # Start to serve requests, typically the last entry
      DevelopGamexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DevelopGamex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DevelopGamexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
