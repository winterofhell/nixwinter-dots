{ lib, ... }:

{
  services.polaris = {
    enable = true;
    streamMode = "labwc";
    # RX 9070 XT, so gamescope never picks the Ryzen iGPU.
    preferVkDevice = "1002:7550";
  };

  # The module's first-run config is NVIDIA-oriented (encoder = nvenc).
  # Seed the documented Private Stream setup instead; encoder stays Auto,
  # which picks Vulkan Video on AMD and falls back to VA-API if needed.
  # Only written when missing, so web UI changes are kept.
  home.activation.polarisConfAmd = lib.hm.dag.entryBetween [ "polarisConfSeed" ] [ "writeBoundary" ] ''
    conf="$HOME/.config/polaris/polaris.conf"
    mkdir -p "$HOME/.config/polaris"
    if [ ! -f "$conf" ]; then
      cat > "$conf" <<'CONF'
    headless_mode = enabled
    linux_use_cage_compositor = enabled
    linux_prefer_gpu_native_capture = enabled
    linux_stream_mode = headless_stream
    hdr_mode = 0
    stream_audio = enabled
    enable_pairing = enabled
    enable_discovery = enabled
    max_sessions = 2
    CONF
      chmod 600 "$conf"
    else
      sed -i '/^encoder = nvenc$/d; s/^linux_stream_mode = labwc$/linux_stream_mode = headless_stream/' "$conf"
    fi
  '';
}
