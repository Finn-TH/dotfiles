{ pkgs, ... }:
{
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];  # makes `cd` act like `z` 👍
}

