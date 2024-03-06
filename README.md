# Tailscale

A module for installing and configuring the tailscale mesh network.  Not sure what tailscale is? A wireguard based VPN service. Join multiple networks into a single mesh network and even share with your friends. 
## Table of Contents

- [Tailscale](#tailscale)
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
These are the options available for providing tailscale up flags.


```shell
USAGE
  up [flags]

"tailscale up" connects this machine to your Tailscale network,
triggering authentication if necessary.

With no flags, "tailscale up" brings the network online without
changing any settings. (That is, it's the opposite of "tailscale
down").

If flags are specified, the flags must be the complete set of desired
settings. An error is returned if any setting would be changed as a
result of an unspecified flag's default value, unless the --reset
flag is also used.

FLAGS
  --accept-dns, --accept-dns=false
    	accept DNS configuration from the admin panel (default true)
  --accept-routes, --accept-routes=false
    	accept routes advertised by other Tailscale nodes (default false)
  --advertise-exit-node, --advertise-exit-node=false
    	offer to be an exit node for internet traffic for the tailnet (default false)
  --advertise-routes string
    	routes to advertise to other nodes (comma-separated, e.g. "10.0.0.0/8,192.168.0.0/24")
  --advertise-tags string
    	comma-separated ACL tags to request; each must start with "tag:" (e.g. "tag:eng,tag:montreal,tag:ssh")
  --authkey string
    	node authorization key
  --exit-node string
    	Tailscale IP of the exit node for internet traffic
  --exit-node-allow-lan-access, --exit-node-allow-lan-access=false
    	Allow direct access to the local network when routing traffic via an exit node (default false)
  --force-reauth, --force-reauth=false
    	force reauthentication (default false)
  --host-routes, --host-routes=false
    	install host routes to other Tailscale nodes (default true)
  --hostname string
    	hostname to use instead of the one provided by the OS
  --login-server string
    	base URL of control server (default https://login.tailscale.com)
  --netfilter-mode string
    	netfilter mode (one of on, nodivert, off) (default on)
  --operator string
    	Unix username to allow to operate on tailscaled without sudo
  --reset, --reset=false
    	reset unspecified settings to their default values (default false)
  --shields-up, --shields-up=false
    	don't allow incoming connections (default false)
  --snat-subnet-routes, --snat-subnet-routes=false
    	source NAT traffic to local routes advertised with --advertise-routes (default true)
```



## Limitations

At this time this module can only install and initialize tailscale.  

## Development
Pull requests welcomed.

Click the button below to start a new development environment:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://gitlab.com/blockops/puppet-tailscale)
