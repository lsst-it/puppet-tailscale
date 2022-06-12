#!/usr/bin/env bash 
# Example ostype ubuntu_20_04

curl -fsSL https://tailscale.com/install.sh | sh

if [[ $? -ne 0 ]]; then
  echo "Using alternate installation method"
  case $PT_ostype in

    ubuntu_20_04)
      curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
      curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
      sudo apt-get update
      sudo apt-get install tailscale -y
      ;;
    *)
      echo "OS type not supported in case statement yet, submit a PR!"
      exit 1
      ;;
  esac
fi

sudo tailscale up --auth-key $PT_authkey
sudo tailscale status

