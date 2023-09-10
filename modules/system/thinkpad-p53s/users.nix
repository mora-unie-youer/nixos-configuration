_:

{
  # Configuring users for Thinkpad P53s
  config = {
    users.users = {
      # mora@thinkpad-p53s
      mora = {
        isNormalUser = true;
        extraGroups = [ "adbusers" "audio" "docker" "input" "libvirtd" "lp" "scanner" "video" "wheel" ];
      };
    };
  };
}
