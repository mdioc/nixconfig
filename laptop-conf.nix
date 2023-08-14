{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./base.nix
    ];

  boot.zfs.devNodes = "/dev/disk/by-id/nvme-WDC_PC_SN730_SDBQNTY-256G-1001_215186449105-part3";
  fileSystems."/" =
    { device = "rpool/nixos";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/nixos/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/nixos/home";
      fsType = "zfs";
    };

  fileSystems."/home/mdo" =
    { device = "rpool/nixos/home/mdo";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8b13d197-3701-4760-9ba3-12109a3547d7";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/4AB3-D4F3";
      fsType = "vfat";
    };

  networking.hostName = "ni15a"; 
  services.zfs.autoScrub.pools = [ "rpool" ];

  system.stateVersion = "22.11";

}

