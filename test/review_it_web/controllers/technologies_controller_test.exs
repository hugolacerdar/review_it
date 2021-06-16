defmodule ReviewItWeb.TechnologiesControllerTest do
  use ReviewItWeb.ConnCase, async: false
  alias ReviewIt.{Repo, Technology}

  describe "index/2" do
    test "Returns the list of technologies ordered ", %{conn: conn} do
      # Arrange

      %{hex_color: "#ac98b1", name: "Elixir"} |> Technology.changeset() |> Repo.insert!()

      # Act
      response =
        conn
        |> get(Routes.technologies_path(conn, :index))
        |> json_response(:ok)

      # Assert
      assert %{
               "technologies" => [
                 %{"hex_color" => "#ac98b1", "name" => "Elixir", "id" => _id}
               ]
             } = response
    end
  end
end
