defmodule ReviewIt.Factory do
  use ExMachina.Ecto, repo: ReviewIt.Repo

  alias ReviewIt.{Post, Technology, User}

  def user_params_factory do
    %{
      "nickname" => "Banana",
      "email" => "banana@mail.com",
      "password" => "banana123"
    }
  end

  def session_params_factory do
    %{
      "email" => "banana@mail.com",
      "password" => "banana123"
    }
  end

  def post_params_factory do
    %{
      "code_url" => "www.codehub.com/12345ds2",
      "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
      "description" =>
        "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
      "reviewer_id" => "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
      "title" => "Please review the Business logic on Module XPTO"
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

  def post_factory do
    %Post{
      id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
      title: "Please review the Business logic on Module XPTO",
      description:
        "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
      code_url: "www.codehub.com/12345ds2",
      creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
      reviewer_id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
      inserted_at: "2021-06-15T18:41:52Z"
    }
  end

  def technology_factory do
    %Technology{
      hex_color: "#325d87",
      id: "7df1040f-3644-4142-a2d6-20c6b0c4ab90",
      name: "PostgreSQL"
    }
  end
end
