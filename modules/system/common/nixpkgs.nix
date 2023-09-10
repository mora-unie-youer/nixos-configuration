_:

{
  # Configuring Nixpkgs
  config = {
    nixpkgs.config = {
      # Allowing unfree software, as I don't care :P
      allowUnfree = true;
    };
  };
}
