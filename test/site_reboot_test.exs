defmodule SiteRebootTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  require Logger

  describe "run/0" do
    test "passing check" do
      Application.put_env(
        :site_reboot,
        :config,
        pre_init_callback: fn -> Logger.info("Running procedure") end,
        check: [
          method: {SiteReboot.Check.TestAdapter, []},
          pass_callback: fn ->
            Logger.info("Check passed")
          end
        ]
      )

      log =
        capture_log(fn ->
          assert SiteReboot.run() == {:ok, :passed}
        end)

      assert log =~ "Running site reboot procedure"
      assert log =~ "Check passed"
    end

    test "successful reboot" do
      Application.put_env(
        :site_reboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [fail: true]}
        ],
        reboot: [
          method: {SiteReboot.Reboot.TestAdapter, []},
          success_callback: fn ->
            Logger.info("Successfully rebooted site")
          end
        ]
      )

      log =
        capture_log(fn ->
          assert SiteReboot.run() == {:ok, :rebooted}
        end)

      assert log =~ "Successfully rebooted site"
    end

    test "check error" do
      Application.put_env(
        :site_reboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [error: true]},
          error_callback: fn error ->
            Logger.info("Check error: #{inspect(error)}")
          end
        ]
      )

      log =
        capture_log(fn ->
          assert SiteReboot.run() == {:error, {:check, "mock check error"}}
        end)

      assert log =~ "Check error: \"mock check error\""
    end

    test "reboot error" do
      Application.put_env(
        :site_reboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [fail: true]}
        ],
        reboot: [
          method: {SiteReboot.Reboot.TestAdapter, [error: true]},
          error_callback: fn error ->
            Logger.info("Reboot error: #{inspect(error)}")
          end
        ]
      )

      log =
        capture_log(fn ->
          assert SiteReboot.run() == {:error, {:reboot, "mock reboot error"}}
        end)

      assert log =~ "Reboot error: \"mock reboot error\""
    end
  end
end
