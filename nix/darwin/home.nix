# nix/darwin/home.nix
{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  # 💡 Toggle prompt system: true = Powerlevel10k, false = Starship
  useP10k = true;

  promptPlugins = if useP10k then [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ] else [];

  promptInitExtra = if useP10k then ''
  [[ -f ${../home/.p10k.zsh} ]] && source ${../home/.p10k.zsh}
'' else ''
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
'';


in
{
  programs.home-manager.enable = true;

  home = {
    username = "sean";
    homeDirectory = "/Users/sean";
    stateVersion = "23.11";
  };

  xdg = {
    enable = true;
    configFile."ghostty/config".source =
      mkOutOfStoreSymlink ../config/ghostty/config;
  };

  #Homefiles Symlinked

  home.file.".config/starship/starship.toml".source =
    mkOutOfStoreSymlink ../config/starship/starship-tokyonight.toml;

  home.file.".ssh/config".source = ../config/ssh/config;
  home.file.".gitconfig".source = ../config/git/gitconfig;
  home.file.".gitignore".source = ../config/git/gitignore;


  programs = {
    # 🐚 Zsh shell config with plugins, aliases, prompt, etc
    zsh = import ../home/zsh.nix {
      inherit config pkgs promptPlugins promptInitExtra;
    };

    # Enable starship package if used (optional runtime toggle)
    starship.enable = !useP10k;

    # 🔍 Fuzzy finder (fzf)
    fzf = import ../home/fzf.nix { inherit pkgs; };


    # 📂 Smarter cd with zoxide
    zoxide = import ../home/zoxide.nix { inherit pkgs; };
  };
}

