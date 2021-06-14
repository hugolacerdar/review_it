defmodule ReviewIt.Factory do
  use ExMachina.Ecto, repo: ReviewIt.Repo

  def user_params_factory do
    %{
      "nickname" => "Banana",
      "email" => "banana@mail.com",
      "password" => "banana123"
    }
  end
end
