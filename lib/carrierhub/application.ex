defmodule Carrierhub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      # Start the Telemetry supervisor
      CarrierhubWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Carrierhub.PubSub},
      # Start the Endpoint (http/https)
      CarrierhubWeb.Endpoint,
      worker(Mongo, [[name: :mongo, url: "mongodb://localhost:27017/carrierhub_local", pool_size: 10]])
      # Start a worker by calling: Carrierhub.Worker.start_link(arg)
      # {Carrierhub.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Carrierhub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CarrierhubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end