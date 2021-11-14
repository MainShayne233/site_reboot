defmodule SiteReboot.Reboot.TestAdapter do
  def run(opts) do
    case Keyword.fetch(opts, :error) do
      {:ok, true} -> {:error, "mock reboot error"}
      :error -> :ok
    end
  end
end
