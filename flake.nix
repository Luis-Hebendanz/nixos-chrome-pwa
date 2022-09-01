{
  description = "NixOS Chrome PWA";

  outputs = { self, nixpkgs }: {
    nixosModule = import ./modules/chrome-pwa;
    nixosModules.default = self.nixosModule;
  };
}
