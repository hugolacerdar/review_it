defmodule ReviewIt.Factory do
  use ExMachina.Ecto, repo: ReviewIt.Repo

  alias ReviewIt.User

  def user_params_factory do
    %{
      "nickname" => "Banana",
      "email" => "banana@mail.com",
      "password" => "banana123"
    }
  end

  def user_factory do
    %User{
      id: "e38317b6-f234-4bfe-84df-29f650f59a06",
      nickname: "Banana",
      email: "banana@mail.com",
      password_hash:
        "$pbkdf2-sha512$160000$yRB9lvY8YZP08PbN4tCYKw$ISrRoQ9aZszXA2I5.Lo3mA7y7fVHdxRh268L/kpXZ7m.FWwADukvF8aJ/soTsSZZp92BnxY8NhAm1MhxUQWS0Q",
      is_expert: false
    }
  end
end
