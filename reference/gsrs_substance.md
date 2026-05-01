# Fetch a GSRS substance record by UNII

Retrieves the top-level metadata for a single substance identified by
its UNII (Unique Ingredient Identifier / approval ID). Internally this
performs a filtered search using `root_approvalID:<unii>`.

## Usage

``` r
gsrs_substance(unii, verbose = TRUE, delay = 0.5)
```

## Arguments

- unii:

  Character vector of one or more UNII codes (e.g., `"R16CO5Y76E"` for
  aspirin).

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual lookups when `unii` has
  multiple entries. Default `0.5`.

## Value

A data frame with the same columns as
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
with one row per input UNII. Rows for unrecognised UNIIs will contain
`NA` except for the `query` column (which is always set to the input
UNII). Returns `NULL` on error (with a warning).

## See also

[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_substance("R16CO5Y76E")  # aspirin
#> ℹ Fetching substance for UNII: R16CO5Y76E ...
  if (!is.null(out)) print(out)
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
#> 1 2026-05-01 01:58:02 R16CO5Y76E
# }
```
