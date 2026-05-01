# Look up UNII codes for substance names

For each supplied name, queries GSRS using `root_names:<name>` and
returns the best-matching UNII together with the preferred substance
name and substance class. This is useful for converting common or
systematic names to the canonical FDA UNII identifier.

## Usage

``` r
gsrs_unii_from_name(names, top = 1L, verbose = TRUE, delay = 0.5)
```

## Arguments

- names:

  Character vector of substance names to resolve.

- top:

  Integer. Maximum number of candidate records to consider per name
  query. Default `1` returns only the top hit. Increase to inspect
  multiple candidates.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual lookups. Default `0.5`.

## Value

A data frame with columns:

- unii:

  The UNII / approval ID of the matched substance.

- preferred_name:

  Preferred display name in GSRS.

- substance_class:

  Substance class (e.g., `"chemical"`).

- status:

  Record status.

- uuid:

  Internal GSRS UUID.

- date_retrieved:

  Date the response was received.

- query:

  The name supplied by the caller.

Unresolved names produce a row of `NA`s with `query` set. Returns `NULL`
on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_unii_from_name(c("aspirin", "ibuprofen"))
#> ℹ Resolving name to UNII: aspirin ...
#> ℹ Resolving name to UNII: ibuprofen ...
  if (!is.null(out)) print(out)
#>         unii   preferred_name substance_class   status
#> 1 R16CO5Y76E          Aspirin        chemical approved
#> 2 RM1CE97Z4N IBUPROFEN SODIUM        chemical approved
#>                                   uuid      date_retrieved     query
#> 1 a05ec20c-8fe2-4e02-ba7f-df69e5e30248 2026-05-01 11:30:24   aspirin
#> 2 09826010-6401-4df0-8d1d-7be270a26512 2026-05-01 11:30:24 ibuprofen
# }
```
