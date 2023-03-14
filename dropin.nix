{ lib
, stdenv
, src
, version
# , desktop-file-utils
, fontconfig
, libGL
, libGLU
, libxcrypt
, python
, scons
, wxGTK
# , xorg
}:

stdenv.mkDerivation {
  inherit src version;
  pname = "olex2-dropin";

  nativeBuildInputs = [
    # desktop-file-utils
    scons
  ];

  buildInputs = [
    fontconfig
    libGL
    libGLU
    libxcrypt
    python
    wxGTK
    # xorg.libX11
  ];

  enableParallelBuilding = true;

  # Draft: use Makefile instead of SConstruct
  # makeFlags = [ "LDFLAGS=-Wl,--copy-dt-needed-entries" ];

  # postPatch = ''
  #   substituteInPlace Makefile \
  #     --replace "/usr/" "$out/" \
  #     --replace "--toolkit=gtk2" "--toolkit=gtk3"
  # '';

  # preBuild = ''
  #   makeFlagsArray+=(
  #     LDFLAGS="-lfontconfig -lm -lpython${lib.versions.majorMinor python3.version} -lstdc++"
  #   )
  # '';

  postPatch = ''
    2to3 -w -n SConstruct
    substituteInPlace SConstruct \
      --replace "string.find(file.name, 'wglscene.cpp') != -1" "'wglscene.cpp' in file.name" \
      --replace "['libGL', 'libGLU']" "['libGL', 'libGLU', 'fontconfig', 'python${
        lib.versions.majorMinor python.version
      }']"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp build/scons/*/*/*/exe/{olex2,unirun} $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "An intuitive and easy to use crystallographic program deidcated especially to solve crystal structures of small molecules";
    homepage = "https://www.olexsys.org/olex2/";
    license = licenses.bsd3;
  };
}