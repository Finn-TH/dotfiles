{
  description = "Arrakis - Finn's macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }: let
    system = "aarch64-darwin";
  in {
    darwinConfigurations."arrakis" = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [

        # 🧠 Core macOS system config
        {
          nixpkgs = {
            config.allowUnfree = true;
            hostPlatform = system;
          };

          environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
            neovim
            git
            lazygit
            gitleaks
            gh
            fzf
            ripgrep
            fd 
            zoxide 
            fastfetch
            aerospace
          ];

          users.users.sean = {
              name = "sean";
              home = "/Users/sean/";
            };

          fonts.packages = with nixpkgs.legacyPackages.${system}; [
            nerd-fonts.jetbrains-mono
            meslo-lgs-nf
          ];

          system.defaults = {
            NSGlobalDomain.KeyRepeat = 2;
            trackpad.TrackpadThreeFingerDrag = true;
            dock = {
              orientation = "left";
              show-recents = false;
              tilesize = 50;
              autohide = true;
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

          home-manager.backupFileExtension = "backup";

          system = {
            stateVersion = 6;
            configurationRevision = self.rev or self.dirtyRev or null;
          };
        }

        # 🍺 Homebrew module + config
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "sean";
            autoMigrate = true;
          };

          homebrew = {
            enable = true;
            casks = [
              "ghostty" "zen-browser" "arc" "spotify"
              "obsidian" "iina" "1password" "flux"
              "stats" "chatgpt" "transmission" "iina" "appcleaner"
            ];
            onActivation = {
              cleanup = "zap";
              autoUpdate = true;
              upgrade = true;
            };
          };
        }

        # 🏠 Home Manager integration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sean = import ./home.nix;
        }
      ];
    };
  };
}
