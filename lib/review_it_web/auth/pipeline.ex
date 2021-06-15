defmodule ReviewItWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :review_it

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
