{
  description = "Mi colección personal de plantillas Nix";

  outputs = { ... }: {
    templates = {
      tauri-bun = {
        path = ./tauri-bun;
        description = "Entorno Tauri v2 con Rust, Bun y librerías Wayland";
      };
    };
  };
}
