/*
Contract templates for the Documentation Project

Example:

Run `nix-build contrat.nix -A 2023-01 -o 2023-01.pdf` on the following file.

```nix
# contract.nix
let
  contract = import ./summer-of.nix;
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
  "2023-01" = contract.editorial-lead {
    name = "John Default";
    address = ''
      Fakestreet 123
      Springfield
      USA
    '';
    hours = 100;
    rate = 50;
  };
}
```
*/
let
  contracts = import ./.;

  definitions = {
    project = ''
      The **Nix documentation project** is a focused effort to improve the state of documentation in the Nix ecosystem.
      It aims to reduce onboarding time onboarding and improve the learning experience for new Nix users.
      The project's goal is to design a learning journey (curriculum) ranging from the first encounter with Nix to mastering the skills needed to leverage common use cases.
    '';
    editorial-lead = ''
      The **Editorial lead** is a didactics and communication expert responsible for the overall project and its success.
      The role's focus is to facilitate or carry out all activities necessary to reach the project's objectives.
    '';
    nix-expert = ''
      The **Nix Expert** is an experienced Nix contributor, who shall be available for answering technical questions concerning Nix specifics to everyone involved in the **Nix documentation project**.
      Their main concern is guiding the curriculum design, and introducing project participants to the Nix ecosystem's particularities.
    '';
    contributor = ''
      A **Contributor** supports the **Editorial Lead** with research, writing, and technical tasks.
      '';
  };

  terms = {
    editorial-lead-duties = { role }: ''
      **${role}**, with assistance by the **Nix Expert** and **Contributors**, will
      - Develop a curriculum draft
      - Categorise existing documentation materials according to the Diátaxis framework, and arrange them in a meaningful order emerging from the curriculum.
      - Break down tasks and prepare workflows for contributors implementing the curriculum
      - Link or migrate existing documentation into a central location
      - Prepare and publish a call for contributors

      **${role}** can delegate to the **Nix Expert** or **Contributors** as needed.
    '';
    nix-expert-duties = { role }: ''
      **${role}** will support the **Editorial Lead** in all aspects of this project pertaining to the Nix ecosystem and software development as needed.
    '';
    contributor-duties = { role }: ''
      **${role}** will support the **Editorial Lead** by fulfilling assigned research, writing, or software development tasks as needed.
    '';
    volunteer-duties = { role }: ''
      **${role}** will support the **Editorial Lead** by fulfilling assigned research, writing, or software development tasks as needed.
      **${role}** will commit 5 hours of effort per week within the project's time frame, on their own schedule.
    '';
    reporting-assistance = { role }: ''
      **${role}** will collaborate on regularly providing brief written overviews of work done on the project for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
    '';
    time-frame = { role }: terms.time-frame {
      time-frame = "of the Nix Documentation Project from 2023-06-01 to 2023-08-31";
      inherit role;
    };
    invoicing = { role }: ''
      **${role}** will a single invoice with the total amount to the **NixOS Foundation**.
      Invoices shall be submitted within 30 calendar days after the specified **time frame**.
    '';
  };

  documentation-definitions =
    with contracts.definitions;
    with definitions;
    [
      nix
      nixos-foundation
      project
      editorial-lead
      nix-expert
      contributor
      project-organiser
    ];
in {
  # pass through the underlying rendering mechanism
  inherit (contracts) pdf;

  editorial-lead = { name, address, hours, rate }:
    let
      role = "Editorial Lead";
      compensation = let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
        in [
          hours-and-rate
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        editorial-lead-duties
        priorities
        progress-reviews
        written-summaries
        license
        code-of-conduct
        public-statements
        no-claims
        invoicing
        invoiced-amount
        payment-duties
        availability
      ];
    in contracts.contract {
      contractor = { inherit name address role; };
      definitions = documentation-definitions;
      terms = role-terms;
      inherit compensation;
    };

  nix-expert = { name, address, hours, rate }:
    let
      role = "Nix Expert";
      compensation = let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
        in [
          hours-and-rate
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        nix-expert-duties
        priorities
        progress-reviews
        reporting-assistance
        license
        code-of-conduct
        public-statements
        no-claims
        invoicing
        invoiced-amount
        payment-duties
        availability
      ];
    in contracts.contract {
      contractor = { inherit name address role; };
      definitions = documentation-definitions;
      terms = role-terms;
      inherit compensation;
    };

  contributor = { name, address, hours, rate }:
    let
      role = "Contributor";
      compensation = let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
        in [
          hours-and-rate
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        contributor-duties
        reporting-assistance
        license
        code-of-conduct
        no-claims
        terms.invoicing
        invoiced-amount
        payment-duties
        availability
      ];
    in contracts.contract {
      contractor = { inherit name address role; };
      definitions = documentation-definitions;
      terms = role-terms;
      inherit compensation;
    };

  volunteer = { name, address, amount }:
    let
      role = "Volunteer";
      compensation = let
          total-amount = contracts.terms.total-amount { inherit role amount; };
        in [
          total-amount
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        volunteer-duties
        reporting-assistance
        license
        code-of-conduct
        no-claims
        terms.invoicing
        invoiced-amount
        payment-duties
        availability
      ];
    in contracts.contract {
      contractor = { inherit name address role; };
      definitions = documentation-definitions;
      terms = role-terms;
      inherit compensation;
    };
  };
}
