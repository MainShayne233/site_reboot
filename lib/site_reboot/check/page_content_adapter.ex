defmodule SiteReboot.Check.PageContentAdapter do
  def run(opts) do
    path = Keyword.fetch!(opts, :path)
    pattern = Keyword.fetch!(opts, :pattern)

    with {:get, {:ok, _status_code, _, ref}} <- {:get, :hackney.get(path)},
         {:read, {:ok, body}} <- {:read, :hackney.body(ref)} do
      if body =~ pattern, do: :pass, else: :fail
    else
      {:get, error} ->
        {:error, {:hackney_get_error, error}}

      {:read, error} ->
        {:error, {:hackney_read, error}}
    end
  end
end
