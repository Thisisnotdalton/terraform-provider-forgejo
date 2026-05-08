{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = [
                pkgs.gnumake
                pkgs.go
                pkgs.opentofu
            ];
            shellHook = ''
                cd docker && docker compose down -v --remove-orphans && docker compose up -d
                source access_tokens/env.admin_token
                cd ../examples
            '';
          };
        };
      }
    );
}
