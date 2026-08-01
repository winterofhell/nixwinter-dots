{
  lib,
  fetchPypi,
  python3Packages,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  pipewire,
  gtk4,
  libadwaita,
  libebur128,
  wrapGAppsHook4,
}:
let
  pipewireGobject = python3Packages.buildPythonPackage rec {
    pname = "pipewire-gobject";
    version = "0.3.9";
    pyproject = true;

    src = fetchPypi {
      pname = "pipewire_gobject";
      inherit version;
      hash = "sha256-8b6b1Kgo+09MaXdYfAlI/eRhN7RcQUxFeJTMM9ouzyw=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'setup = ["-Dwheel=true", "--wrap-mode=nofallback"]' \
        'setup = ["-Dwheel=true", "-Dtests=false", "--wrap-mode=nofallback"]'
    '';

    build-system = with python3Packages; [
      meson-python
      setuptools
    ];

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      gobject-introspection
    ];

    buildInputs = [
      glib
      pipewire
    ];

    dependencies = [
      python3Packages.pygobject3
    ];

    doCheck = false;
  };
in
python3Packages.buildPythonApplication rec {
  pname = "mini-eq";
  version = "0.8.7";
  pyproject = true;

  src = fetchPypi {
    pname = "mini_eq";
    inherit version;
    hash = "sha256-Ouwt+Y6aHljNvFGmOOmqBsuBIhqTlKDzF+1OIh4cZOg=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libebur128
    pipewire
  ];

  dependencies = [
    python3Packages.numpy
    python3Packages.pycairo
    python3Packages.pygobject3
    pipewireGobject
  ];

  postInstall = ''
    install -Dm644 data/io.github.bhack.mini-eq.desktop \
      $out/share/applications/io.github.bhack.mini-eq.desktop
    install -Dm644 data/io.github.bhack.mini-eq.metainfo.xml \
      $out/share/metainfo/io.github.bhack.mini-eq.metainfo.xml
    install -Dm644 src/mini_eq/assets/icons/hicolor/scalable/apps/io.github.bhack.mini-eq.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.bhack.mini-eq.svg
    install -Dm644 src/mini_eq/assets/icons/hicolor/symbolic/apps/io.github.bhack.mini-eq-symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/io.github.bhack.mini-eq-symbolic.svg
    install -Dm644 src/mini_eq/assets/schemas/io.github.bhack.mini-eq.gschema.xml \
      $out/share/glib-2.0/schemas/io.github.bhack.mini-eq.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  doCheck = false;

  meta = {
    description = "Compact PipeWire system-wide parametric equalizer";
    homepage = "https://github.com/bhack/mini-eq";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "mini-eq";
  };
}
