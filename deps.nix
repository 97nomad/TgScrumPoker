{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0zmvagzisnk7lj5pfipl19mjq9wn70i339hpbkfljf0vk6s9fk2j";
      };

      beamDeps = [];
    };

    ex_gram = buildMix rec {
      name = "ex_gram";
      version = "0.21.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k9kg1nf9m0rhhzfkkhzd04677wcqz4vj205nc2mgffjaf82v984";
      };

      beamDeps = [ hackney jason maxwell tesla ];
    };

    gproc = buildRebar3 rec {
      name = "gproc";
      version = "0.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pm7wb8hbn3z0p5qcxsfd5l1ycmghr6dz9gm7qk7afs6avxdl2jq";
      };

      beamDeps = [];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.17.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05kbk3rpw2j3cb9pybikydxmi2nm5pidpx0jsm48av2mjr4zy5ny";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sjcjibl34sprpf1dgdmzfww24xlyy34lpj7mhcys4j4i6vnwdwj";
      };

      beamDeps = [ unicode_util_compat ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "02vz6ibhzz5x4pypd28nd2q20gdkb67i832cdax8clcdlf8qixji";
      };

      beamDeps = [];
    };

    maxwell = buildMix rec {
      name = "maxwell";
      version = "2.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0f9aninkjw6yn26700k1iipyy4jpnbhc7kqh90wsx609gx31ygxa";
      };

      beamDeps = [ hackney mimerl ];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05lz15piphyhvvm3d1ldjyw0zsrvz50d2m5f2q3s8x2gvkfrmc39";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "1.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19qrpnmaf3w8bblvkv6z5g82hzd10rhc7bqxvqyi88c37xhsi89i";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08wkw73dy449n68ssrkz57gikfzqk3vfnf264s31jn5aa1b5hy7j";
      };

      beamDeps = [];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "12w8ai6b5s6b4hnvkav7hwxd846zdd74r32f84nkcmjzi1vrbk87";
      };

      beamDeps = [];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1026l1z1jh25z8bfrhaw0ryk5gprhrpnirq877zqhg253x3x5c5x";
      };

      beamDeps = [];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ap0ndp2mh9vldwhk2482gcq1mj7fczvcqqkcj7clpwzasjp84xz";
      };

      beamDeps = [ hackney jason mime ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08952lw8cjdw8w171lv8wqbrxc4rcmb3jhkrdb7n06gngpbfdvi5";
      };

      beamDeps = [];
    };
  };
in self

