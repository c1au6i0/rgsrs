# Browse all substance records in GSRS

Retrieves a paginated list of all substance records from
`GET /api/v1/substances`. Useful for bulk workflows or building a local
catalogue. Use `top` and `skip` to page through the ~170,000 available
records, or set `top = Inf` to fetch all (slow — use with care).

## Usage

``` r
gsrs_browse(top = 10L, skip = 0L, verbose = TRUE, delay = 0.5)
```

## Arguments

- top:

  Integer. Maximum number of records to return per request. Default
  `10`. Set to `NULL` or `Inf` to fetch all records (paginates
  automatically; large result sets will be slow).

- skip:

  Integer. Number of records to skip (offset). Default `0`.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between paginated requests when `top = Inf`.
  Default `0.5`.

## Value

A data frame with the same columns as
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md).
Returns `NULL` on error (with a warning).

## See also

[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  # Fetch the first 5 substance records
  out <- gsrs_browse(top = 5, verbose = FALSE)
  if (!is.null(out)) print(out[, c("approval_id", "preferred_name",
                                    "substance_class")])
#>   approval_id
#> 1  B71UA545DE
#> 2  5Y3NBK9IS7
#> 3  535OQ68DO6
#> 4  76RAN2WN7T
#> 5  12XH8EKL2A
#>                                                                                                                         preferred_name
#> 1                                                                                                                 CYNARA SCOLYMUS LEAF
#> 2                                                                                                         PHENANTHRO(4,5-BCD)THIOPHENE
#> 3                                                                                                                  GARCINIA COWA LATEX
#> 4 Ethyl (6bR,10aS)-2,3,6b,9,10,10a-hexahydro-3-methyl-1H-pyrido[3′,4′:4,5]pyrrolo[1,2,3-de]quinoxaline-8(7H)-carboxylate hydrochloride
#> 5                                                                                                                             MGS-0210
#>       substance_class
#> 1 structurallyDiverse
#> 2            chemical
#> 3 structurallyDiverse
#> 4            chemical
#> 5            chemical
# }
```
