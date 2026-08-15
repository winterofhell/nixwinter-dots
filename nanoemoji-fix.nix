final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyFinal: pyPrev: {
      nanoemoji = pyPrev.nanoemoji.overridePythonAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "googlefonts";
          repo = "nanoemoji";
          tag = "v${old.version}";
          hash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
        };
      });
    })
  ];
}
