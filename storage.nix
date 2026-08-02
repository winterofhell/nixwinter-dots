{ ... }:

{
  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/e736c6f0-8490-44c7-842a-57b1e2520118";
    fsType = "xfs";
    options = [
      "noatime"
      "lazytime"
      "inode64"
      "logbufs=8"
      "logbsize=32k"
      "x-gvfs-show"
      "x-gvfs-name=Games"
    ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/98d58603-dd43-4cc3-bf39-07a93b4f0999";
    fsType = "ext4";
    options = [
      "noatime"
      "lazytime"
      "x-gvfs-show"
      "x-gvfs-name=Data"
    ];
  };
}
