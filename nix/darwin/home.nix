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

in {
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";

  # 📎 Symlinked dotfiles

  home.file = {
  	
  #Homefiles in Nix Store (Immutable)

    ".ssh/config".source       = ../config/ssh/config;
    ".gitconfig".source        = ../config/git/gitconfig;
    ".gitignore".source        = ../config/git/gitignore;

  #Homefiles not in Nix Store (Mutable)

    ".config/starship/starship.toml".source = 
    mkOutOfStoreSymlink ../config/starship/starship-tokyonight.toml;
    ".config/ghostty/config".source = 
    mkOutOfStoreSymlink ../config/ghostty/config;
    #Lazyvim
    ".config/nvim".source = mkOutOfStoreSymlink "/Users/sean/.dotfiles/nix/config/nvim-lazyvim";

  };

  programs = {
    # 🐚 Zsh shell config (aliases, plugins, prompt, etc)
    zsh = import ../home/zsh.nix {
      inherit config pkgs promptPlugins promptInitExtra;
    };

    # 💫 Prompt manager
    starship.enable = !useP10k;

    # 🔍 Fuzzy finder
    fzf = import ../home/fzf.nix { inherit pkgs; };

    # 📂 Smarter cd
    zoxide = import ../home/zoxide.nix { inherit pkgs; };
  };
}


