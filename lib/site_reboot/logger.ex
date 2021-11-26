defmodule SiteReboot.Logger do
  require Logger

  def info(log) do
    log
    |> inspect()
    |> Logger.info()
  end

  def error(error) do
    error
    |> inspect()
    |> Logger.error()
  end

  def error(error, other_error) do
    full_error = inspect(error) <> inspect(other_error)
    error(full_error)
  end
end
