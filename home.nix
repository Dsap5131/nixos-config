{ config, pkgs, ... }:

{
  home.username = "dsapienza";
  home.homeDirectory = "/home/dsapienza";
  home.stateVersion = "26.05";

  # Neovim binary only - config lives in your dotfiles repo (init.lua etc.).
  # LSP servers / formatters can go here too, or via mason.nvim.
  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    # pyright ruff clang-tools	# uncomment the language servers you use
  ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    # add your own tmux settings here, or manage via dotfiles
  };

  programs.git = {
    enable = true;
    userName = "Dylan Sapienza";
    userEmail = "loldsap5131@gmail.com";
  };

  # i3 config can be managed here (xsession.windowManager.i3) or as dotfiles.
  # Left minimal for the first install; expand once the system boots.
}
