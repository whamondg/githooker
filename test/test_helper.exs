ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Githooker.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Githooker.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Githooker.Repo)

