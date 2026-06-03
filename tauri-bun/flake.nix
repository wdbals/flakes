{
  description = "Entorno Tauri v2 con Bun y soporte para Wayland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Librerías dinámicas del sistema requeridas por Tauri en Linux
      libraries = with pkgs; [
        webkitgtk_4_1
        gtk3
        cairo
        gdk-pixbuf
        glib
        dbus
        openssl_3
        librsvg
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # Herramientas de compilación y ejecución
        nativeBuildInputs = with pkgs; [
          pkg-config
          wrapGAppsHook4
          cargo
          cargo-tauri
          rustc
          rustfmt
          bun
        ];

        # Dependencias a enlazar
        buildInputs = libraries;

        shellHook = ''
          # Enlaza las librerías dinámicas para que Fedora las encuentre al ejecutar el binario
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH

          # El arreglo para la escala de pantalla en Wayland
          export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"

          echo "=================================================="
          echo "Entorno Tauri v2 (Wayland) + Bun activado"
          echo "Bun: $(bun --version)"
          echo "Rust: $(rustc --version)"
          echo "=================================================="
        '';
      };
    };
}
