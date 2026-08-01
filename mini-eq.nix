{
  lib,
  stdenv,
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
  graphene,
  libebur128,
  wrapGAppsHook4,
}:

let
  pipewireGobject = stdenv.mkDerivation rec {
    pname = "pipewire-gobject";
    version = "0.3.9";

    src = fetchPypi {
      pname = "pipewire_gobject";
      inherit version;
      hash = "sha256-8b6b1Kgo+09MaXdYfAlI/eRhN7RcQUxFeJTMM9ouzyw=";
    };

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

    mesonFlags = [
      "-Dwheel=false"
      "-Dtests=false"
    ];

    postInstall = ''
      install -Dm644 ../python/pipewire_gobject/__init__.py \
        "$out/${python3Packages.python.sitePackages}/pipewire_gobject/__init__.py"
    '';
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'dependencies = ["numpy>=1.26", "pipewire-gobject>=0.3.9,<0.4"]' \
        'dependencies = ["numpy>=1.26"]'
  '';

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  nativeBuildInputs = [
    glib
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    graphene
    libebur128
    pipewire
    pipewireGobject
  ];

  dependencies = [
    python3Packages.numpy
    python3Packages.pycairo
    python3Packages.pygobject3
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

  dontCheckPythonMetadata = true;
  dontWrapGApps = true;
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "${pipewireGobject}/${python3Packages.python.sitePackages}"
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [
        gtk4
        libadwaita
        graphene
        pipewireGobject
      ]}"
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        glib
        gtk4
        libadwaita
        graphene
        libebur128
        pipewire
        pipewireGobject
      ]}"
      --set PIPEWIRE_MODULE_DIR "${lib.getLib pipewire}/lib/pipewire-0.3"
      --set SPA_PLUGIN_DIR "${lib.getLib pipewire}/lib/spa-0.2"
    )

    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Compact PipeWire system-wide parametric equalizer";
    homepage = "https://github.com/bhack/mini-eq";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "mini-eq";
  };
}