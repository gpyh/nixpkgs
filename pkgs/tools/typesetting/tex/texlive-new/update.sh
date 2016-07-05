#!/bin/sh

curl ftp://tug.org/historic/systems/texlive/2015/tlnet-final/tlpkg/texlive.tlpdb.xz \
        | xzcat | uniq -u | sed -rn -f ./tl2nix.sed > ./pkgs.nix~
