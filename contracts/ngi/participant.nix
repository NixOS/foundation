let
  ngi = import ./.;
  inherit (ngi) contracts;
in

{ name, address, amount }:
let
  role = "Participant";
  duties = { role }: ''
    **${role}** will participate in 160 hours of mob sessions led by a **Facilitator** according to an agreed-upon schedule, and work according to the mob's goals and priorities.

    **${role}** will collaborate on regularly providing brief written overviews of their mob's work results for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
  '';
  priorities = { role }: contracts.terms.priorities { inherit role; supervisor = "NGI Project Manager"; };
  availability = { role }: contracts.terms.availability {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  compensation =
    let
      money = contracts.terms.compensation { inherit role amount; };
      time = contracts.time-frame { inherit role; time-frame = "from 2024-06-01 to 2024-10-31"; };
    in
    [ money time ];
  terms =
    let
      generic = contracts.terms;
    in
    map (t: t { inherit role; }) [
      ngi.terms.purpose
      duties
      ngi.terms.technical-means
      priorities
      ngi.terms.time-sheets
      ngi.terms.invoicing
      generic.invoiced-amount
      generic.payment-duties
      availability
      generic.no-subcontracting
      generic.no-claims
      generic.taxes
      generic.license
      generic.privacy
      generic.code-of-conduct
      generic.public-statements
      ngi.terms.acknowledgement
    ];
in
contracts.contract {
  contractor = { inherit name address role; };
  inherit compensation terms;
  definitions = ngi.summer-of-nix-definitions;
}
