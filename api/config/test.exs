import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rkwst, RkwstWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bRgbc89OT3QYT5/JQM3hfLHgqfDjav3h9usw7RFqLcDE9N7qf1w+Pc9mXeLde4lN",
  server: false

# In test we don't send emails.
config :rkwst, Rkwst.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
