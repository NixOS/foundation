# NGI0 and Summer of Nix contract templates

Using these templates, create a file with contract parameters:

```nix
# contracts.nix
let
  ngi = import ./.;
  foundation = {
    representative = "Jan Jansen";
    address = ''
      Lorem 123
      45678 Ipsum
      Dolor Sit
    '';
  };
in
mapAttrs (ngi.contracts.toPDF foundation) {
  "2024-13" = contract.participant {
    name = "John Default";
    address = ''
      Fakestreet 123
      Springfield
      USA
    '';
    amount = 3000;
  };
}
```

Then make a PDF in the current directory with:

```console
nix-shell -A 2024-13 --run pdf
```

