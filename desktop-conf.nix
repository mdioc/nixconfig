# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ./base.nix
    ];

  fileSystems."/" =
    { device = "rpool/nixos";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/nixos/nix";
      fsType = "zfs";
    };

  fileSystems."/home/mdo" =
    { device = "hpool/home/nixos";
      fsType = "zfs";
    };

  fileSystems."/home/oldmdo" =
    { device = "hpool/mdo";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36627617-1ec7-4f85-a5be-04a426ed1857";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/4385-3B79";
      fsType = "vfat";
    };

  fileSystems."/home/mdo/horizon" =
    { device = "192.168.1.55:/nfs/horizon";
      fsType = "nfs";
      options = [ "noauto" ];
    };

  networking.hostName = "ni12a"; 
  services.zfs.autoScrub.pools = [ "rpool" "hpool" ];
}
