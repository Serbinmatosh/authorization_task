# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :authorization_task,
  ecto_repos: [AuthorizationTask.Repo]

# Configures the endpoint
config :authorization_task, AuthorizationTaskWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iQ1Hjc3CJXfF0pDtpKNKoMkOWVuCFkXQi4lJUAfp2oBhLU8oD1sY3JH7sYNpLo6C",
  render_errors: [view: AuthorizationTaskWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AuthorizationTask.PubSub,
  live_view: [signing_salt: "9LhwoXwH"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :authorization_task, AuthorizationTask.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :authorization_task, AuthorizationTask.Guardian,
  issuer: "authorization_task",
  secret_key: "mysecretkey"
