# Retrieve the relationship hierarchy for GSRS substances

For each supplied UNII, calls
`GET /api/v1/substances(<UNII>)/@hierarchy` and returns the flat
parent/child relationship tree as a tidy data frame. This is useful for
navigating relationships such as salt forms to free base, active
metabolites, or component substances.

## Usage

``` r
gsrs_hierarchy(unii, verbose = TRUE, delay = 0.5)
```

## Arguments

- unii:

  Character vector of one or more UNII codes.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual lookups when `unii` has
  multiple entries. Default `0.5`.

## Value

A data frame with columns:

- node_id:

  Node identifier within the hierarchy tree (string index).

- parent_id:

  Parent node identifier (`"#"` for root nodes).

- depth:

  Depth in the tree (0 = root).

- type:

  Node type (e.g., `"ROOT"`, `"ACTIVE MOIETY"`, `"SALT/SOLVATE"`).

- text:

  Human-readable label including UNII and name.

- expandable:

  Logical; `TRUE` if node has children.

- approval_id:

  UNII of the substance at this node.

- name:

  Preferred name at this node.

- ref_uuid:

  Internal GSRS UUID of the related substance.

- substance_class:

  Substance class at this node.

- deprecated:

  Logical; `TRUE` if the node substance is deprecated.

- date_retrieved:

  Date the response was received.

- query:

  The UNII supplied by the caller.

Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_all()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_all.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_hierarchy("R16CO5Y76E")  # aspirin
#> ℹ Fetching hierarchy for UNII: R16CO5Y76E ...
#> ℹ Retrieved 38 hierarchy node(s).
  if (!is.null(out)) print(out[, c("depth", "type", "approval_id", "name")])
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
