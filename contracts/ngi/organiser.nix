let
  ngi = import ./.;
  inherit (ngi) contracts;
in

{ name, address, hours, rate, time-frame }:
let
  role = "Project Organiser";
  duties = { role }: ''
    **${role}** is responsible for executing the organisational aspects of the **Summer of Nix** 2024 program, including in particular:
    - Issue a public call for applications
    - Process applications and select **Facilitators**
    - Instruct **Facilitators** and **Participants** on mob pramming
    - Help connect corporate sponsors and program graduates
    - Assistist the **NGI project manager** with administrative tasks
  '';
  priorities = { role }: contracts.terms.priorities {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  progress-reviews = { role }: contracts.terms.progress-reviews {
    inherit role;
    interval = "every two weeks";
    supervisor = "NGI Project Manager";
  };
  availability = { role }: contracts.terms.availability {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  compensation =
    let
      money = contracts.terms.compensation { inherit role hours rate; };
      time = contracts.time-frame { inherit role time-frame; };
    in
    [ money time ];
  terms =
    let
      generic = contracts.terms;
    in
    map (t: t { inherit role; }) [
      ngi.terms.purpose
      duties
      priorities
      progress-reviews
      ngi.terms.time-sheets
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
  definitions = ngi.summer-of-nix-definitions;
}
