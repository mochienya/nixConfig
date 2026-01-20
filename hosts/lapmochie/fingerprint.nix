{ lib, ... }:

/*
  ok so basically i want to only enable fingerprint auth for the things i want (whitelist),
  but setting `config.services.fprintd.enable = true;` causes all of them to be enabled
  so i override the options declaration here.

  I also changed the ordering so i can have enter with empty string be fingerprint and just writing my password work on it's own

  all of this is to replicate [the following snippet from the archwiki](https://wiki.archlinux.org/title/Fprint#Login_configuration):

  ```
  auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
  auth		sufficient  	pam_fprintd.so
  ...
  ```
*/

{
  options.security.pam.services = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config = {
          fprintAuth = lib.mkDefault false;
          rules.auth.fprintd.order = lib.mkForce 32768;
        };
      }
    );
  };

  config = {
    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
    services.fprintd.enable = true;
    security.pam.services =
      let
        cfgThing = {
          fprintAuth = true;
          allowNullPassword = true;
        };
      in
      {
        login = cfgThing;
        sddm = cfgThing;
        sddm-greeter = cfgThing;
        kde = lib.mkForce cfgThing;
        kde-fingerprint = lib.mkForce cfgThing;
      };
  };
}
