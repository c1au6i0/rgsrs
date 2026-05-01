# Retrieve controlled vocabulary terms from GSRS

Fetches all (or a page of) controlled vocabulary entries from
`GET /api/v1/vocabularies`. The result is one row per vocabulary term,
with the parent domain and type attached to every row. This is useful
for understanding allowed values for fields such as name type, substance
class, relationship type, code system, and more.

## Usage

``` r
gsrs_vocabularies(top = NULL, verbose = TRUE, delay = 0.5)
```

## Arguments

- top:

  Integer. Maximum number of vocabulary *domains* to return per request.
  Default `NULL` fetches all domains (paginates automatically).

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between paginated requests. Default `0.5`.

## Value

A data frame with columns:

- domain:

  Vocabulary domain name (e.g., `"NAME_TYPE"`, `"SUBSTANCE_CLASS"`,
  `"RELATIONSHIP_TYPE"`).

- term_type:

  Vocabulary term type identifier.

- editable:

  Logical; `TRUE` if the vocabulary can be extended.

- filterable:

  Logical; `TRUE` if the vocabulary supports filtering.

- value:

  The controlled term value (used in the API/data).

- display:

  Human-readable display label for the term.

- hidden:

  Logical; `TRUE` if the term is hidden from the UI.

- selected:

  Logical; `TRUE` if the term is selected by default.

- date_retrieved:

  Date the response was received.

Returns `NULL` on error (with a warning).

## See also

[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  vocab <- gsrs_vocabularies(verbose = FALSE)
  if (!is.null(vocab)) {
    # See all name type values
    print(vocab[vocab$domain == "NAME_TYPE", c("value", "display")])
  }
#>     value         display
#> 911    of   Official Name
#> 912   sys Systematic Name
#> 913    bn      Brand Name
#> 914    cn     Common Name
#> 915    cd            Code
# }
```
