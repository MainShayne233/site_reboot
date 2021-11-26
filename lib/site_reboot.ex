defmodule SiteReboot do
  require Logger

  @spec run() :: {:ok, :passed | :rebooted} | {:error, {:check, term()} | {:reboot, term()}}
  def run do
    with {:ok, callback} <- Keyword.fetch(config!(), :pre_init_callback),
         do: apply_callback(callback)

    with {:check, {:ok, :fail}} <- {:check, check_site()} do
      {:reboot, reboot_site()}
    end
    |> handle()
  end

  @spec check_site() :: {:ok, :pass | :fail} | {:error, term()}
  defp check_site do
    {module, opts} = Keyword.fetch!(check_config!(), :method)
    apply(module, :run, [opts])
  end

  @spec reboot_site() :: :ok | {:error, term()}
  defp reboot_site do
    {module, opts} = Keyword.fetch!(reboot_config!(), :method)
    apply(module, :run, [opts])
  end

  defp handle({:check, {:ok, :pass}}) do
    with {:ok, callback} <- Keyword.fetch(check_config!(), :pass_callback) do
      apply_callback(callback, [])
    end

    {:ok, :passed}
  end

  defp handle({:reboot, :ok}) do
    with {:ok, callback} <- Keyword.fetch(reboot_config!(), :success_callback) do
      apply_callback(callback, [])
    end

    {:ok, :rebooted}
  end

  defp handle({:check, {:error, error}}) do
    with {:ok, callback} <- Keyword.fetch(check_config!(), :error_callback) do
      apply_callback(callback, [error])
    end

    if Keyword.get(config!(), :reboot_on_check_error) == true do
      handle({:reboot, reboot_site()})
    else
      {:error, {:check, error}}
    end
  end

  defp handle({:reboot, {:error, error}}) do
    with {:ok, callback} <- Keyword.fetch(reboot_config!(), :error_callback) do
      apply_callback(callback, [error])
    end

    {:error, {:reboot, error}}
  end

  defp apply_callback(fun, args \\ [])

  defp apply_callback({module, fun, args}, extra_args) do
    apply(module, fun, args ++ extra_args)
  end

  defp apply_callback(fun, args) when is_function(fun) do
    apply(fun, args)
  end

  defp config!, do: Application.fetch_env!(:site_reboot, :config)
  defp check_config!, do: Keyword.fetch!(config!(), :check)
  defp reboot_config!, do: Keyword.fetch!(config!(), :reboot)
end
