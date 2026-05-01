# Retrieve chemical structure data for GSRS substances

For each supplied UNII, fetches the full substance record from
`GET /api/v1/substances(<UNII>)` and extracts the embedded `structure`
object, returning chemical identifiers and properties as a tidy data
frame.

## Usage

``` r
gsrs_structure(unii, verbose = TRUE, delay = 0.5)
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

- smiles:

  Canonical SMILES string.

- formula:

  Molecular formula (e.g., `"C9H8O4"`).

- mwt:

  Molecular weight (numeric).

- inchi_key:

  Standard InChIKey.

- inchi:

  Full InChI string.

- stereochemistry:

  Stereochemistry descriptor (e.g., `"ACHIRAL"`, `"RACEMIC"`,
  `"ABSOLUTE"`).

- optical_activity:

  Optical activity (e.g., `"UNSPECIFIED"`, `"(+)"`, `"(-)"`).

- charge:

  Formal charge (integer).

- stereo_centers:

  Number of stereocenters.

- defined_stereo:

  Number of defined stereocenters.

- ez_centers:

  Number of E/Z double-bond stereocenters.

- molfile:

  MDL molfile as a string.

- date_retrieved:

  Date the response was received.

- query:

  The UNII supplied by the caller.

Non-chemical substances (proteins, polymers, etc.) return a row of `NA`s
with `query` set. Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_structure_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure_search.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_structure("R16CO5Y76E")  # aspirin
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ℹ Retrieved structure for 1 substance(s).
  if (!is.null(out)) print(out[, c("smiles", "formula", "mwt", "inchi_key")])
#>                  smiles formula      mwt                   inchi_key
#> 1 CC(=O)Oc1ccccc1C(=O)O  C9H8O4 180.1578 BSYNRYMUTXBXSQ-UHFFFAOYSA-N
# }
```
