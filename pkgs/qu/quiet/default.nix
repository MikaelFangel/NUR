{ lib, appimageTools, fetchurl }:

let
  pname = "quiet";
  version = "2.1.1";
  name = "quiet-${version}";
  src = fetchurl {
    url = "https://github.com/TryQuiet/quiet/releases/download/%40quiet%2Fdesktop%40${version}/Quiet-${version}.AppImage";
    hash = "sha256-/YDGspQbl2kvS5Iwl2Ys/yxhB9rZoxG66TSBr35GvBI=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/@quietdesktop.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/@quietdesktop.desktop \
      --replace 'Exec=AppRun' 'Exec=@quietdesktop'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Alternative to team chat apps like Slack, Discord, and Element that does not require trusting a central server or running one's own";
    homepage = "https://github.com/TryQuiet/quiet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "quiet";
  };
}
