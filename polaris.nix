{ inputs, ... }:

{
  # nixpkgs ships an unrelated "polaris" (music server) with the same option name.
  disabledModules = [ "services/misc/polaris.nix" ];

  # Polaris stream host (for the Nova / Moonlight client).
  # Built from source: AMD GPU, so no CUDA. Source is fetched with git
  # (with all nested submodules), because Nix's own flake fetcher cannot
  # resolve Granite's nested submodule.
  nixpkgs.overlays = [
    inputs.polaris.overlays.default
    # Upstream session scripts trip info-level notes (SC2030/SC2031) in the newer
    # ShellCheck from nixos-unstable, which fails the build. For polaris-* scripts
    # only, keep the bash syntax check and skip ShellCheck. Other scripts unchanged.
    (final: prev: {
      writeShellApplication =
        args:
        prev.writeShellApplication (
          args
          // final.lib.optionalAttrs (final.lib.hasPrefix "polaris-" (args.name or "")) {
            checkPhase = ''
              runHook preCheck
              ${final.stdenv.shellDryRun} "$target"
              runHook postCheck
            '';
          }
        );
    })
    (final: prev: {
      polaris-stream =
        (prev.polaris-stream.override {
          cudaSupport = false;
          polarisSrc = final.fetchgit {
            url = "https://github.com/papi-ux/polaris";
            tag = "v1.4.13";
            fetchSubmodules = true;
            hash = "sha256-yUJSWT8ypJdIeWOpclJ+mSUjlTPQyVHjEuBbe3qngCI="; # polaris-src
          };
        }).overrideAttrs
          (old: {
            # Vulkan Video encode (AMD VCN, frames stay on the GPU). Upstream only
            # adds the Vulkan headers/loader path for CUDA builds.
            buildInputs = old.buildInputs ++ [ final.vulkan-headers ];
            cmakeFlags = old.cmakeFlags ++ [ (final.lib.cmakeBool "POLARIS_ENABLE_VULKAN" true) ];
            # The home-manager module ships its own Nix-wrapped
            # polaris-gamescope-session (and points Polaris at it), so drop the
            # unwrapped copy to avoid a home-manager-path file collision.
            postFixup = (old.postFixup or "") + ''
              rm -f $out/bin/polaris-gamescope-session $out/bin/.polaris-gamescope-session-wrapped
              wrapProgram $out/bin/polaris \
                --prefix LD_LIBRARY_PATH : ${final.lib.makeLibraryPath [ final.vulkan-loader ]}
            '';
          });
    })
  ];

  services.polaris = {
    enable = true;
    users = [ "nixwinter" ];
  };
}
