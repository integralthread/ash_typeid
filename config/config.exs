import Config

# temp: https://ash-hq.org/docs/guides/ash/latest/tutorials/get-started#temporary-config
config :ash, :use_all_identities_in_manage_relationship?, false

#    might need `mix deps.compile ash --force`
config :ash, :custom_types, typeid: AshTypeID.TypeID

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
