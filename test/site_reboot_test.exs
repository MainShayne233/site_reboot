defmodule SiteRebootTest do
  use ExUnit.Case

  describe "run/0" do
    test "passing check" do
      {:ok, agent} = Agent.start(fn -> :init end)

      Application.put_env(
        SiteReboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, []},
          pass_callback: {Agent, :update, [agent, fn :init -> :passed end]}
        ]
      )

      assert SiteReboot.run() == {:ok, :passed}
      assert Agent.get(agent, &Function.identity/1) == :passed
    end

    test "successful reboot" do
      {:ok, agent} = Agent.start(fn -> :init end)

      Application.put_env(
        SiteReboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [fail: true]}
        ],
        reboot: [
          method: {SiteReboot.Reboot.TestAdapter, []},
          success_callback: {Agent, :update, [agent, fn :init -> :rebooted end]}
        ]
      )

      assert SiteReboot.run() == {:ok, :rebooted}

      assert Agent.get(agent, &Function.identity/1) == :rebooted
    end

    test "check error" do
      {:ok, agent} = Agent.start(fn -> :init end)

      Application.put_env(
        SiteReboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [error: true]},
          error_callback: &Agent.update(agent, fn :init -> &1 end)
        ]
      )

      assert SiteReboot.run() == {:error, {:check, "mock check error"}}

      assert Agent.get(agent, &Function.identity/1) == "mock check error"
    end

    test "reboot error" do
      {:ok, agent} = Agent.start(fn -> :init end)

      Application.put_env(
        SiteReboot,
        :config,
        check: [
          method: {SiteReboot.Check.TestAdapter, [fail: true]}
        ],
        reboot: [
          method: {SiteReboot.Reboot.TestAdapter, [error: true]},
          error_callback: &Agent.update(agent, fn :init -> &1 end)
        ]
      )

      assert SiteReboot.run() == {:error, {:reboot, "mock reboot error"}}

      assert Agent.get(agent, &Function.identity/1) == "mock reboot error"
    end
  end
end
