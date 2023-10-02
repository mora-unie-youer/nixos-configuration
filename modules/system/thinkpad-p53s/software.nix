{ pkgs, ... }:

{
  config = {
    # Configuring some networking
    networking = {
      firewall = {
        allowedTCPPorts = [ 8222 ];
      };
    };

    # Enabling some services requried for my life
    services = {
      ## Databases
      # Enabling MySQL
      mysql = {
        enable = true;
        package = pkgs.mariadb;

        ensureDatabases = [ "mora" ];
        ensureUsers = [{
          name = "mora";
          ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
        }];
      };

      # Enabling PostgreSQL
      postgresql = {
        enable = true;
        enableJIT = true;

        ensureDatabases = [ "mora" ];
        ensureUsers = [{
          name = "mora";
          ensureClauses = { superuser = true; };
        }];
      };

      # Enabling vaultwarden service
      vaultwarden = {
        enable = true;
        backupDir = "/data/.vault-backup";
        environmentFile = "/var/lib/bitwarden_rs/env";

        config = {
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = "8222";
        };
      };
    };

    # Configuring virtualization software
    virtualisation = {
      # Configuring Docker
      docker = {
        enable = true;
        storageDriver = "overlay2";

        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      # Configuring libvirtd
      libvirtd.enable = true;
    };
  };
}
