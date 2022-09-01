{
  description = "NixOS Chrome PWA";

  outputs = { self, nixpkgs }: {
    nixosModule = import ./modules/vscode-server;
    nixosModules.default = self.nixosModule;
  };
}
