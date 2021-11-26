defmodule SiteReboot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SiteReboot.Scheduler,
      SiteReboot.Server
    ]

    opts = [strategy: :one_for_one, name: SiteReboot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
