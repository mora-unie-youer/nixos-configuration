_:

{
  config = {
    # Configuring git
    programs.git = {
      enable = true;
      delta.enable = true;
    
      aliases = {
        ar  = "archive";
        bi  = "bisect";
        bl  = "blame";
        br  = "branch";
        brd = "br -d";
        ch  = "checkout";
        chb = "ch -b";
        cl  = "clone";
        co  = "commit";
        com = "co -m";
        cp  = "cherry-pick";
        df  = "diff";
        fe  = "fetch";
        ls  = "log -1";
        me  = "merge";
        no  = "notes";
        pl  = "pull";
        ps  = "push";
        psa = "'!git remote | xargs -IR git push R'";
        rb  = "rebase";
        re  = "restore";
        rs  = "reset";
        rsh = "rs --hard";
        rsk = "rs --keep";
        rsm = "rs --merge";
        rss = "rs --soft";
        rsx = "rs --mixed";
        sb  = "submodule";
        sl  = "shortlog";
        st  = "stash";
        sta = "st apply";
        std = "st drop";
        stl = "st list";
        stp = "st pop";
        ss  = "status";
        sw  = "switch";
        ur  = "update-ref";
      };

      includes = [
        {
          contents = {
            user = {
              name = "Mora Unie Youer";
              email = "mora_unie_youer@riseup.net";
              signingKey = "0x7AB91D83B25E6D7F";
            };

            commit = {
              gpgSign = true;
            };

            init = {
              defaultBranch = "master";
            };

            safe = {
              directory = "*";
            };
          };
        }
      ];
    };
  };
}