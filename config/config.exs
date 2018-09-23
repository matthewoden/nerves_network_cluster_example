# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, 
  rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

config :libcluster,
  topologies: [
    gossip_example: [
      strategy: Elixir.Cluster.Strategy.Gossip,
      config: [
        port: 45892,
        if_addr: "0.0.0.0",
        multicast_addr: "230.1.1.251",
        multicast_ttl: 1,
      ]
    ]
  ]

if System.get_env("MIX_TARGET") != "host" do
  
  config :nerves_network,
    regulatory_domain: "US"

  config :nerves_firmware_ssh,
    authorized_keys: [
      File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))
    ]

  config :nerves_init_gadget,
    ifname: "wlan0",
    address_method: :dhcp,
    mdns_domain: :hostname,
    node_name: "mypi",
    node_host: :mdns_domain,
    ssh_console_port: 22

  key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

  config :nerves_network, :default,
    wlan0: [
      ssid: System.get_env("NERVES_NETWORK_SSID"),
      psk: System.get_env("NERVES_NETWORK_PSK"),
      key_mgmt: String.to_atom(key_mgmt)
    ]
end


# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
