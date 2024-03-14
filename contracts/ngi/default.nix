/*
  Contract templates for NGI / Summer of Nix
*/
rec
{
  contracts = import ../.;
  definitions = {
    ngi0 = ''
      **NGI0** is a consortium of not-for-profit organisations that has received funding through the Next Generation Internet initiative within the European Commission's Horizon Europe program coordinated by the DG CNECT.
      **NGI0** aims to contribute to an open internet that is resilient, trustworthy, and sustainable, by
      * Providing uniform, convenient access to innovative technologies produced in the research and development efforts it is funding.
      * Encouraging robust software engineering practices such as continuous integration, testing, and reproducible builds.
      The **NixOS Foundation** is part of the **NGI0** consortium, and responsible for supporting projects funded by **NGI0** with reproducible builds and packaging with Nix and related tooling.
    '';
    summer-of-nix = ''
      **Summer of Nix** is a program organised by the **NixOS Foundation** in collaboration with the **NLnet Foundation** to package applications relevant to **NGI0**, and train a new generation of software professionals.
    '';
    participant = ''
      A **Participant** takes part in the **Summer of Nix** program, and will perform software packaging and related activities for **NGI0** and the Next Generation Internet initiative.
    '';
    facilitator = ''
      A **Facilitator** assembles a team (a mob) and facilitates the mob programming format with **Participants** during **Summer of Nix**.
    '';
    project-manager = ''
      The **NGI Project Manager** is a representative of **NixOS Foundation** authorised to set goals and priorities for contractors within the scope of their engagement.
    '';
  };
  terms = {
    purpose = { role }: ''
      The purpose of this engagement is to further the technical goals of the **NGI0** consortium according to the responsibilities of **NixOS Foundation**.
    '';
    technical-means = { role }: ''
      **${role}** is responsible to ensure that the technical means required for their effective participation in mob programming sessions are available and operational.
    '';
    time-sheets = { role }: ''
      **${role}** will submit monthly time sheets to the **NixOS Foundation**, detailing the effort by the hour.
    '';
    invoicing = { role }: ''
      Compensation will be paid out in two parts, each after completing half of the agreed-upon work hours.
      Invoices shall be submitted to the **NixOS Foundation** within 30 calendar days of the billed work being done.

      Payment is conditional on satisfactory participation in the program, subject to assessment of the **NGI Project Manager**.
      In case of a dispute, parties may appeal to the **NixOS Foundation**.
    '';
    acknowledgement = { role }: ''
      **${role}** is encouraged to publicly acknowledge the **NixOS Foundation**'s and European Commission's support and contribution where possible.
      For example: on websites, in promotional materials or presentations, and in source code.
    '';
  };
  summer-of-nix-definitions =
    let
      generic = contracts.definitions;
    in
    with definitions; [
      generic.nix
      generic.nixos-foundation
      ngi0
      summer-of-nix
      participant
      facilitator
      project-manager
    ];
}
