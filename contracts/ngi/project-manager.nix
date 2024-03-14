let
  ngi = import ./.;
  inherit (ngi) contracts;

in

{ name, address, hours, rate, time-frame }:
let
  role = "NGI Project Manager";
  duties = { role }: ''
    The mission for **${role}** is to help fulfil the **NixOS Foundation**’s **NGI0** program duties and furthering technical goals of the **NGI0** consortium, reducing administrative friction, and increasing visibility of work done.

    Tasks on behalf of NixOS Foundation include:
    - Gather requirements and priorities from stakeholders
    - Determine and communicate priorities, allocate budgets
    - Prepare contracts
    - Keep track of progress and spending
    - Compile and publish reports
    - Help connect corporate sponsors and program graduates
    - Organise a public outreach effort
    - Assist with various administrative tasks
  '';
  written-summaries = { role }: contracts.terms.written-summaries {
    inherit role;
    interval = "monthly";
  };
  availability = { role }: contracts.terms.availability {
    inherit role;
    supervisor = "NixOS Foundation";
  };
  public-statements = { role }: contracts.terms.public-statements { inherit role; optional = false; };
  compensation =
    let
      money = contracts.terms.compensation { inherit role hours rate; };
      time = contracts.terms.time-frame { inherit role time-frame; };
    in
    [ money time ];
  terms =
    let
      generic = contracts.terms;
    in
    map (t: t { inherit role; }) [
      duties
      written-summaries
      generic.invoicing
      generic.invoiced-amount
      generic.payment-duties
      availability
      generic.no-claims
      generic.taxes
      generic.license
      generic.code-of-conduct
      public-statements
      ngi.terms.acknowledgement
    ];
in
contracts.contract {
  contractor = { inherit name address role; };
  inherit compensation terms;
  definitions = with contracts.definitions; [ nix nixos-foundation ngi.definitions.ngi0 ];
}
