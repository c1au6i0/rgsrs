# Retrieve comprehensive GSRS data for a set of UNIIs

Convenience wrapper that calls
[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md),
[`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md),
and
[`gsrs_hierarchy()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_hierarchy.md)
in sequence and returns a named list containing all five data frames.
Each sub-function uses `with_graceful_exit` internally, so partial
failures return `NULL` for that element without aborting the whole call.

## Usage

``` r
gsrs_all(unii, verbose = TRUE, delay = 0.5)
```

## Arguments

- unii:

  Character vector of one or more UNII codes.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual lookups. Default `0.5`.

## Value

A named list with five elements:

- substance:

  Data frame from
  [`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md).

- names:

  Data frame from
  [`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md).

- codes:

  Data frame from
  [`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md).

- structure:

  Data frame from
  [`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md).

- hierarchy:

  Data frame from
  [`gsrs_hierarchy()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_hierarchy.md).

Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md),
[`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md),
[`gsrs_hierarchy()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_hierarchy.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_all("R16CO5Y76E")  # aspirin
#> ℹ Fetching substance for UNII: R16CO5Y76E ...
#> ℹ Fetching names for UNII: R16CO5Y76E ...
#> ℹ Retrieved 64 name record(s).
#> ℹ Fetching codes for UNII: R16CO5Y76E ...
#> ℹ Retrieved 85 code record(s).
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ℹ Retrieved structure for 1 substance(s).
#> ℹ Fetching hierarchy for UNII: R16CO5Y76E ...
#> ℹ Retrieved 38 hierarchy node(s).
  if (!is.null(out)) {
    print(out$substance)
    print(head(out$names))
    print(head(out$codes))
    print(out$structure[, c("smiles", "formula", "mwt", "inchi_key")])
    print(out$hierarchy[, c("depth", "type", "approval_id", "name")])
  }
#>                                   uuid approval_id preferred_name
#> 1 a05ec20c-8fe2-4e02-ba7f-df69e5e30248  R16CO5Y76E        Aspirin
#>   substance_class   status definition_type definition_level version
#> 1        chemical approved         PRIMARY         COMPLETE     119
#>                                                                                  names_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)/names
#>                                                                                  codes_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)/codes
#>                                                                                       self_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)?view=full
#>        date_retrieved      query
#> 1 2026-05-01 11:29:41 R16CO5Y76E
#>                              name                        std_name type
#> 1       2-(ACETYLOXY)BENZOIC ACID       2-(ACETYLOXY)BENZOIC ACID  sys
#> 2         2-ACETYLOXYBENZOIC ACID         2-ACETYLOXYBENZOIC ACID  sys
#> 3               ACETYL SALICYLATE               ACETYL SALICYLATE  sys
#> 4            ACETYLSALICYLIC ACID            ACETYLSALICYLIC ACID   of
#> 5   ACETYLSALICYLIC ACID (WHO-IP)   ACETYLSALICYLIC ACID (WHO-IP)   cn
#> 6 ACETYLSALICYLIC ACID [EMA EPAR] ACETYLSALICYLIC ACID [EMA EPAR]   cn
#>   preferred display_name languages  domains
#> 1     FALSE        FALSE        en         
#> 2     FALSE        FALSE        en         
#> 3     FALSE        FALSE        en         
#> 4      TRUE        FALSE        en cosmetic
#> 5     FALSE        FALSE        en         
#> 6     FALSE        FALSE        en         
#>                                   uuid      date_retrieved      query
#> 1 c7069333-892e-4828-97aa-6ea06434cb34 2026-05-01 11:29:42 R16CO5Y76E
#> 2 19144a23-5c43-4ad2-b894-761915330349 2026-05-01 11:29:42 R16CO5Y76E
#> 3 17796a92-7d19-41dd-8a1d-85f7fc2602ac 2026-05-01 11:29:42 R16CO5Y76E
#> 4 c5121134-4cd0-40ce-8d68-160951300713 2026-05-01 11:29:42 R16CO5Y76E
#> 5 48d89039-025b-4fe5-bd9a-c9a876c49ae6 2026-05-01 11:29:42 R16CO5Y76E
#> 6 31071e18-01f5-4fb8-9c99-336e1b4883e7 2026-05-01 11:29:42 R16CO5Y76E
#>   code_system          code    type
#> 1     WHO-ATC       C07FX02 PRIMARY
#> 2   DRUG BANK       DB00945 PRIMARY
#> 3 RS_ITEM_NUM       1044006 PRIMARY
#> 4         CFR 21 CFR 343.13 PRIMARY
#> 5         CFR 21 CFR 343.12 PRIMARY
#> 6    WHO-VATC      QN02BA51 PRIMARY
#>                                                                               url
#> 1             http://www.whocc.no/atc_ddd_index/?code=C07FX02&showdescription=yes
#> 2                                            http://www.drugbank.ca/drugs/DB00945
#> 3                                           https://store.usp.org/product/1044006
#> 4 http://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfCFR/CFRSearch.cfm?fr=343.13
#> 5 http://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfCFR/CFRSearch.cfm?fr=343.12
#> 6      http://www.whocc.no/atcvet/atcvet_index/?code=QN02BA51&showdescription=yes
#>                                                                                                                                                                                   comments
#> 1                        ATC|CARDIOVASCULAR SYSTEM|BETA BLOCKING AGENTS|BETA BLOCKING AGENTS, OTHER COMBINATIONS|Beta blocking agents, other combinations|sotalol and acetylsalicylic acid
#> 2                                                                                                                                                                                     <NA>
#> 3                                                                                                                                                                                     <NA>
#> 4  PART 343 -- INTERNAL ANALGESIC, ANTIPYRETIC, AND ANTIRHEUMATIC DRUG PRODUCTS FOR OVER-THE-COUNTER HUMAN USE|Subpart B--Active Ingredients|Sec. 343.13 Rheumatologic active ingredients.
#> 5 PART 343 -- INTERNAL ANALGESIC, ANTIPYRETIC, AND ANTIRHEUMATIC DRUG PRODUCTS FOR OVER-THE-COUNTER HUMAN USE|Subpart B--Active Ingredients|Sec. 343.12 Cardiovascular active ingredients.
#> 6                                                  VATC|ANALGESICS|OTHER ANALGESICS AND ANTIPYRETICS|Salicylic acid and derivatives|acetylsalicylic acid, combinations excl. psycholeptics
#>   is_classification                                 uuid      date_retrieved
#> 1              TRUE 02993f14-aa8c-b78d-df34-4d572f50698d 2026-05-01 11:29:42
#> 2             FALSE 08f6f535-d27d-44d2-b50f-57d838de41c1 2026-05-01 11:29:42
#> 3             FALSE 0a961196-b583-df05-b166-7a2f27fd8423 2026-05-01 11:29:42
#> 4              TRUE 0d10f32d-a67f-434b-9074-b3158112afad 2026-05-01 11:29:42
#> 5              TRUE 0f4c868d-c8e4-462b-ab6a-6cd9dc5dd9a2 2026-05-01 11:29:42
#> 6              TRUE 155f7e8e-14f8-4352-ab80-f146f2f7ca36 2026-05-01 11:29:42
#>        query
#> 1 R16CO5Y76E
#> 2 R16CO5Y76E
#> 3 R16CO5Y76E
#> 4 R16CO5Y76E
#> 5 R16CO5Y76E
#> 6 R16CO5Y76E
#>                  smiles formula      mwt                   inchi_key
#> 1 CC(=O)Oc1ccccc1C(=O)O  C9H8O4 180.1578 BSYNRYMUTXBXSQ-UHFFFAOYSA-N
#>    depth                        type approval_id
#> 1      0                        ROOT  R16CO5Y76E
#> 2      1 HAS ACTIVE MOIETY:"Aspirin"  N667F17JP1
#> 3      1 HAS ACTIVE MOIETY:"Aspirin"  WOD7W0DGZS
#> 4      1 HAS ACTIVE MOIETY:"Aspirin"  5DR11472UI
#> 5      1 HAS ACTIVE MOIETY:"Aspirin"  E33TS05V6B
#> 6      1 HAS ACTIVE MOIETY:"Aspirin"  73J0P7720Y
#> 7      1 HAS ACTIVE MOIETY:"Aspirin"  NK259942HJ
#> 8      1 HAS ACTIVE MOIETY:"Aspirin"  JKW59XM343
#> 9      2          IS SALT/SOLVATE OF  J0TQX5LV1L
#> 10     1 HAS ACTIVE MOIETY:"Aspirin"  XAN4V337CI
#> 11     1 HAS ACTIVE MOIETY:"Aspirin"  VX19C5613T
#> 12     1 HAS ACTIVE MOIETY:"Aspirin"  4FES8WRA60
#> 13     1 HAS ACTIVE MOIETY:"Aspirin"  6QT214X4XU
#> 14     1 HAS ACTIVE MOIETY:"Aspirin"  2JJ274J145
#> 15     1 HAS ACTIVE MOIETY:"Aspirin"  4995924SMK
#> 16     1 HAS ACTIVE MOIETY:"Aspirin"  R16CO5Y76E
#> 17     1 HAS ACTIVE MOIETY:"Aspirin"  J0TQX5LV1L
#> 18     1          IS SALT/SOLVATE OF  WOD7W0DGZS
#> 19     1          IS SALT/SOLVATE OF  6QT214X4XU
#> 20     1          IS SALT/SOLVATE OF  5DR11472UI
#> 21     1          IS SALT/SOLVATE OF  NK259942HJ
#> 22     1          IS SALT/SOLVATE OF  6QT214X4XU
#> 23     1          IS SALT/SOLVATE OF  4995924SMK
#> 24     1          IS SALT/SOLVATE OF  N667F17JP1
#> 25     1          IS SALT/SOLVATE OF  XAN4V337CI
#> 26     1          IS SALT/SOLVATE OF  73J0P7720Y
#> 27     1          IS SALT/SOLVATE OF  4995924SMK
#> 28     1          IS SALT/SOLVATE OF  N667F17JP1
#> 29     1          IS SALT/SOLVATE OF  E33TS05V6B
#> 30     1          IS SALT/SOLVATE OF  E62HT5S2E9
#> 31     1          IS SALT/SOLVATE OF  89R59534MK
#> 32     1          IS SALT/SOLVATE OF  E62HT5S2E9
#> 33     1          IS SALT/SOLVATE OF  73J0P7720Y
#> 34     1          IS SALT/SOLVATE OF  NK259942HJ
#> 35     1          IS SALT/SOLVATE OF  E33TS05V6B
#> 36     1          IS SALT/SOLVATE OF  8649Y4P3PA
#> 37     1          IS SALT/SOLVATE OF  ED7L5F608H
#> 38     1          IS SALT/SOLVATE OF  ED7L5F608H
#>                               name
#> 1                          Aspirin
#> 2              Carbaspirin Calcium
#> 3                  Aspirin calcium
#> 4                   ASPIRIN COPPER
#> 5                 ASPIRIN ALUMINUM
#> 6                      CARBASPIRIN
#> 7          ASPIRIN GLYCINE CALCIUM
#> 8                Aspirin Trelamine
#> 9  Aspirin Trelamine Hydrochloride
#> 10                  Aspirin lysine
#> 11          ETHYL ACETYLSALICYLATE
#> 12                ASPIRIN ARGININE
#> 13                       ALOXIPRIN
#> 14               Aspirin DL-lysine
#> 15               ASPIRIN MAGNESIUM
#> 16                         Aspirin
#> 17 Aspirin Trelamine Hydrochloride
#> 18                 Aspirin calcium
#> 19                       ALOXIPRIN
#> 20                  ASPIRIN COPPER
#> 21         ASPIRIN GLYCINE CALCIUM
#> 22                       ALOXIPRIN
#> 23               ASPIRIN MAGNESIUM
#> 24             Carbaspirin Calcium
#> 25                  Aspirin lysine
#> 26                     CARBASPIRIN
#> 27               ASPIRIN MAGNESIUM
#> 28             Carbaspirin Calcium
#> 29                ASPIRIN ALUMINUM
#> 30                  Aspirin sodium
#> 31        Lithium acetylsalicylate
#> 32                  Aspirin sodium
#> 33                     CARBASPIRIN
#> 34         ASPIRIN GLYCINE CALCIUM
#> 35                ASPIRIN ALUMINUM
#> 36                    Zinc Aspirin
#> 37       ALUMINUM ACETYLSALICYLATE
#> 38       ALUMINUM ACETYLSALICYLATE
# }
```
