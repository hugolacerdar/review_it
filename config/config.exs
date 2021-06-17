# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :review_it,
  ecto_repos: [ReviewIt.Repo]

# Configures the endpoint
config :review_it, ReviewItWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zMOxXtRLT+rMeCxGIjHq6eXsH1MEntsDdzz+D61KIyMzFZdmEzy4XN2JE433AUih",
  render_errors: [view: ReviewItWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ReviewIt.PubSub,
  live_view: [signing_salt: "vBT3FR7t"]

config :review_it, ReviewItWeb.Auth.Guardian,
  issuer: "review_it",
  secret_key: "9cVnUefPYB0z/SE4uC00G8MnLFRgqwLqNkTfwqkgzFu1LnMP6sBj2EC1wuTeVcU0"

config :review_it, ReviewItWeb.Auth.Pipeline,
  module: ReviewItWeb.Auth.Guardian,
  error_handler: ReviewItWeb.Auth.ErrorHandler

# ecto migrations config
config :review_it, ReviewIt.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

# imgbb image upload server config
config :review_it, ReviewIt.Imgbb.Client, key: System.get_env("IMGBB_KEY")

# files controller config
config :review_it, ReviewItWeb.FilesController, client: ReviewIt.Imgbb.Client

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
