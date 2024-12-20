{
  modulesPath,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../sys/tty.nix
    ../sys/aliases.nix
    ../sys/nix.nix
    ../sys/cache.nix

    ../services/journald.nix
    ../services/net/nginx.nix
    ../services/net/sshd.nix
    ../services/databases/postgresql.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    fzf
    gitMinimal
    curl
    curlie
    bottom
    ncdu
    rsync
    zoxide
    bat
    tealdeer
  ];

  users.users.aleksey = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOflJf6Y/zL2RZFpYLBw10b8DsvRAWu+wnbcbJ1s00Tj ayveezub@gmail.com"
    ];

    initialHashedPassword = "$y$j9T$H52H7Xta1XhESYb2vE07C/$diE1gF.OIIOCBo6jzKATasjiKwXKhbLCEWmJd.PBZM1";
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOflJf6Y/zL2RZFpYLBw10b8DsvRAWu+wnbcbJ1s00Tj ayveezub@gmail.com"
      ];
    };
  };
  users.defaultUserShell = pkgs.fish;

  # sudo ip route add 10.0.0.1 dev ens3
  # sudo ip address add 212.57.115.202/32 dev ens3
  # sudo ip route add default via 10.0.0.1 dev ens3
  networking = {
    useDHCP = false;
    hostName = "procyon20";
    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "212.57.115.202";
            prefixLength = 32;
          }
        ];

        ipv4.routes = [
          {
            address = "10.0.0.1";
            prefixLength = 32;
          }
        ];
      };
    };

    nameservers = ["8.8.8.8" "8.8.4.4"];
    defaultGateway = "10.0.0.1";
  };

  system.stateVersion = "24.05";
  documentation.nixos.enable = false;

  # apps

  #services.nginx.virtualHosts."hello.rusty-cluster.net" = {
  #  forceSSL = true;
  #  enableACME = true;

  #  root = inputs.habits-vue.packages.x86_64-linux.default;

  #  extraConfig = ''
  #    location / {
  #      try_files $uri $uri/ /index.html;
  #    }
  #  '';
  #};
}
