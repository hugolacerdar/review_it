defmodule ReviewItWeb.Auth.Guardian do
  use Guardian, otp_app: :review_it

  alias ReviewIt.{Error, User}

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ReviewIt.get_user_by_id()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- ReviewIt.get_user_by_email(email),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token, user}
    else
      _ -> {:error, Error.build(:unauthorized, "Please verify your credentials")}
    end
  end

  def authenticate(_params) do
    {:error, Error.build(:bad_request, "Invalid or missing params")}
  end
end
