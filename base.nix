{ config, pkgs, lib, ... }:

{
  imports =
    [ ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/home/mdo/horizon" =
    { device = "192.168.1.55:/nfs/horizon";
      fsType = "nfs";
      options = ["noauto"];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # Use the systemd-boot EFI boot loader.
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"
  '';
    
  virtualisation.libvirtd.enable = true;
 
  time.timeZone = "EST5EDT";
  
  networking.hostId = "854260d3";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.layout = "us";
  services.flatpak.enable = true;
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {    
    enable = true;    
    alsa.enable = true;    
    alsa.support32Bit = true;    
    pulse.enable = true;    
    jack.enable = true;    
  };
  
  users.users.mdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "docker"];
    shell = pkgs.zsh;
  };
 
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }; 
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];
  
  programs.zsh.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wofi
      waybar
      font-awesome
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      brightnessctl
      pamixer
    ];
  };

  environment.systemPackages = with pkgs; [
    wget 
    vim 
    htop 
    git
    firefox
    vscode
    flatpak
    ark
    docker
    docker-compose
    networkmanagerapplet
    pulseaudio
  ];

  system.stateVersion = "22.11";

}

