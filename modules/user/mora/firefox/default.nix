{ pkgs, firefox, ... }:

let
  buildXpi = { pname, version, url, sha256, addonId, meta ? {} }:
    pkgs.callPackage ({ stdenv, fetchurl, ... }:
      stdenv.mkDerivation {
        name = "${pname}-${version}";
        inherit meta;
        src = if builtins.isPath url then url else fetchurl { inherit url sha256; };

        preferLocalBuilds = true;
        allowSubstitutes = true;

        buildCommand = ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
        '';
      }
    ) {};

  tst-unload = buildXpi {
    pname = "tst-unload";
    version = "1.0.0";
    url = ./tst-unload.xpi;
    sha256 = pkgs.lib.fakeSha256;
    addonId = "tst-unload@mora.unie.youer";
  };

  tst-more-tree-commands = buildXpi {
    pname = "tst-more-tree-commands";
    version = "1.5";
    url = "https://addons.mozilla.org/firefox/downloads/file/4001424/tst_more_tree_commands-1.5.xpi";
    sha256 = "EUlra3pGMkFgKALLXFs6+BECtk+3XExc9tglIVhq4CM=";
    addonId = "tst-more-tree-commands@piro.sakura.ne.jp";
    meta = with pkgs.lib; {
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
in
{
  programs.firefox = {
    enable = true;
    package = firefox.packages.${pkgs.system}.firefox-nightly-bin;

    profiles = {
      mora = {
        id = 0;
        name = "Mora Unie Youer";

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          clearurls
          decentraleyes
          multi-account-containers
          sponsorblock
          stylus
          temporary-containers
          tree-style-tab
          tst-more-tree-commands
          tst-tab-search
          tst-unload
          ublock-origin
        ];

        search = {
          force = true;
          default = "Searx";
          engines = {
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;

            "Google" = {
              definedAliases = [ "@g" "@google" ];
            };

            "GPTGO" = {
              urls = [{
                template = "https://www.gptgo.ai/";
                rels = [ "results" ];
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];
              iconUpdateURL = "https://gptgo.ai/assets/img/favicon.ico";
              definedAliases = [ "@gg" "@gpt" "@gptgo" ];
            };

            "Phind" = {
              urls = [{
                template = "https://www.phind.com/search";
                rels = [ "results" ];
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];
              iconUpdateURL = "https://www.phind.com/favicon.ico";
              definedAliases = [ "@p" "@ph" "@phind" ];
            };

            # "Nix Packages" = {
            #   urls = [{
            #     template = "https://search.nixos.org/packages";
            #     rels = [ "results" ];
            #     params = [
            #       { name = "type"; value = "packages"; }
            #       { name = "query"; value = "{searchTerms}"; }
            #     ];
            #   }];
            #   icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            #   definedAliases = [ "@np" ];
            # };

            # "NixOS Wiki" = {
            #   urls = [{
            #     template = "https://nixos.wiki/index.php";
            #     rels = [ "results" ];
            #     params = [{ name = "search"; value = "{searchTerms}"; }];
            #   } {
            #     template = "https://nixos.wiki/api.php";
            #     type = "application/x-suggestions+json";
            #     rels = [ "suggestions" ];
            #     params = [
            #       { name = "action"; value = "opensearch"; }
            #       { name = "namespace"; value = "0"; }
            #       { name = "search"; value = "{searchTerms}"; }
            #     ];
            #   }];
            #   iconUpdateURL = "https://nixos.wiki/favicon.ico";
            #   definedAliases = [ "@nw" ];
            # };

            "Rust STD" = {
              urls = [{
                template = "https://doc.rust-lang.org/stable/std/";
                rels = [ "results" ];
                params = [{ name = "search"; value = "{searchTerms}"; }];
              }];
              iconUpdateURL = "https://doc.rust-lang.org/favicon.ico";
              definedAliases = [ "@rs" ];
            };

            "Searx" = {
              urls = [{
                template = "https://searx.be/search";
                rels = [ "results" ];
                params = [{ name = "q"; value = "{searchTerms}"; }];
              } {
                template = "https://searx.be/autocompleter";
                type = "application/x-suggestions+json";
                rels = [ "suggestions" ];
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];
              iconUpdateURL = "https://searx.be/favicon.ico";
              definedAliases = [ "@sx" ];
            };
          };
        };

        userChrome = ''
          #TabsToolbar { display: none; }
          #titlebar { display: none; }

          #sidebar-header { display: none; }
          .sidebar-splitter { width: 2px !important; }
        '';
      };
    };
  };
}
