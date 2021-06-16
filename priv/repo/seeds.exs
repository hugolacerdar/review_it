# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReviewIt.Repo.insert!(%ReviewIt.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ReviewIt.{Repo, Technology}

%{hex_color: "#7ec728", name: "Node.js"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#f7df1e", name: "JavaScript"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#61dafb", name: "React"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#01d1f7", name: "React Native"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#43caf6", name: "Flutter"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#ac98b1", name: "Elixir"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#e95122", name: "Phoenix"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#325d87", name: "PostgreSQL"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#4aa348", name: "MongoDB"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#f7ce36", name: "Python"} |> Technology.changeset() |> Repo.insert!()
%{hex_color: "#7377ad", name: "PHP"} |> Technology.changeset() |> Repo.insert!()
