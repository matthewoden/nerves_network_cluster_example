defmodule Mypi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]


  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mypi.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  def cluster do
    topologies =  [
      gossip: [
        strategy: Elixir.Cluster.Strategy.Gossip,
        config: [
          port: 45892,
          if_addr: "0.0.0.0",
          multicast_addr: "230.1.1.251",
          multicast_ttl: 1,
          secret: System.get_env("NERVES_CLUSTER_SECRET")
        ]
      ]
    ]

    {Cluster.Supervisor, [topologies, [name: Mypi.ClusterSupervisor]]}
  end

  def children() do
    [cluster()] ++ children(@target)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: Mypi.Worker.start_link(arg)
      # {Mypi.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: Mypi.Worker.start_link(arg)
      # {Mypi.Worker, arg},
    ]
  end
end
