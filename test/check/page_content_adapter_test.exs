defmodule SiteReboot.Check.PageContentAdapterTest do
  use ExUnit.Case

  describe "run/1" do
    @tag :network
    test "passing check" do
      res =
        SiteReboot.Check.PageContentAdapter.run(
          path: "https://jaxtakesaction.org/",
          pattern: "<title>JCAC</title>"
        )

      assert res == {:ok, :pass}
    end

    @tag :network
    test "failing check" do
      res =
        SiteReboot.Check.PageContentAdapter.run(
          path: "https://jaxtakesaction.org/",
          pattern: "I don't expect this text to ever be on the page"
        )

      assert res == {:ok, :fail}
    end

    @tag :network
    test "error check" do
      res =
        SiteReboot.Check.PageContentAdapter.run(
          path: "https://jaxtakesaction.orgg/",
          pattern: "This should not matter"
        )

      assert res == {:error, {:hackney_get_error, {:error, :nxdomain}}}
    end
  end
end
