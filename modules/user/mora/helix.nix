{ pkgs, helix, ... }:

{
  config = {
    home = {
      packages = with pkgs; [ lldb ];

      sessionVariables = {
        EDITOR = "hx";
        GIT_EDITOR = "hx";
      };
    };

    programs.helix = {
      enable = true;
      package = helix.packages.${pkgs.system}.default;

      languages = {
        language-server = {
          bash-language-server = with pkgs.nodePackages; {
            command = "${bash-language-server}/bin/bash-language-server";
            args = [ "start" ];
          };

          clangd = with pkgs; {
            # Use CCLS instead
            command = "${ccls}/bin/ccls";
          };

          # emmet-ls = with inputs.nixpkgs-emmet-ls.legacyPackages.${pkgs.system}.nodePackages; {
          #   command = "${emmet-ls}/bin/emmet-ls";
          #   args = [ "--stdio" ];
          # };

          gopls = with pkgs; {
            command = "${gopls}/bin/gopls";
          };

          # intelephense = with pkgs.nodePackages; {
          #   command = "${intelephense}/bin/intelephense";
          #   args = [ "--stdio" ];
          # };

          jdtls = with pkgs; {
            # command = "${java-language-server}/bin/java-language-server";
            # command = "${jdt-language-server}/bin/jdt-language-server";
            command = "/home/mora/jdtls/jdtls";
            # args = [ "-data" "." ];

            config = {
              format.enabled = true;
              inlayHints.parameterNames = true;
            };
          };

          lua-language-server = with pkgs; {
            command = "${sumneko-lua-language-server}/bin/lua-language-server";
          };

          nil = with pkgs; {
            command = "${nil}/bin/nil";
          };

          ocamllsp = with pkgs.ocamlPackages; {
            command = "${ocaml-lsp}/bin/ocamllsp";
          };

          # phpactor = with pkgs; {
          #   command = "${phpactor}/bin/phpactor";
          #   args = [ "language-server" ];
          # };

          pylsp = with pkgs.python3Packages; {
            command = "${python-lsp-server}/bin/pylsp";
          };

          solc = with pkgs; {
            command = "${solc}/bin/solc";
            args = [ "--lsp" ];
          };

          typescript-language-server = with pkgs.nodePackages; {
            command = "${typescript-language-server}/bin/typescript-language-server";
            args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];
          };

          zls = with pkgs; {
            command = "${zls}/bin/zls";
          };
        };

        language = let
          debugger = {
            # codelldb = with pkgs.vscode-extensions.vadimcn; {
            # codelldb = with inputs.nixpkgs-congee.packages.${pkgs.system}.vscode-extensions.vadimcn; {
            #   command = "${vscode-lldb}/${vscode-lldb.installPrefix}/adapter/codelldb";
            #   name = "codelldb";
            #   port-arg = "--port {}";
            #   transport = "tcp";

            #   templates = {
            #     name = "binary";
            #     request = "launch";

            #     args = {
            #       program = "{0}";
            #       runInTerminal = true;
            #     };

            #     completion = {
            #       completion = "filename";
            #       name = "binary";
            #     };
            #   };
            # };
          };
        in [
        # {
        #   name = "c";
        #   debugger = debugger.codelldb;
        # } {
        #   name = "cpp";
        #   debugger = debugger.codelldb;
        # }
        {
          name = "html";
          language-servers = [ "emmet-ls" ];
        }
        {
          name = "java";
          auto-format = true;
        }
        {
          name = "php";
          language-servers = [ "intelephense" "phpactor" ];
        }
        {
          name = "klipper";
          scope = "source.cfg";
          roots = [ "main.cfg" ];
          injection-regex = "cfg";
          file-types = [ "cfg" ];
          comment-token = "#";
          indent = { tab-width = 2; unit = "  "; };
        }
        # {
        #   name = "rust";
        #   debugger = debugger.codelldb;
        # } {
        #   name = "zig";
        #   debugger = debugger.codelldb;
        # }
        ];

        grammar = [{
          name = "klipper";
          source = { path = "/prog/tree-sitter-klipper"; };
        }];
      };

      settings = {
        theme = "catppuccin_mocha";

        editor = {
          bufferline = "multiple";
          line-number = "relative";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides = {
            render = true;
          };

          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };

          statusline = {
            mode.insert = "INSERT";
            mode.normal = "NORMAL";
            mode.select = "SELECT";
          };
        };
      
        keys.insert = {
          A-8 = "normal_mode";
        };
      };
    };
  };
}
