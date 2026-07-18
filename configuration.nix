{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # --- Boot (UEFI) ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.hostName = "fw16";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # --- Locale / time (adjust to yours) ---
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Graphics: AMD iGPU neneds no special driver. Leave videoDrivers unset.
  #     When you add the NVIDIA dGPU module later, uncomment:
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.open = true;  # confirm against nixos-hardware wiki for your dGPU

  # --- X11 + i3 tiling window manager ---
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # --- Power management (recommended over tlp for the AMD Framework) ---
  services.power-profiles-daemon.enable = true;

  # --- Audio (PipeWire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # --- Shell: zsh is the login shell your dotfiles' .zshrc/oh-my-zsh expect ---
  programs.zsh.enable = true;

  # --- Your user ---
  users.users.dsapienza = {
    isNormalUser = true;
    description = "Dylan Sapienza";
    extraGroups = [ "wheel" "networkmanager" "video"];
    shell = pkgs.zsh;
  };

  # --- System-wide packages (the glue an i3 desktop needs on first boot) ---
  environment.systemPackages = with pkgs; [
    git
    kitty	# terminal emulator
    rofi	# launcher
    i3status	# status bar
    dmenu
    dunst	# notifications
    firefox
    vim
    slack
    lazygit
    brightnessctl
    obsidian
    nodejs
  ];

  # other programs
  services.tailscale.enable = true;
    fileSystems."/home/dsapienza/drive" = {
      device = "192.168.32.167:/volume1/homes";
      fsType = "nfs";
      options = [
        "nofail"
        "soft"
        "timeo=100"
        "retrans=3"
        "vers=3"
        "x-systemd.mount-timeout=10"
      ];
    };

  services.blueman.enable = true;

  # Enable flakes permanently on the installed system.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # Set to your install's release number and NEVER chnage it afterward.
  system.stateVersion = "26.05";

}

