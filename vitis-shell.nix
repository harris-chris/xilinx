{ pkgs ? import <nixpkgs> {}, vitisPath ? "/opt/xilinx/Vitis_HLS/2021.1" }:

let
  xrt = pkgs.callPackage ./xrt.nix {};

  arch_dummy_script = pkgs.writeShellScriptBin "arch" ''
    #!/bin/bash

    echo $(uname -m)
  '';

  fhs = pkgs.buildFHSUserEnv {
    name = "vitis";
    targetPkgs = pkgs: with pkgs; [
      eclipses.eclipse-sdk
      arch_dummy_script
      bash
      coreutils
      libuuid
      ncurses5
      stdenv.cc.cc
      xorg.libSM
      xorg.libICE
      xorg.libX11
      xorg.libxcb
      xorg.libXext
      xorg.libXft
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      xrt
      zlib
      # common requirements
      freetype
      fontconfig
      glib
      gtk2
      gtk3
      # from installLibs.sh
      graphviz
      # gcc
      #gccMultiStdenv
      (lib.hiPrio gcc)
      glibc
      unzip
      nettools
    ];
    multiPkgs = null;
    profile = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      source ${vitisPath}/settings64.sh
    '';
    #runScript = "vitis_hls -debug -test";
    runScript = "vitis_hls -i";
    #runScript = "vitis_hls -log ./log/vitis.log -journal ./log/vitis.jou";
  };
in fhs.env
