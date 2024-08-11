# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :twitterclone,
  ecto_repos: [Twitterclone.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :twitterclone, Twitterclone.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :twitterclone_web,
  ecto_repos: [Twitterclone.Repo],
  generators: [context_app: :twitterclone]

# Configures the endpoint
config :twitterclone_web, TwittercloneWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TwittercloneWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Twitterclone.PubSub,
  live_view: [signing_salt: "mNQIxztz"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/twitterclone_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :twitterclone_web, TwittercloneWeb.Guardian,
  issuer: "twitterclone_web",
  secret_key: "lZKl6KBsDwhY+5YkBMCipCpMtIFk4n3JUx71WvOVj68yxUUCvW7Iq75wKsH9ktK7"

config :twitterclone_web, TwittercloneWeb.Gettext,
  locales: ~w(en nl), # ja stands for Japanese.
  default_locale: "en"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :tailwind, version: "3.2.1", default: [
  args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
  cd: Path.expand("../apps/twitterclone_web/assets", __DIR__)
]

config :elixir_auth_google,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  google_scope: "email profile"

#import_config "dev.secret.exs"
