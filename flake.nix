{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      #rstudio = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [pagedown]; };
      rmark = pkgs.rPackages.buildRPackage {
        name = "rmarkdown";
        src = pkgs.fetchFromGitHub{
          owner = "rstudio";
          repo = "rmarkdown";
          rev = "b87ca50c8c4d5a5876333b598aed4eb84de925a3";
          sha256 = "12mhmmibizbxgmsns80c8h97rr7rclv9hz98zpgsl26hw3s4l0vm";
        };
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [ R
                                   rPackages.pagedown
                                   rmark
                                   chromium
                                   pandoc
				   rstudio
                                 ];
      };
    });
}
