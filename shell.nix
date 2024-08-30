{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let fhs = pkgs.buildFHSUserEnv {
  name = "android-env";
  targetPkgs = pkgs: with pkgs;
    [ git
      gitRepo
      gnupg
      curl
      procps
      openssl
      gnumake
      nettools
      # For nixos < 19.03, use `androidenv.platformTools`
      androidenv.androidPkgs_9_0.platform-tools
      jdk
      schedtool
      util-linux
      m4
      gperf
      perl
      libxml2
      zip
      unzip
      bison
      flex
      lzop
      python3
    ];
  multiPkgs = pkgs: with pkgs;
    [ zlib
      ncurses5
    ];
  profile = ''
    export ALLOW_NINJA_ENV=true
    export USE_CCACHE=1
    export ANDROID_JAVA_HOME=${pkgs.jdk.home}sdkmanager install avd
    export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
  '';
}; in
mkShell {
  buildInputs = [
    git
    nodejs_20
    androidStudioPackages.canary
    android-tools
    fhs
  ];
  CAPACITOR_ANDROID_STUDIO_PATH = "${androidStudioPackages.canary}/bin/android-studio-canary";
#  shellHook = ''
#    exec android-env
#  '';
}
