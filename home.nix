{ config, pkgs, ... }: 
{
  home.username = "mdo";
  home.homeDirectory = "/home/mdo";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      ga = "git add .";
      gcm = "git commit -am";
      recon = "sudo nixos-rebuild switch --flake /home/mdo/nixconfig";
    };
    initExtra = ''
      source ~/.config/p10k/.p10k.zsh
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    neofetch
    cargo
    rustc
    rust-analyzer
    gcc
    (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
  ];
  xdg.configFile."hypr".source = ./config/hypr;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."sway".source = ./config/sway;
  xdg.configFile."alacritty".source = ./config/alacritty;
  xdg.configFile."p10k".source = ./config/p10k;
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = { 
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
