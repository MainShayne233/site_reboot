defmodule SiteReboot.Reboot.DigitalOceanAdapter do
  defmodule API do
    use Tesla

    plug(Tesla.Middleware.BaseUrl, "https://api.digitalocean.com/v2/")
    plug(Tesla.Middleware.JSON)
    plug(Tesla.Middleware.Timeout, timeout: 20_000)

    def reboot(app_id, bearer_token) do
      post("/droplets/#{app_id}/actions", %{"type" => "reboot"},
        headers: [
          {"Authorization", "Bearer #{bearer_token}"}
        ]
      )
    end
  end

  def run(opts) do
    bearer_token = Keyword.fetch!(opts, :bearer_token)
    app_id = Keyword.fetch!(opts, :app_id)

    case __MODULE__.API.reboot(app_id, bearer_token) do
      {:ok, %Tesla.Env{status: 201}} -> :ok
      env -> {:error, {:tesla_post_error, env}}
    end
  end
end
