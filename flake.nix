{
  description = "TgScrumPoker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let out = system:
    let
      pkgs = nixpkgs.legacyPackages."${system}";
      deps = with nixpkgs; import ./deps.nix { inherit lib; beamPackages = pkgs.beamPackages; };
    in {
      defaultPackage = pkgs.beamPackages.mixRelease rec {
        version = "0.3.0";
        pname = "TgScrumPoker";
        mixEnv = "prod";
        src = ./.;
        mixNixDeps = deps;

        buildInputs = with pkgs; [ erlang libudev ncurses5 zlib openssl ];
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
              LD_LIBRARY_PATH = with pkgs; makeLibraryPath [ erlang libudev ncurses5 zlib openssl self.defaultPackage."${system}" ];
            };
          };
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          elixir
          elixir_ls
          mix2nix
        ];
      };
    }; in with flake-utils.lib; eachSystem defaultSystems out;
}
