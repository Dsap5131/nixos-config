{ config, lib, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.username = "dsapienza";
  home.homeDirectory = "/home/dsapienza";
  home.stateVersion = "26.05";

  # Neovim/tmux binaries only - config lives in your dotfiles repo, symlinked below.
  # LSP servers / formatters can go here too, or via mason.nvim.
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    fd
    # pyright ruff clang-tools	# uncomment the language servers you use
  ];

  # Clone (or update) your portable dotfiles repo before linking into it, so a
  # fresh machine deploys itself on the first `nixos-rebuild switch`.
  home.activation.cloneDotfiles = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ ! -d "${dotfilesDir}/.git" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --recurse-submodules \
        https://github.com/Dsap5131/.dotfiles.git "${dotfilesDir}"
    else
      $DRY_RUN_CMD ${pkgs.git}/bin/git -C "${dotfilesDir}" submodule update --init --recursive
    fi
  '';

  # oh-my-zsh itself is a plain clone (not home-manager's programs.zsh.oh-my-zsh
  # module), since that module generates its own ~/.zshrc and would fight with
  # the one your dotfiles already own.
  home.activation.installOhMyZsh = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ ! -d "${config.home.homeDirectory}/.oh-my-zsh" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/ohmyzsh/ohmyzsh.git \
        "${config.home.homeDirectory}/.oh-my-zsh"
    fi
  '';

  # Live, out-of-store symlinks into the dotfiles checkout above: editing a
  # file there (on this machine or any other) takes effect immediately, no
  # rebuild needed.
  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.zshrc";
    ".config/i3".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/i3";
    ".config/i3status".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/i3status";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/tmux";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/nvim";
  };

  programs.git = {
    enable = true;
    userName = "Dylan Sapienza";
    userEmail = "loldsap5131@gmail.com";
  };

  # i3 config can be managed here (xsession.windowManager.i3) or as dotfiles.
  # Left minimal for the first install; expand once the system boots.
}
