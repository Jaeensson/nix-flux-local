{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "flux-local";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "flux-local";
    tag = finalAttrs.version;
    hash = "sha256-ABC123";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    aiofiles
    gitpython
    mashumaro
    nest-asyncio
    oras
    pytest
    pytest-asyncio
    python-slugify
    pyyaml
  ];

  pythonImportsCheck = [
    "flux_local"
  ];

  meta = {
    description = "Flux-local is a set of tools and libraries for managing a local flux gitops repository focused on validation steps to help improve quality of commits, PRs, and general local testing";
    homepage = "https://github.com/allenporter/flux-local";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "flux-local";
  };
})
