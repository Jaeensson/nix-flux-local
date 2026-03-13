# nix-flux-local

A Nix flake packaging [flux-local](https://github.com/allenporter/flux-local) — a set of tools and libraries for managing a local Flux GitOps repository.

## Usage

### NixOS system configuration

Add the flake as an input and include the package in `environment.systemPackages`:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flux-local.url = "github:Jaeensson/nix-flux-local";
  };

  outputs = { nixpkgs, nix-flux-local, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = [
            nix-flux-local.packages.x86_64-linux.flux-local
          ];
        }
      ];
    };
  };
}
```

### Home Manager

Add the flake as an input and include the package in `home.packages`:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-flux-local.url = "github:Jaeensson/nix-flux-local";
  };

  outputs = { nixpkgs, home-manager, nix-flux-local, ... }: {
    homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home.packages = [
            nix-flux-local.packages.x86_64-linux.flux-local
          ];
        }
      ];
    };
  };
}
```

### One-off use

Run or enter a shell without adding it to any configuration:

```sh
# Run directly
nix run github:Jaeensson/nix-flux-local -- --help

# Temporary shell
nix shell github:Jaeensson/nix-flux-local
```

## Keeping up to date

A GitHub Actions workflow runs every Monday and automatically opens a pull request when a new upstream version of `flux-local` is released. Merge the PR to update the package.
