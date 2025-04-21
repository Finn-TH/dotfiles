{
  description = "Finn's full Nix system configuration (macOS + future platforms)";

  inputs = {
    nix-darwin.url = "path:./darwin";
  };

  outputs = { self, nix-darwin, ... }: {
    darwinConfigurations = nix-darwin.darwinConfigurations;
  };
}
