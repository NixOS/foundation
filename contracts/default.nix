/*
  Contract templates for the NixOS Foundation

  Use this to create PDFs for contracts with pre-defined terms.
*/

let
  inherit (import ./utils.nix) ul ol splitLines;
  inherit (builtins) map concatStringsSep;
  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/nixos-23.11) { };
in
rec {
  toPDF = foundation: number: parameters:
    pdf "${number}.pdf" (parameters { inherit number foundation; });
  pdf = name: contract: pkgs.runCommand name
    {
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
  };

  # generic contract terms
  terms = {
    compensation = { role, ... }@args:
      let
        hours-and-rate = { role, hours, rate, currency ? "EUR" }: ''
          **${role}** will work a total of ${toString hours} hours for the purposes of this agreement, for an hourly rate of ${toString rate} ${currency}.
        '';
        total-amount = { role, amount, currency ? "EUR" }: ''
          **${role}** will receive a total of ${toString amount} ${currency} as compensation.
        '';
      in
      if args ? amount then total-amount args else hours-and-rate args;
    time-frame = { role, time-frame }: ''
      **${role}** will perform the agreed-upon work within the **time frame ${time-frame}**.
    '';
    priorities = { role, supervisor }: ''
      The **${supervisor}**, designated by **NixOS Foundation**, will communicate goals and priorities of this engagement to **${role}**, and support them in administrative issues.
    '';
    progress-reviews = { role, supervisor, interval }: ''
      **${role}** and **${supervisor}** will ${interval} review progress, and adjust priorities as needed.
    '';
    written-summaries = { role, interval }: ''
      **${role}** will ${interval} provide a brief written overview of work done, for the purpose of **NixOS Foundation** reporting to financiers and the general public.
    '';
    license = { role }: ''
      **${role}** will submit the results of their work to the public benefit under a free and open source software license.
    '';
    privacy = { role }: ''
      Due to the nature of this project's collaboration model, **${role}**'s work results, including contributions to discussion, will appear in publicly accessible places on the internet, such as GitHub, and remain there indefinitely.
      This has potential for revealing personally-identifiable information apart from the self-chosen user name, such as times of activity, writing style, etc.

      **${role}** is free to create an internet pseudonym for the purposes of this engagement in order to limit exposure.
    '';
    code-of-conduct = { role }: ''
      **${role}** will adhere to the most recently published version of the ACM Code of Conduct during any activities related to this engagement.
      If and where the Code of Conduct is in contradiction with one or more statements in the text of this agreement, the agreement will prevail.
    '';
    public-statements = { role, optional ? true }: ''
      **NixOS Foundation** and **${role}** may issue one or more individual or joint public statements regarding this agreement or work results.
      ${if optional then "This is optional and requires explicit agreement by **${role}**." else ""}
    '';
    no-claims = { role }: ''
      Outside of this agreed-upon scope, there cannot be any financial claims towards either **NixOS Foundation** or **${role}**, unless previously mutually agreed in writing.
    '';
    taxes = { role }: ''
      **${role}** understands that they are not employed by the **NixOS Foundation**, and that they have the sole responsibility to follow legal obligations with regard to this agreement according to their jurisdiction, such as taxes, social security, reporting, etc.
    '';
    invoicing = { role }: ''
      **${role}** will submit monthly invoices to **NixOS Foundation**, detailing the effort by the hour.
      Invoices shall be submitted within 30 calendar days of the billed work being done.
    '';
    invoiced-amount = _: ''
      The agreed-upon compensation is the total amount to be invoiced.
      If VAT is reverse charged, the invoiced amount must be reduced accordingly.
    '';
    no-subcontracting = _: ''
      Subcontracting the agreed-upon work is explicitly prohibited.
    '';
    payment-duties = { role }: ''
      The **NixOS Foundation** will transfer payment within 30 calendar days after receiving an invoice.
    '';
    availability = { role, supervisor }: ''
      If **${role}** is unable to keep to the agreed-upon schedule, or become temporarily or permanently unavailable for the purposes of this agreement, they will notify the **${supervisor}** immediately.

      In such a situation, **NixOS Foundation** has the right to suspend or terminate the contract.
      **NixOS Foundation** will inform **${role}** one week (seven days) in advance of its intent to suspend or terminate the contract.
      If **${role}** is able to fulfill their obligations within that period after all, **NixOS Foundation** shall still pay the due amount according to the regular procedure.
    '';
  };
}
