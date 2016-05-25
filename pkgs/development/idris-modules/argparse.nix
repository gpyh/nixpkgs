{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lightyear
, test
, lib
, idris
}: build-idris-package {
  name = "argparse";

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-argparse";
    rev = "3d0030e8996bdbe2505204b338662f532787dd3e";
    sha256 = "0x35bmjy6mmx46ahsbn1fbn90k93r7dydjyscnksvy15cpl4rksa";
  };

  propagatedBuildInputs = [ prelude base lightyear test ];

  meta = {
    description = "A simple argument parser written in Idris";
    homepage = https://github.com/jfdm/idris-argparse;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
