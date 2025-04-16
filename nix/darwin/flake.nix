{ pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pkgs.neovim
    pkgs.git
    pkgs.lazygit
    pkgs.gitleaks
    pkgs.gh
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.zoxide
    pkgs.fastfetch
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "zen-browser"
      "arc"
      "spotify"
      "obsidian"
      "iina"
      "1password"
      "flux"
      "stats"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    meslo-lgs-nf
  ];

  system.defaults = {
    trackpad.TrackpadThreeFingerDrag = true;
    dock = {
      show-recents = false;
      tilesize = 50;
      autohide = false;
      persistent-apps = [
        "/System/Applications/Messages.app"
        "/System/Applications/Facetime.app"
        "/Applications/Zen.app"
        "/Applications/Obsidian.app"
        "/Applications/Ghostty.app"
      ];
    };
  };

  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  programs.zsh.enable = true;

  system.configurationRevision = config.selfRev or config.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.sean.home = "/Users/sean";
  home-manager.backupFileExtension = "backup";
}

