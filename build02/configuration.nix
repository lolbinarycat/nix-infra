{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./nixpkgs-update.nix

    ../roles/common.nix
    ../roles/hetzner-network.nix
    ../roles/nginx.nix
    ../roles/nix-community-cache.nix
  ];

  # /boot is a mirror raid
  boot.loader.grub.devices = [ "/dev/nvme0n1" "/dev/nvme1n1" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.extraConfig = ''
    # for mdraid 1.1
    insmod mdraid1x
  '';

  networking.hostName = "nix-community-build02";
  networking.hostId = "af9ccc71";
  networking.useDHCP = false;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.nix-community.ipv6.address = "2a01:4f9:4a:2b02::1";

  system.stateVersion = "20.09";
}
