{ pkgs, ... }:
{
  enable = true;                         # Enables FZF config via Home Manager
  enableZshIntegration = true;          # Adds FZF keybindings & completions to Zsh
  tmux.enableShellIntegration = true;   # Integrates FZF nicely inside Tmux sessions
}

