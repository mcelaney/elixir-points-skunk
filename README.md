# Points

[Points](https://github.com/fastruby/points) is a Ruby app by [FastRuby.io](https://www.fastruby.io/) -- this is not Points.  This is an Elixir Skunk rebuild of points.

Fair warning - this is [Irresponsible Elixir](https://youtu.be/caYY6vdXEeo?list=PLE7tQUdRKcyb03P3xsIBPGoPycg03fEJ1&t=286) - no docs, unit tests, or commit history done for fun and learning on my part. **This is not functional** and I don't necessarily stand by any of the code I wrote here. Please check out [Points](https://github.com/fastruby/points) instead.

## Why did I do this? 

After seeing the [LiveBeats](https://github.com/fly-apps/live_beats) example I wanted to take a Ruby/JS project I didn't know very well and see how far I could get through a rebuild in the PETAL stack in around a day. This is the result.

I'd call the experiment successful in that I see this as my default approach for grefield apps going forward. The level of cohesion this brings to a project makes it a no-brainer.

# Installing Anyway

On the off chance you wanna play with this:

### Configure

First set up a [GitHub OAuth](https://github.com/settings/applications/new) with a Homepage URL (http://localhost:4000/) and a Authorization callback URL (http://localhost:4000/auth/github/callback). Generate a new client secret to add to `config/dev.secret.exs` (noted below)

Create a `config/dev.secret.exs` file with the following:

```
import Config

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "<your client ID>",
  client_secret: "<your client secret>"
```

### Setup Phoenix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`

### Run the app

Run tests with `mix test`

Run credo with `mix test` (this will fail because I was mid-effort when the timer went off)

Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
