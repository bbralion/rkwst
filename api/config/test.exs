import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rkwst, RkwstWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "EfvavOKyNQeggrU50Fm83YbFwB9T9yZav2OfU9MPmCYqew6jdThAzM6gxyPoo5lh",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
