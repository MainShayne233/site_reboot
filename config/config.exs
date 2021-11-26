use Mix.Config

if Mix.env() == :prod do
  config :logger, level: :debug

  config :site_reboot, SiteReboot.Scheduler,
    jobs: [
      {"*/5 * * * *", {SiteReboot, :run, []}}
    ]

  config :site_reboot, :config,
    pre_init_callback: {SiteReboot.Logger, :info, ["Running procedure"]},
    reboot_on_check_error: true,
    check: [
      method:
        {SiteReboot.Check.PageContentAdapter,
         [
           path: "https://jaxtakesaction.org/",
           pattern: "<title>JCAC</title>"
         ]},
      pass_callback: {SiteReboot.Logger, :info, ["Check passed"]},
      error_callback: {SiteReboot.Logger, :error, ["Check error: "]}
    ],
    reboot: [
      method:
        {SiteReboot.Reboot.DigitalOceanAdapter,
         [
           bearer_token: System.fetch_env!("DO_BEARER_TOKEN"),
           app_id: System.fetch_env!("DO_APP_ID")
         ]},
      success_callback: {SiteReboot.Logger, :info, ["Reboot successful"]},
      error_callback: {SiteReboot.Logger, :error, ["Reboot error: "]}
    ]

  config :site_reboot, SiteReboot.Server,
    adapter: Plug.Cowboy,
    plug: SiteReboot.Server.API,
    scheme: :http,
    port: System.fetch_env!("PORT")
end
