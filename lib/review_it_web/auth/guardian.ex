defmodule ReviewItWeb.Auth.Guardian do
  use Guardian, otp_app: :review_it

  alias ReviewIt.User

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ReviewIt.get_user_by_id()
  end
end
