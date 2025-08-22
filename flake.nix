{
  description = "cpp project";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nativeBuildInputs = with pkgs; [
          meson
          ninja
          pkg-config
          wayland-scanner
          scdoc
        ];
        buildInputs = with pkgs; [
          wlroots
          wayland
          wayland-protocols
          json_c
          pcre2
          libxkbcommon
          cairo
          pango
          gdk-pixbuf
          libGL
          libevdev
          libinput
          librsvg
          libdrm
          xorg.xcbutilwm
        ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "sway";
          inherit nativeBuildInputs buildInputs;
          mesonFlags = [
            (pkgs.lib.strings.mesonOption "sd-bus-provider" "libsystemd")
          ];
          src = ./.;
        };
        devShell =
          with pkgs;
          mkShell {
            buildInputs = buildInputs ++ [
              clang-tools
              lldb
            ];
            LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
          };
      }
    );
}
