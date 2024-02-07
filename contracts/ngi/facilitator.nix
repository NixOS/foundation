let
  ngi = import ./.;
  inherit (ngi) contracts;
in

{ name, address, amount }:
let
  role = "Facilitator";
  duties = { role }: ''
    **${role}** will take applications and assemble a team (a mob) of four **Participants** and themselves.

    **${role}** will set up, schedule, and run 160 hours of mob programming sessions according to agreed-upon goals and priorities.

    **${role}** is responsible that their mob regularly provides brief written overviews of work done, for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
  '';
  priorities = { role }: contracts.terms.priorities {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  availability = { role }: contracts.terms.availability {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  progress-reviews = { role }: contracts.terms.progress-reviews {
    inherit role;
    interval = "weekly";
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
      progress-reviews
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
