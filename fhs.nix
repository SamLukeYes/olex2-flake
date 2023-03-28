{ lib
, buildFHSUserEnvBubblewrap
, writeShellScript
, runtimeShell
, libnotify
, xdg-utils
, olex2-dropin
, forceX11 ? false
, targetPkgs ? ps: with ps; [
    gdk-pixbuf gtk3 libGL libxcrypt-legacy mpi openblas
  ]
}:

buildFHSUserEnvBubblewrap {
  inherit targetPkgs;
  name = "olex2";
  runScript = writeShellScript "olex2-launcher" (''
    ls /usr/lib
    if [ ! -f ~/olex2/start ]
    then
      ${libnotify}/bin/notify-send "Olex2 Launcher" \
        "Please download the official zip file and extract it to your home directory."
      ${xdg-utils}/bin/xdg-open https://www.olexsys.org/olex2/docs/getting-started/installing-olex2/#linux
      exit 1
    fi
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share
  '' + lib.optionalString forceX11 ''
    export GDK_BACKEND=x11
  '' + ''
    ${runtimeShell} ~/olex2/start
  '');
  dieWithParent = false;

  extraBwrapArgs = [
    "--ro-bind" "${olex2-dropin}/bin/olex2" "~/olex2/olex2"
    "--ro-bind" "${olex2-dropin}/bin/unirun" "~/olex2/unirun"
  ];
  
  extraInstallCommands = ''
    cd ${olex2-dropin.src}

    mkdir -p $out/share/pixmaps
    cp scripts/olex2.xpm $out/share/pixmaps

    mkdir -p $out/share/applications
    cp scripts/olex2.desktop $out/share/applications
    substituteInPlace $out/share/applications/olex2.desktop \
      --replace "/usr/bin/" "$out/bin/" \
      --replace "olex2.xpm" "$out/share/pixmaps/olex2.xpm"
  '';
}