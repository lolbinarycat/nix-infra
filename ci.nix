# Add derivations to be built from the cache to this file
{ system ? builtins.currentSystem
, src ? { ref = null; }
}:
let
  self = builtins.getFlake (toString ./.);
  terraform = builtins.getFlake (toString ./terraform/.);
  inherit (self.inputs.nixpkgs) lib;
  stripDomain = name: lib.head (builtins.match "(.*).nix-community.org" name);
in
(lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${stripDomain name}" config.config.system.build.toplevel) self.outputs.nixosConfigurations) //
{
  # FIXME: maybe find a more generic solution here?
  devShell-x86_64 = self.outputs.devShells.x86_64-linux.default;
  devShell-aarch64 = self.outputs.devShells.aarch64-linux.default;
  devShell-terraform-x86_64 = terraform.outputs.devShells.x86_64-linux.default;
} // self.outputs.checks.x86_64-linux # mainly for treefmt at the moment...
