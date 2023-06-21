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

  contract = { contractor, definitions, terms }: { number, foundation }: ''
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
    purpose = { role }: ''
      The purpose of this engagement is to further the technical goals of the **NGI0** consortium according to the responsibilities of **NixOS Foundation**.
    '';
    time-frame = { role, time-frame }: ''
      **${role}** will perform the agreed-upon work within the **time frame of ${time-frame}**.
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
      If and where statements in this Code of Conduct are in contradiction with one or more statements in the text of this memorandum, the statement or statements in the memorandum text will prevail.
    '';
    public-statements = { role, optional ? true }: ''
      **NixOS Foundation** and **${role}** may issue one or more individual or joint public statements regarding this agreement or work results. ${if optional then ''
    This is optional and requires explicit agreement by **${role}**.
    '' else ""}'';
    hours-and-rate = { role, hours, rate }: ''
      **${role}** will work a total of ${toString hours} hours for **NixOS Foundation**, for an hourly rate of ${toString rate} EUR.
    '';
    total-amount = { role, amount }: ''
      **${role}** will receive a total of ${toString amount} EUR as compensation.
    '';
    no-claims = { role }: ''
      Outside of this agreed-upon scope, there cannot be any financial claims towards either **NixOS Foundation** or **${role}**, unless previously mutually agreed in writing.
    '';
    invoicing = { role }: ''
      **${role}** will submit monthly invoices to **NixOS Foundation**, detailing the effort by the hour.
      Invoices shall be submitted within 30 calendar days of the billed work being done.
    '';
    bulk-invoicing = { role }: ''
      **${role}** can submit a single invoice with the total amount, or monthly invoices with partial amounts, to the **NixOS Foundation**.
      Invoices shall be submitted within 30 calendar days after the specified **time frame**.
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

  documentation = {
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
        time-frame = "the Nix Documentation Project from 2023-06-01 to 2023-08-31";
        inherit role;
      };
    };

    roles = let
      documentation-definitions = with definitions; with documentation.definitions; [
        nix
        nixos-foundation
        project
        editorial-lead
        nix-expert
        contributor
        project-organiser
      ];
      in {
      editorial-lead = { name, address, hours, rate }:
        let
          role = "Editorial Lead";
          compensation = { role }: terms.hours-and-rate { inherit role hours rate; };
          role-terms = with terms; with documentation.terms; map (t: t { inherit role; }) [
            editorial-lead-duties
            time-frame
            priorities
            progress-reviews
            written-summaries
            license
            code-of-conduct
            public-statements
            compensation
            no-claims
            terms.invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = documentation-definitions;
          terms = role-terms;
        };
      nix-expert = { name, address, hours, rate }:
        let
          role = "Nix Expert";
          compensation = { role }: terms.hours-and-rate { inherit role hours rate; };
          role-terms = with terms; with documentation.terms; map (t: t { inherit role; }) [
            nix-expert-duties
            priorities
            time-frame
            progress-reviews
            reporting-assistance
            license
            code-of-conduct
            public-statements
            compensation
            no-claims
            terms.invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = documentation-definitions;
          terms = role-terms;
        };
      contributor = { name, address, hours, rate }:
        let
          role = "Contributor";
          compensation = { role }: terms.hours-and-rate { inherit role hours rate; };
          role-terms = with terms; with documentation.terms; map (t: t { inherit role; }) [
            contributor-duties
            time-frame
            reporting-assistance
            license
            code-of-conduct
            compensation
            no-claims
            terms.bulk-invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = documentation-definitions;
          terms = role-terms;
        };
      volunteer = { name, address, amount }:
        let
          role = "Volunteer";
          compensation = { role }: terms.total-amount { inherit role amount; };
          role-terms = with terms; with documentation.terms; map (t: t { inherit role; }) [
            volunteer-duties
            time-frame
            reporting-assistance
            license
            code-of-conduct
            compensation
            no-claims
            terms.bulk-invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = documentation-definitions;
          terms = role-terms;
        };
      };
    };

  # definitions and contract terms specific to Summer of Nix
  summer-of-nix = {

    definitions = {
      ngi0 = ''
        **NGI0** is a consortium of not-for-profit organisations that has received funding through the Next Generation Internet initiative within the European Commission's Horizon Europe program coordinated by the DG CNECT.
        **NGI0** aims to contribute to an open internet that is resilient, trustworthy, and sustainable, by
        * Providing uniform, convenient access to innovative technologies produced in the research and development efforts it is funding.
        * Encouraging robust software engineering practices such as continuous integration, testing, and reproducible builds.
        The **NixOS Foundation** is part of the **NGI0** consortium, and responsible for supporting projects funded by **NGI0** with reproducible builds and packaging with Nix and related tooling.
      '';
      summer-of-nix = ''
        The **Summer of Nix** is a program organized by the **NixOS Foundation** in collaboration with the **NLnet Foundation** to package applications relevant to **NGI0**, as well as educate and train a new generation of software professionals.
      '';
      participant = ''
        A **Participant** takes part in the **Summer of Nix** program, and will perform packaging and related activities for **NGI0** and the Next Generation Internet initiative.
      '';
      facilitator = ''
        A **Facilitator** assembles a team (a mob) and facilitates the mob programming format with **Participants** during **Summer of Nix**.
      '';
    };

    terms = {
      time-frame = { role }: terms.time-frame {
        time-frame = "the Summer of Nix program from 2023-07-17 to 2023-10-13";
        inherit role;
      };
      facilitator-duties = { role }: ''
        **${role}** will take applications and assemble a team (a mob) of four **Participants** and themselves.
        **${role}** will set up, schedule, and run 160 hours of mob programming sessions according to agreed-upon goals and priorities.
        **${role}** is responsible that their mob regularly provides brief written overviews of work done, for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
      '';
      participant-duties = { role }: ''
        **${role}** will participate in 160 hours of mob sessions led by a **Facilitator** according to an agreed-upon schedule, and work according to the mob's goals and priorities.
        **${role}** will collaborate on regularly providing brief written overviews of their mob's work results for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
      '';
      project-organiser-duties = { role }: ''
        The purpose of this engagement is to prepare and run the **Summer of Nix** 2023 program on behalf of the **NixOS Foundation**, in order to further the technical goals of the **NGI0** consortium.

        **${role}** is responsible for executing all organisational aspects of the program, including in particular:
        - Gathering requirements and priorities from the **NixOS Foundation** and their associates
        - Issuing a public call for applications
        - Taking applications and selecting **Facilitators**
        - Instructing **Facilitators** and **Participants**, and communicating goals and priorities for their mobs' work
        - Organising an online event to connect corporate sponsors and program participants
        - Compiling the reports on work done by the mobs
        - Issuing a final program report
      '';
      technical-means = { role }: ''
        **${role}** is responsible to ensure that the technical means required for their effective participation in the mob sessions are available and operational.
      '';
      acknowledgement = { role }: ''
        **${role}** is encouraged to publicly acknowledge the **NixOS Foundation**'s and European Commission's support and contribution where possible.
        For example: on websites, in promotional materials or presentations, and in source code.
      '';
    };

    roles = let
      summer-of-nix-definitions = with definitions; with summer-of-nix.definitions; [
        nix
        nixos-foundation
        ngi0
        summer-of-nix.definitions.summer-of-nix
        participant
        facilitator
        project-organiser
      ];
      in {
      participant = { name, address, amount }:
        let
          role = "Participant";
          compensation = ({ role }: terms.total-amount { inherit role amount; });
          role-terms = with terms; with summer-of-nix.terms; map (t: t { inherit role; }) [
            purpose
            time-frame
            participant-duties
            technical-means
            priorities
            license
            code-of-conduct
            public-statements
            acknowledgement
            compensation
            no-claims
            terms.bulk-invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = summer-of-nix-definitions;
          terms = role-terms;
        };
      facilitator = { name, address, amount }:
        let
          role = "Facilitator";
          compensation = ({ role }: terms.total-amount { inherit role amount; });
          role-terms = with terms; with summer-of-nix.terms; map (t: t { inherit role; }) [
            purpose
            time-frame
            facilitator-duties
            technical-means
            priorities
            progress-reviews
            written-summaries
            license
            code-of-conduct
            public-statements
            acknowledgement
            compensation
            no-claims
            terms.bulk-invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = summer-of-nix-definitions;
          terms = role-terms;
        };
      developer = { name, address, hours, rate }:
        let
          role = "Developer";
          compensation = { role }: terms.hours-and-rate { inherit role hours rate; };
          developer = ''
            A **Developer** is an independent software expert and a respected member of the Nix community who has expressed an interest in supporting open source R&D efforts that are funded by **NGI0**.
          '';
          developer-duties = { role }: ''
             **${role}** assumes the moral and operational responsibility for the software projects they engage with.
             For the duration of this engagement, **${role}** is said to be a maintainer for these projects.
             This encompasses making, documenting, and implementing technical decisions (collaboratively where appropriate), being available and responsive to other maintainers of the projects, and what is otherwise deemed customary in maintaining open source software.
          '';
          ngi-definitions = with definitions; with summer-of-nix.definitions; [
            nix
            nixos-foundation
            ngi0
            developer
            project-organiser
          ];
          role-terms = with terms; with summer-of-nix.terms; map (t: t { inherit role; }) [
            purpose
            priorities
            progress-reviews
            written-summaries
            developer-duties
            license
            code-of-conduct
            public-statements
            acknowledgement
            compensation
            no-claims
            terms.invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = ngi-definitions;
          terms = role-terms;
        };
      organiser = { name, address, amount }:
        let
          role = "Project Organiser";
          compensation = ({ role }: terms.total-amount { inherit role amount; });
          public-statements = { role }: terms.public-statements { inherit role; optional = false; };
          role-terms = with terms; with summer-of-nix.terms; map (t: t { inherit role; }) [
            project-organiser-duties
            license
            code-of-conduct
            public-statements
            acknowledgement
            compensation
            no-claims
            terms.bulk-invoicing
            payment-duties
            availability
          ];
        in contract {
          contractor = { inherit name address role; };
          definitions = summer-of-nix-definitions;
          terms = role-terms;
        };
    };
  };
}
