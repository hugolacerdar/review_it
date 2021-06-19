defmodule ReviewIt.Factory do
  use ExMachina.Ecto, repo: ReviewIt.Repo

  alias Plug.Upload
  alias ReviewIt.Imgbb.Client.Response
  alias ReviewIt.{Post, Rank, Review, Technology, Stat, User}

  def user_params_factory do
    %{
      "nickname" => "Banana",
      "email" => "banana@mail.com",
      "password" => "banana123",
      "github_url" => "https://github.com/banana",
      "linkedin_url" => "https://linkedin.com/in/banana"
    }
  end

  def session_params_factory do
    %{
      "email" => "banana@mail.com",
      "password" => "banana123"
    }
  end

  def rank_factory do
    %{month: month, year: year} = DateTime.utc_now()

    %Rank{
      month: month,
      year: year,
      score: 10,
      user_id: "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a"
    }
  end

  def review_params_factory do
    %{
      "description" => "this is a description",
      "suggestions" => "this is a suggestions",
      "strengths" => "this is a strengths",
      "weakness" => "this is a weakness",
      "post_id" => "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
      "user_id" => "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a"
    }
  end

  def review_factory do
    %Review{
      id: "3beb6a91-1580-455a-b377-13930f08565d",
      description: "this is a description",
      suggestions: "this is a suggestions",
      strengths: "this is a strengths",
      weakness: "this is a weakness",
      post_id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
      user_id: "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a"
    }
  end

  def image_file_factory do
    %Upload{
      content_type: "image/png",
      filename: "image.png",
      path: Path.join(File.cwd!(), "test/support/mocks/image.png")
    }
  end

  def upload_response_factory do
    %Response{
      image_url: "https://some-url.com.br"
    }
  end

  def post_params_factory do
    %{
      "code_url" => "www.codehub.com/12345ds2",
      "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
      "description" =>
        "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
      "title" => "Please review the Business logic on Module XPTO",
      "technologies" => ["7df1040f-3644-4142-a2d6-20c6b0c4ab90"]
    }
  end

  def stat_factory do
    %Stat{
      technology_id: "7df1040f-3644-4142-a2d6-20c6b0c4ab90",
      user_id: "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a",
      reviews: 1
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

  def user_expert_factory do
    %User{
      id: "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a",
      nickname: "Banana Expert",
      email: "banana_expert@mail.com",
      password_hash:
        "$pbkdf2-sha512$160000$yRB9lvY8YZP08PbN4tCYKw$ISrRoQ9aZszXA2I5.Lo3mA7y7fVHdxRh268L/kpXZ7m.FWwADukvF8aJ/soTsSZZp92BnxY8NhAm1MhxUQWS0Q",
      is_expert: true
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
      star_review_id: nil,
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
