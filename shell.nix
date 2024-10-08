{ pkgs ? import <nixpkgs> { }, extraBuildInputs ? [ ] }:

let
  buildInputs = with pkgs;
    [ expat gcc libGL stdenv.cc.cc.lib xorg.libX11 zlib ] ++ extraBuildInputs;

  lib-path = with pkgs; lib.makeLibraryPath buildInputs;

  shell = pkgs.mkShell {
    buildInputs = [ pkgs.python3 ];
    shellHook = ''
      # Allow the use of wheels.
      SOURCE_DATE_EPOCH=$(date +%s)

      # Augment the dynamic linker path
      export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"

      # Setup the virtual environment if it doesn't already exist.
      VENV=.venv

      if test ! -d $VENV; then
        python3 -m venv $VENV
      fi

      source ./$VENV/bin/activate
      pip3 install build123d
    '';
  };

in shell
