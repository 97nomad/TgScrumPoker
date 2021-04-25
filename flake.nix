{
  description = "TgScrumPoker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    tg_scrum_poker.url = https://github.com/97nomad/TgScrumPoker/releases/download/0.3.0/tg_scrum_poker-0.3.0.tar.gz;
    tg_scrum_poker.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, tg_scrum_poker }:
    let out = system:
    let pkgs = nixpkgs.legacyPackages."${system}";
    in {
      defaultPackage = pkgs.stdenv.mkDerivation {
        version = "0.3.0";
        name = "TgScrumPoker";
        src = tg_scrum_poker;

        buildInputs = with pkgs; [ erlang libudev ncurses6 zlib openssl ];

        installPhase = ''
            mkdir $out
            cp -r ./* $out
          '';
      };

      nixosModule = { config, ... }: with nixpkgs.lib; {
        options = {
          services.tgScrumPoker = {
            enable = mkEnableOption "enables this service";
            token = mkOption {
              type = types.str;
              example = "insert_token_here";
              description = ''
                  Telegram API token
                '';
            };
          };
        };
        config = mkIf config.services.tgScrumPoker.enable {
          systemd.services.tgScrumPoker = {
            serviceConfig = {
              ExecStart = "${self.defaultPackage."${system}"}/bin/tg_scrum_poker start";
              ExecStop = "${self.defaultPackage."${system}"}/bin/tg_scrum_poker stop";
            };
            environment = {
              TG_BOT_TOKEN = config.services.tgScrumPoker.token;
              LD_LIBRARY_PATH = with pkgs; makeLibraryPath [ erlang libudev ncurses6 zlib openssl self.defaultPackage."${system}" ];
            };
          };
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          elixir
        ];
      };
    }; in with flake-utils.lib; eachSystem defaultSystems out;
}
