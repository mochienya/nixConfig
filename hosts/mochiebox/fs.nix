args@{ pkgs, ... }:

{
  # my second ntfs drive
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/C47A48227A481418";
    fsType = "ntfs3";
    options = [
      "defaults"
      "uid=1000"
      "gid=1000"
      "umask=0022"
      "nofail"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7c4226d8-a60d-4fa3-940c-e5db45d79f95";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B4B8-7650";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
