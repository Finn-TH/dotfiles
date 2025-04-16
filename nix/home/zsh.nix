# nix/home/zsh.nix

{ config, pkgs, promptPlugins ? [], promptInitExtra ? "", ... }:

{
  enable = true;

  shellAliases = {
    ls = "ls --color";
    ll = "ls -lah";
    la = "ls -a";
    vim = "nvim";
    cl = "clear";
    gst = "git status";
  };

  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
      file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "zsh-completions";
      src = pkgs.zsh-completions;
      file = "share/zsh-completions/zsh-completions.zsh";
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
  ] ++ promptPlugins;

  initExtra = ''
    [[ -f ${../config/zsh-extra.zsh} ]] && source ${../config/zsh-extra.zsh}
  '' + "\n" + promptInitExtra;
}

