{
  autoPatchelfHook,
  dpkg,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  udev,
  stdenv,
  lib,
  wrapGAppsHook3,
  alsa-lib,
  nss,
  nspr,
  systemd,
  libxtst,
  libxscrnsaver,
}:
let
  desktopItem = makeDesktopItem {
    desktopName = "HakuNeko Desktop";
    genericName = "Manga & Anime Downloader";
    categories = [
      "Network"
      "FileTransfer"
    ];
    exec = "hakuneko";
    icon = "hakuneko-desktop";
    name = "hakuneko-desktop";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hakuneko";
  version = "8.3.4";

  src =
    {
      "x86_64-linux" = fetchurl {
      	url = "https://github.com/manga-download/hakuneko/releases/download/nightly-20200705.1/hakuneko-desktop_8.3.4_linux_amd64.deb";
        sha256 = "SOmncBVpX+aTkKyZtUGEz3k/McNFLRdPz0EFLMsq4hE=";
      };
    }
    ."${stdenv.hostPlatform.system}" or (throw "unsupported system ${stdenv.hostPlatform.system}");

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  # TODO: migrate off autoPatchelfHook and use nixpkgs' electron
  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    nss
    nspr
    libxscrnsaver
    libxtst
    systemd
  ];

  unpackPhase = ''
    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract
  '';

  installPhase = ''
    cp -R usr "$out"
    # Overwrite existing .desktop file.
    cp "${desktopItem}/share/applications/hakuneko-desktop.desktop" \
       "$out/share/applications/hakuneko-desktop.desktop"
  '';

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  postFixup = ''
      makeWrapper $out/lib/hakuneko-desktop/hakuneko $out/bin/hakuneko \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Manga & Anime Downloader";
    homepage = "https://sourceforge.net/projects/hakuneko/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      nloomans
    ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "hakuneko";
  };
})
