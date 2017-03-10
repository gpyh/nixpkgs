{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem,
  makeWrapper, libXScrnSaver }:

let
  version = "1.10.1";
  rev = "653f8733dd5a5c43d66d7168b4701f94d72b62e5";
  channel = "stable";

  # The revision can be obtained with the following command (see https://github.com/NixOS/nixpkgs/issues/22465):
  # curl -w "%{url_effective}\n" -I -L -s -S https://vscode-update.azurewebsites.net/latest/linux-x64/stable -o /dev/null

  sha256 = if stdenv.system == "i686-linux"    then "14ip00ysnn6daw7ws3vgnhib18pi7r1z1szfr7s996awbq12ir3i"
      else if stdenv.system == "x86_64-linux"  then "06i8kw9z70hb6lvdp6nmswky8p9mrn7qxbpbd347v6cycpd50dc0"
      else if stdenv.system == "x86_64-darwin" then "1y574b4wpkk06a36clajx57ydj7a0scn2gms4070cqaf0afzy19f"
      else throw "Unsupported system: ${stdenv.system}";

  urlBase = "https://az764295.vo.msecnd.net/${channel}/${rev}/";

  urlStr = if stdenv.system == "i686-linux" then
        urlBase + "code-${channel}-code_${version}-1488384152_i386.tar.gz"
      else if stdenv.system == "x86_64-linux" then
        urlBase + "code-${channel}-code_${version}-1488415350_amd64.tar.gz"
      else if stdenv.system == "x86_64-darwin" then
        urlBase + "VSCode-darwin-${channel}.zip"
      else throw "Unsupported system: ${stdenv.system}";
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    inherit version;

    src = fetchurl {
      url = urlStr;
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      name = "code";
      exec = "code";
      icon = "code";
      comment = "Code editor redefined and optimized for building and debugging modern web and cloud applications";
      desktopName = "Visual Studio Code";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    buildInputs = if stdenv.system == "x86_64-darwin"
      then [ unzip makeWrapper libXScrnSaver ]
      else [ makeWrapper libXScrnSaver ];

    installPhase = ''
      mkdir -p $out/lib/vscode $out/bin
      cp -r ./* $out/lib/vscode
      ln -s $out/lib/vscode/code $out/bin

      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/* $out/share/applications

      mkdir -p $out/share/pixmaps
      cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
    '';

    postFixup = lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$out/lib/vscode" \
        $out/lib/vscode/code

      wrapProgram $out/bin/code \
        --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1
    '';

    meta = with stdenv.lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and OS X
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and OS X. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = http://code.visualstudio.com/;
      downloadPage = https://code.visualstudio.com/Updates;
      license = licenses.unfree;
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
