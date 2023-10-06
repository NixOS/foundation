/*
Contract templates for the NixOS Foundation

Use this to create PDFs for contracts with pre-defined terms.

Example:

Run `nix-build contract.nix -A 2023-01 -o 2023-01.pdf` on the following file.

```nix
# contract.nix
let
  contract = import ./default.nix;
  foundation = {
    representative = "Jan Jansen";
    address = ''
      Lorem 123
      45678 Ipsum
      Dolor Sit
    '';
  };
  toPDF = number: parameters:
    contract.pdf "${number}.pdf" (parameters { inherit number foundation; });
in
mapAttrs toPDF {
  "2023-01" = contract.summer-of-nix.roles.participant {
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
*/

let
  inherit (import ./utils.nix) ul ol splitLines;
  inherit (builtins) map concatStringsSep;
  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/release-22.05) {};
in
rec {
  pdf = name: contract: pkgs.runCommand name {
    buildInputs = with pkgs; [ pandoc texlive.combined.scheme-small ];
  } "cat ${builtins.toFile "contract" "${contract}"} | pandoc -t pdf > $out";

  contract = { contractor, definitions, terms, compensation }: { number, foundation }: ''
    # Contract

    Number ${number}

    ## Contract partners

    **Stichting NixOS Foundation**, domiciled in

    ${concatStringsSep ''\
    '' (splitLines foundation.address)}

    referred to as **NixOS Foundation** in this document, represented by **${foundation.representative}**,

    and

    **${contractor.name}**, domiciled in

    ${concatStringsSep ''\
    '' (splitLines contractor.address)}

    referred to as **${contractor.role}** in this document,

    agree on the following terms.

    ## Definitions

    ${concatStringsSep "\n" (map ul definitions)}

    ## Workload and Compensation

    ${concatStringsSep "\n" (map ul compensation)}

    ## Terms

    ${concatStringsSep "\n" (map ol terms)}

    ## Signatures

    | Party     | NixOS Foundation             | ${contractor.role} |
    |-----------|------------------------------|--------------------|
    | Name      | ${foundation.representative} | ${contractor.name} |
    | Date      |                              |                    |
    | Place     |                              |                    |
    | Signature |                              |                    |
  '';

  # generic definitions
  definitions = {
    nix = ''
      **Nix** is an open source build system, configuration management system, and mechanism for deploying software, focused on reproducibility.
      It is the basis of an ecosystem of software development tools – including the Nixpkgs software repository and the NixOS Linux distribution.
    '';
    nixos-foundation = ''
      The **NixOS Foundation** is a not-for-profit organisation representing the community of developers in the Nix ecosystem and curating their commons.
    '';
    project-organiser = ''
      A **Project Organiser** is a representative of **NixOS Foundation** authorised to set goals and priorities for contractors within the scope of their engagement.
    '';
  };

  # generic contract terms
  terms = {
    hours-and-rate = { role, hours, rate }: ''
      **${role}** will work a total of ${toString hours} hours for **NixOS Foundation**, for an hourly rate of ${toString rate} EUR.
    '';
    total-amount = { role, amount }: ''
      **${role}** will receive a total of ${toString amount} EUR as compensation.
    '';
    time-frame = { role, time-frame }: ''
      **${role}** will perform the agreed-upon work within the **time frame ${time-frame}**.
    '';
    priorities = { role }: ''
      A **Project Organiser**, designated by **NixOS Foundation**, will communicate goals and priorities of this engagement to **${role}**, and support them in administrative issues.
    '';
    progress-reviews = { role }: ''
      **${role}** and **Project Organiser** will weekly review progress, and adjust priorities as needed.
    '';
    written-summaries = { role }: ''
      **${role}** will weekly provide a brief written overview of work done, for the purpose of **NixOS Foundation** reporting to financiers and the general public.
    '';
    license = { role }: ''
      **${role}** will submit the results of their work to the public benefit under a free and open source software license.
    '';
    code-of-conduct = { role }: ''
      **${role}** will adhere to the most recently published version of the ACM Code of Conduct during any activities related to this engagement.
      If and where the Code of Conduct is in contradiction with one or more statements in the text of this agreement, the agreement will prevail.
    '';
    public-statements = { role, optional ? true }: ''
      **NixOS Foundation** and **${role}** may issue one or more individual or joint public statements regarding this agreement or work results. ${if optional then ''
    This is optional and requires explicit agreement by **${role}**.
    '' else ""}'';
    no-claims = { role }: ''
      Outside of this agreed-upon scope, there cannot be any financial claims towards either **NixOS Foundation** or **${role}**, unless previously mutually agreed in writing.
    '';
    taxes = { role }: ''
      **${role}** understands that they are not employed by the **NixOS Foundation** and they have the sole responsibility to follow legal obligations with regard to this agreement according to their jurisdiction, such as taxes, social security, reporting, etc.
    '';
    invoicing = { role }: ''
      **${role}** will submit monthly invoices to **NixOS Foundation**, detailing the effort by the hour.
      Invoices shall be submitted within 30 calendar days of the billed work being done.
    '';
    invoiced-amount = _: ''
      The agreed-upon compensation is the total amount to be invoiced.
      If VAT is reverse charged, the invoiced amount must be reduced accordingly.
    '';
    payment-duties = { role }: ''
      The **NixOS Foundation** will transfer payment within 30 calendar days after receiving an invoice.
    '';
    availability = { role }: ''
      If **${role}** is unable to keep to the agreed-upon schedule, or become temporarily or permantly unavailable for the purposes of this agreement, they will notify the **Project Organiser** immediately.

      In such a situation, **NixOS Foundation** has the right to suspend or terminate the contract.
      **NixOS Foundation** will inform **${role}** one week (seven days) in advance of its intent to suspend or terminate the contract.
      If **${role}** is able to fulfill their obligations within that period after all, **NixOS Foundation** shall still pay the due amount according to the regular procedure.
    '';
  };
}
