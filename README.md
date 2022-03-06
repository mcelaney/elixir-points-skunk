# Points

##  Installing Locally

First set up a [GitHub OAuth](https://github.com/settings/applications/new) with a Homepage URL (http://localhost:4000/) and a Authorization callback URL (http://localhost:4000/auth/github/callback). Generate a new client secret to add to `config/dev.secret.exs` (noted below)

Create a `config/dev.secret.exs` file with the following:

```
import Config

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "<your client ID>",
  client_secret: "<your client secret>"
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
