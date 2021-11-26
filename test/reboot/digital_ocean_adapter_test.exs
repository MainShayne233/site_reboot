defmodule SiteReboot.Reboot.DigitalOceanAdapterTest do
  use ExUnit.Case

  describe "run/1" do
    @tag :dangerous
    test "successful reboot" do
      bearer_token = System.fetch_env!("DO_BEARER_TOKEN")
      app_id = System.fetch_env!("DO_APP_ID")

      res =
        SiteReboot.Reboot.DigitalOceanAdapter.run(
          bearer_token: bearer_token,
          app_id: app_id
        )

      assert res == :ok
    end

    @tag :dangerous
    test "failed reboot" do
      bearer_token = System.fetch_env!("DO_BEARER_TOKEN")
      app_id = System.fetch_env!("DO_APP_ID") <> "bad_id"

      res =
        SiteReboot.Reboot.DigitalOceanAdapter.run(
          bearer_token: bearer_token,
          app_id: app_id
        )

      assert match?({:error, {:tesla_post_error, {_, %Tesla.Env{}}}}, res)
    end
  end
end
