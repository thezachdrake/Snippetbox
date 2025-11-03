{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          # Import all project tools from nix/tools.nix
          #tools = import ./nix/tools.nix { inherit pkgs; };
        in
        {
          default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                # Go language and tooling
                go # Go (latest stable)
                gopls # Go language server                              
              ];
              #++ (builtins.attrValues tools); # Add all custom tools

            shellHook = ''
              # Set up local Go workspace with absolute paths
              export GOPATH="$PWD/.go"
              export GOMODCACHE="$GOPATH/pkg/mod"
              export PATH="$GOPATH/bin:$PATH"
            '';
          };
        }
      );
    };
}
