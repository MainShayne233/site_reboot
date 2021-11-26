defmodule SiteReboot.Check.TestAdapter do
  def run(opts) do
    case {Keyword.fetch(opts, :fail), Keyword.fetch(opts, :error)} do
      {{:ok, true}, :error} -> {:ok, :fail}
      {:error, {:ok, true}} -> {:error, "mock check error"}
      {:error, :error} -> {:ok, :pass}
      _ -> raise "Invalid options for SiteReboot.Check.TestAdapter"
    end
  end
end
