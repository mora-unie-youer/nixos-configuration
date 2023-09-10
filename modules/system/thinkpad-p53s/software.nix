{ pkgs, ... }:

{
  config = {
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
    };
  };
}
