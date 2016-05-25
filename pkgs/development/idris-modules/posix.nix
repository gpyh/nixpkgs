{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}: build-idris-package {
  name = "posix";

  src = fetchFromGitHub {
    owner = "colin-adams";
    repo = "idris-posix";
    rev = "3d9a6d39ba7c45aa98558c1d928eb2b14006522f";
    sha256 = "0kg3d7804p9p3zhf5f8bf83r0qg60adfzgic5ckmazcffw0lr5dd";
  };

  propagatedBuildInputs = [ prelude base ];

  meta = {
    description = "System POSIX bindings for Idris";
    homepage = https://github.com/colin-adams/idris-posix;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
