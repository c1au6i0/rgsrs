# Retrieve all names (synonyms) for GSRS substances

For each supplied UNII, calls `GET /api/v1/substances(<UNII>)/names` and
returns every registered name record as a tidy data frame row.

## Usage

``` r
gsrs_names(unii, verbose = TRUE, delay = 0.5)
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

- name:

  The name string.

- std_name:

  Standardised (uppercased) name.

- type:

  Name type code (e.g., `"bn"` brand name, `"cn"` common name, `"sys"`
  systematic name, `"of"` official name).

- preferred:

  Logical; `TRUE` when this is the preferred name.

- display_name:

  Logical; `TRUE` when this name is shown by default.

- languages:

  Semicolon-separated language codes.

- domains:

  Semicolon-separated domain tags.

- uuid:

  Internal GSRS UUID for the name record.

- date_retrieved:

  Date the response was received.

- query:

  The UNII supplied by the caller.

Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md),
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_names("R16CO5Y76E")  # aspirin
#> ℹ Fetching names for UNII: R16CO5Y76E ...
#> ℹ Retrieved 64 name record(s).
  if (!is.null(out)) print(head(out))
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
#> 1 c7069333-892e-4828-97aa-6ea06434cb34 2026-05-01 01:57:50 R16CO5Y76E
#> 2 19144a23-5c43-4ad2-b894-761915330349 2026-05-01 01:57:50 R16CO5Y76E
#> 3 17796a92-7d19-41dd-8a1d-85f7fc2602ac 2026-05-01 01:57:50 R16CO5Y76E
#> 4 c5121134-4cd0-40ce-8d68-160951300713 2026-05-01 01:57:50 R16CO5Y76E
#> 5 48d89039-025b-4fe5-bd9a-c9a876c49ae6 2026-05-01 01:57:50 R16CO5Y76E
#> 6 31071e18-01f5-4fb8-9c99-336e1b4883e7 2026-05-01 01:57:50 R16CO5Y76E
# }
```
