# Getting Started

The first step is to decide if you're building a phoenix application or not. Phoenix is an extremely high quality web framework, and is the suggested pairing with Ash if you expect to be building a front end, or an API. For this guide, we assume that elixir has already been installed.

## Installing Phoenix

First, install the phoenix installation archive.

```bash
mix archive.install hex phx_new
```

Then, create a new phx application. Generally, we suggest installing liveview as well, via the `--live` flag. See the phoenix [Phoenix Documentation](https://www.phoenixframework.org/) fore more information.

```bash
mix phx.new <my_app> --live
```

## Adding Ash

1. First off, add Ash as a dependency. In `mix.exs`, add
`{:ash, "~> 1.52.0-rc.0"}` to your dependencies.

2. Next, add an API. To start, a simple choice for naming your first API is a good name for the "core" of your application. For example, a help-desk application called "AwesomeDesk" might start with an API module called `AwesomeDesk.Tickets`. Create `lib/my_app/my_api/my_api.ex`, with the following contents:

    ```elixir
    defmodule MyApp.MyApi do
      use Ash.Api, otp_app: :my_app
    end
    ```

3. Add a Registry. A registry is where you list the resources that a given Api has access to. Create `lib/my_app/my_api/registry.ex` with the following contents:

    ```elixir
    defmodule MyApp.MyApi.Registry do
      use Ash.Registry,
        extensions: [Ash.Registry.ResourceValidations]

      entries do
        # We will list our resources here
      end
    end
    ```

4. Configure your application. Add the following to `config/config.exs`.

    ```elixir
    # Configure the list of APIs in your application.
    config :my_app, ash_apis: [
      MyApp.MyApi
    ] 

    # Configure the registry to be used for your first API
    # Storing this in configuration instead of the API improves
    # compile times.
    config :my_app, MyApp.MyApi,
      resources: [
        registry: MyAPp.MyApi.Registry
      ]
    ```

5. Define your first resource. Each resource should go in a folder inside of the `resources` folder in your API folder. For example, you might add `lib/my_app/my_api/resources/ticket.ex`. To start, create your resource with the following contents:

    ```elixir
    defmodule MyApp.MyApi.ResourceName do
      use Ash.Resource

      attributes do
        # We generally recommend using UUIDs, but you can
        # also use `integer_primary_key :id`, or simply define
        # your own with:
        #
        # `attribute :name, :type, primary_key?: true`
        uuid_primary_key :id

        # Add the attributes of your resource. For example,
        # A "User" might have a `username` and an `email` attribute,
        # or a "BlogPost" might have a `body` attribute
        attribute :name, :string
      end
    end
    ```

6. Add your resource to the registry that you created

    ```elixir

    entries do
      entry MyApp.MyApi.ResourceName
    end
    ```

7. Add

8. Try it out. Currently, your resource won't do much. You can "create", "read", and manipulate it, but it won't be saved anywhere. For example:

    ```elixir
    
    ```