{ pkgs ? import <nixpkgs> {}}:

let
  #my-pkgs = import <nixpkgs> {
    #overlays = [
      #(self: super: with self; {
        #my-gcc = lowPrio (wrapCC (super.gcc.cc.overrideAttrs(old: {
          #configureFlags = old.configureFlags ++ [
            #"--enable-multilib"
          #];
        #})));
      #})
    #];
  #};

  fhs = pkgs.buildFHSUserEnv {
    name = "gcc-test";
    targetPkgs = pkgs: with my-pkgs; [
      gccMultiStdenv
    ];
    multiPkgs = null;
    profile = "";
    runScript = "echo HELLO";
  };
in fhs.env
