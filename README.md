# nix-flux-local

A Nix flake packaging [flux-local](https://github.com/allenporter/flux-local) — a set of tools and libraries for managing a local Flux GitOps repository.

## Usage

### NixOS system configuration

Add the flake as an input, inject the package into `pkgs` via an overlay, then reference it as `pkgs.flux-local` anywhere in your modules:

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
          nixpkgs.overlays = [
            (final: prev: {
              flux-local = nix-flux-local.packages.${final.system}.flux-local;
            })
          ];
          environment.systemPackages = [ pkgs.flux-local ];
        }
      ];
    };
  };
}
```

With the overlay in place, `pkgs.flux-local` is available in any NixOS or Home Manager module without needing to pass the flake input through `specialArgs`.

### Home Manager

Add the flake as an input, inject the package via an overlay, then reference it as `pkgs.flux-local` in your Home Manager modules:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-flux-local.url = "github:Jaeensson/nix-flux-local";
  };

  outputs = { nixpkgs, home-manager, nix-flux-local, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          flux-local = nix-flux-local.packages.${system}.flux-local;
        })
      ];
    };
  in {
    homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          home.packages = [ pkgs.flux-local ];
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
