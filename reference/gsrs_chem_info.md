# Retrieve chemical structure information by substance name or CAS number

A convenience wrapper that resolves one or more substance identifiers to
GSRS UNIIs and then fetches the embedded chemical structure data for
each substance. The result is one wide row per input identifier
containing both the resolved metadata and the full structure record.

## Usage

``` r
gsrs_chem_info(
  identifiers,
  type = c("name", "cas", "unii", "inchikey", "smiles"),
  verbose = TRUE,
  delay = 0.5
)
```

## Arguments

- identifiers:

  Character vector of substance identifiers.

- type:

  Character scalar. The identifier type. One of:

  `"name"`

  :   Common or systematic substance name (default).

  `"cas"`

  :   CAS Registry Number (e.g., `"50-78-2"`).

  `"unii"`

  :   FDA UNII / approval ID (e.g., `"R16CO5Y76E"`). Skips the search
      step and fetches the structure directly.

  `"inchikey"`

  :   Standard InChIKey (e.g., `"BSYNRYMUTXBXSQ-UHFFFAOYSA-N"`).

  `"smiles"`

  :   SMILES string. Uses an exact structure search to resolve to a UNII
      before fetching the structure record.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual API calls. Default `0.5`.

## Value

A data frame with one row per input identifier and columns:

- query:

  The identifier supplied by the caller.

- type:

  The identifier type (`"name"` or `"cas"`).

- unii:

  Resolved UNII / approval ID.

- preferred_name:

  Preferred display name in GSRS.

- substance_class:

  Substance class (e.g., `"chemical"`).

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

  Stereochemistry descriptor.

- optical_activity:

  Optical activity descriptor.

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

  Date the structure response was received.

Unresolved identifiers or non-chemical substances produce a row of `NA`s
with `query` and `type` set. Returns `NULL` on error (with a warning).

## See also

[`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md),
[`gsrs_unii_from_name()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_unii_from_name.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md),
[`gsrs_structure_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure_search.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_chem_info(c("aspirin", "ibuprofen"), type = "name")
#> ℹ Resolving name: aspirin ...
#> ℹ Resolving name: ibuprofen ...
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ℹ Fetching structure for UNII: RM1CE97Z4N ...
#> ✔ Retrieved chemical info for 2 substance(s).
  if (!is.null(out)) print(out[, c("query", "unii", "formula", "mwt")])
#>       query       unii          formula      mwt
#> 1   aspirin R16CO5Y76E           C9H8O4 180.1578
#> 2 ibuprofen RM1CE97Z4N C13H17O2.Na.2H2O 264.2937

  Sys.sleep(2)
  out_cas <- gsrs_chem_info(c("50-78-2", "15687-27-1"), type = "cas")
#> ℹ Resolving CAS: 50-78-2 ...
#> ℹ Resolving CAS: 15687-27-1 ...
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ℹ Fetching structure for UNII: WK2XYI10QM ...
#> ✔ Retrieved chemical info for 2 substance(s).
  if (!is.null(out_cas)) print(out_cas[, c("query", "unii", "formula", "mwt")])
#>        query       unii  formula      mwt
#> 1    50-78-2 R16CO5Y76E   C9H8O4 180.1578
#> 2 15687-27-1 WK2XYI10QM C13H18O2 206.2813

  Sys.sleep(2)
  out_unii <- gsrs_chem_info("R16CO5Y76E", type = "unii")
#> ℹ Using UNII directly: R16CO5Y76E ...
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ✔ Retrieved chemical info for 1 substance(s).
  if (!is.null(out_unii)) print(out_unii[, c("query", "formula", "mwt")])
#>        query formula      mwt
#> 1 R16CO5Y76E  C9H8O4 180.1578

  Sys.sleep(2)
  out_ik <- gsrs_chem_info("BSYNRYMUTXBXSQ-UHFFFAOYSA-N", type = "inchikey")
#> ℹ Resolving InChIKey: BSYNRYMUTXBXSQ-UHFFFAOYSA-N ...
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ✔ Retrieved chemical info for 1 substance(s).
  if (!is.null(out_ik)) print(out_ik[, c("query", "unii", "formula")])
#>                         query       unii formula
#> 1 BSYNRYMUTXBXSQ-UHFFFAOYSA-N R16CO5Y76E  C9H8O4

  Sys.sleep(2)
  out_smi <- gsrs_chem_info("CC(=O)Oc1ccccc1C(=O)O", type = "smiles")
#> ℹ Resolving SMILES (exact): CC(=O)Oc1ccccc1C(=O)O ...
#> ℹ Fetching structure for UNII: R16CO5Y76E ...
#> ✔ Retrieved chemical info for 1 substance(s).
  if (!is.null(out_smi)) print(out_smi[, c("query", "unii", "formula")])
#>                   query       unii formula
#> 1 CC(=O)Oc1ccccc1C(=O)O R16CO5Y76E  C9H8O4
# }
```
