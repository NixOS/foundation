let
  ngi = import ./.;
  inherit (ngi) pdf;
in

{ name, address, hours, rate, time-frame }:
let
  role = "Developer";
  duties = { role }: ''
    **${role}** assumes the moral and operational responsibility for the software projects they engage with.
    For the duration of this engagement, **${role}** is said to be a maintainer for these projects.
    This encompasses making, documenting, and implementing technical decisions (collaboratively where appropriate), being available and responsive to other maintainers of the projects, and what is otherwise deemed customary in maintaining open source software.
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
      money = contracts.terms.compensation { inherit role hours rate; };
      time = contracts.terms-time-frame { inherit role time-frame; };
    in
    [ money time ];
  terms =
    let
      generic = contracts.terms;
    in
    map (t: t { inherit role; }) [
      ngi.purpose
      duties
      priorities
      progress-reviews
      ngi.time-sheets
      generic.invoicing
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
  definitions =
    let
      generic = contracts.definitions;
    in
    with ngi.definitions; [
      generic.nix
      generic.nixos-foundation
      ngi0
      project-manager
    ];
}
