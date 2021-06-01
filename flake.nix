{
  description = "Terrikon dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            openssl
            pkgconfig
            qemu
            qemu-utils
            gdb
            edk2
            OVMF
            (rust-bin.nightly.latest.default.override {
              extensions =
                [ "rust-src" "rustfmt" "clippy" "llvm-tools-preview" ];
              #targets = [ "riscv64gc-unknown-none-elf" ];
            })
          ];

          shellHook = ''
            alias cx="cargo xtask"
          '';
        };
      });
}
