# Chrome Progressive Web App support in NixOS

Experimental support for Chrome PWA apps in NixOS. The chrome progressive web apps cannot be used within NixOS due to hardcoded paths in the .desktop file, so the files are beeing automatically edited to use relative paths.

## Installation

### NixOS module

You can add the module to your system in various ways. After the installation
you'll have to manually enable the service for each user (see below).

#### Install as a tarball

```nix
{
  imports = [
    (fetchTarball "https://github.com/Luis-Hebendanz/nixos-chrome-pwa/tarball/master")
  ];

  services.chrome-pwa.enable = true;
}
```

#### Install as a flake

```nix
{
  inputs.chrome-pwa.url = "github:luis-hebendanz/nixos-chrome-pwa";

  outputs = { self, nixpkgs, chrome-pwa }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        chrome-pwa.nixosModule
        ({ config, pkgs, ... }: {
          services.chrome-pwa.enable = true;
        })
      ];
    };
  };
}
```

#### Enable the service

And then enable them for the relevant users:

```
systemctl --user enable auto-fix-chrome-pwa.service
```

You will see the following message:

```
The unit files have no installation config (WantedBy=, RequiredBy=, Also=,
Alias= settings in the [Install] section, and DefaultInstance= for template
units). This means they are not meant to be enabled using systemctl.

Possible reasons for having this kind of units are:
• A unit may be statically enabled by being symlinked from another unit's
  .wants/ or .requires/ directory.
• A unit's purpose may be to act as a helper for some other unit which has
  a requirement dependency on it.
• A unit may be started when needed via activation (socket, path, timer,
  D-Bus, udev, scripted systemctl call, ...).
• In case of template units, the unit is meant to be enabled with some
  instance name specified.
```

However you can safely ignore it. The service will start automatically after reboot once enabled, or you can just start it immediately yourself with:

```
systemctl --user start auto-fix-chrome-pwa.service
```

### Home Manager

Put this code into your [home-manager](https://github.com/nix-community/home-manager) configuration i.e. in `~/.config/nixpkgs/home.nix`:

```nix
{
  imports = [
    "${fetchTarball "https://github.com/Luis-Hebendanz/nixos-chrome-pwa/tarball/master"}/modules/chrome-pwa/home.nix"
  ];

  services.chrome-pwa.enable = true;
}
```

## Usage

When the service is enabled and running it should simply work, there is nothing for you to do.
