# Olex2 launcher for Linux

An experimental Olex2 launcher for modern Linux distributions. It provides drop-in `olex2` and `unirun` binaries compiled with newer wxGTK.

### Before using

1. Make sure you have [Nix](https://nixos.org) installed, with experimental features `flakes` and `nix-command` enabled.
2. [Download](https://www.olexsys.org/olex2/docs/getting-started/installing-olex2/#linux) the official Linux release and extract it to your home directory. The launcher looks for `~/olex2/start` to start the application.

### Usage

```shell
$ nix run 'github:SamLukeYes/olex2-flake#olex2-launcher'
```

You can also install it permanently with NixOS modules or [Home Manager](https://github.com/nix-community/home-manager/).
