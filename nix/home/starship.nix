# nix/home/starship.nix

{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/starship/starship.toml".source =
    ../config/starship/starship-tokyonight.toml;

  # Return an initExtra string fragment to append from zsh.nix
  extraInit = ''
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  '';
}

