# tailscale

A module for installing and configuring the tailscale mesh network.  Not sure what tail is? A wireguard based VPN service.
Join multiple networks into a single mesh network and even share with your friends. 
## Table of Contents

- [tailscale](#tailscale)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [What tailscale affects](#what-tailscale-affects)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with tailscale](#beginning-with-tailscale)
  - [Usage](#usage)
    - [Without hiera example](#without-hiera-example)
    - [With hiera example](#with-hiera-example)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)

## Description

A very basic module for setting up tailscale on debian and redhat systems. 

Requires a authkey for automated setup.  Essentially performs the installation 
[instructions](https://tailscale.com/download/linux) provided on their website.

## Setup

### What tailscale affects 

* Installs tailscale package
* Installs systemd tailscale service
* Runs the tailscale up command with provided [authkey](https://tailscale.com/kb/1085/auth-keys?q=authkey)

Joins your system to a mesh network.  Provide the wrong authkey and you might be joining to somebody else's network.
### Setup Requirements 

You will need an [authkey](https://tailscale.com/kb/1085/auth-keys?q=authkey) and access to the internet.
### Beginning with tailscale
In order to join the tailscale network you need the authkey.  This key should be treated as sensitive data as anybody with the key can gain access to your network.  We recommend using hiera-eyaml to encrypt the key.  To take extra precautions when using a puppetserver you should also set the tailscale::use_node_encrypt parameter to true.  

## Usage

### Without hiera example

`class{'tailscale': auth_key => '123456' } `

### With hiera example

`include tailscale`

```
# data/common.yaml
tailscale::auth_key: 123456
tailscale::base_pgk_url: 'https://mydomain/packages/centos'

# example only, options are not required
tailscale::up_options:
  hostname: "%{::facts.hostname}"
```
## Reference
These are the options availabe for providing tailscale up flags.


```shell
USAGE
  up [flags]

"tailscale up" connects this machine to your Tailscale network,
triggering authentication if necessary.

The flags passed to this command are specific to this machine. If you don't
specify any flags, options are reset to their default.

FLAGS
  -accept-dns true                           accept DNS configuration from the admin panel
  -accept-routes false                       accept routes advertised by other Tailscale nodes
  -advertise-routes ...                      routes to advertise to other nodes (comma-separated, e.g. 10.0.0.0/8,192.168.0.0/24)
  -advertise-tags ...                        ACL tags to request (comma-separated, e.g. eng,montreal,ssh)
  -authkey ...                               node authorization key
  -force-reauth false                        force reauthentication
  -host-routes true                          install host routes to other Tailscale nodes
  -hostname ...                              hostname to use instead of the one provided by the OS
  -login-server https://login.tailscale.com  base URL of control server
  -netfilter-mode on                         netfilter mode (one of on, nodivert, off)
  -shields-up false                          don't allow incoming connections
  -snat-subnet-routes true                   source NAT traffic to local routes advertised with --advertise-routes
```



## Limitations

At this time this module can only install and initialize tailscale.  

## Development
Pull requests welcomed.