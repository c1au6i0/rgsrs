# Search GSRS by chemical structure

Searches the FDA Global Substance Registration System for substances
matching a chemical structure query supplied as a SMILES string.
Supports substructure, similarity, exact-match, and flexible
(disconnected moiety) search types.

## Usage

``` r
gsrs_structure_search(
  smiles,
  type = c("sub", "sim", "exact", "flex"),
  cutoff = 0.8,
  top = 10L,
  verbose = TRUE
)
```

## Arguments

- smiles:

  Character string. A valid SMILES or SMARTS string describing the query
  structure (e.g., `"CC(=O)Oc1ccccc1C(=O)O"` for aspirin).

- type:

  Character string. Search type. One of:

  `"sub"`

  :   Substructure search (default). Returns all substances whose
      structure contains the query as a substructure.

  `"sim"`

  :   Similarity search. Returns substances with Tanimoto similarity \>=
      `cutoff`. Use `cutoff` to control threshold.

  `"exact"`

  :   Exact structure match (tautomer-aware, stereo-sensitive).

  `"flex"`

  :   Flexible (disconnected moiety) search; stereo-insensitive.

- cutoff:

  Numeric in `[0, 1]`. Tanimoto similarity cutoff for `type = "sim"`.
  Default `0.8`. Ignored for other search types.

- top:

  Integer. Maximum number of records to return. Default `10`.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

## Value

A data frame with the same columns as
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md),
plus a `query_smiles` column recording the input SMILES. Returns `NULL`
on error (with a warning).

## See also

[`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md),
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  # Exact match for aspirin
  out <- gsrs_structure_search("CC(=O)Oc1ccccc1C(=O)O", type = "exact")
#> ℹ Running exact structure search for: CC(=O)Oc1ccccc1C(=O)O ...
#> ℹ Retrieved 1 matching substance(s).
  if (!is.null(out)) print(out[, c("approval_id", "preferred_name")])
#>   approval_id preferred_name
#> 1  R16CO5Y76E        Aspirin

  Sys.sleep(2)
  # Similarity search
  out_sim <- gsrs_structure_search("CC(=O)Oc1ccccc1C(=O)O",
                                   type = "sim", cutoff = 0.7, top = 5)
#> ℹ Running sim structure search for: CC(=O)Oc1ccccc1C(=O)O ...
#> ℹ Retrieved 5 matching substance(s).
  if (!is.null(out_sim)) print(out_sim[, c("approval_id", "preferred_name")])
#>   approval_id    preferred_name
#> 1  R16CO5Y76E           Aspirin
#> 2  6QT214X4XU         ALOXIPRIN
#> 3  8649Y4P3PA      Zinc Aspirin
#> 4  5XE48797BQ ASPIRIN POTASSIUM
#> 5  E62HT5S2E9    Aspirin sodium
# }
```
