# Retrieve external codes and identifiers for GSRS substances

For each supplied UNII, calls `GET /api/v1/substances(<UNII>)/codes` and
returns all registered cross-references as a tidy data frame. These
include CAS numbers, PubChem CIDs, ChEMBL IDs, WHO-ATC codes, NDF-RT
codes, DrugBank IDs, and many more.

## Usage

``` r
gsrs_codes(unii, code_system = NULL, verbose = TRUE, delay = 0.5)
```

## Arguments

- unii:

  Character vector of one or more UNII codes.

- code_system:

  Character vector of code systems to filter on (e.g.,
  `c("CAS", "PUBCHEM")`). Case-insensitive matching. Pass `NULL`
  (default) to return all code systems.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between individual lookups when `unii` has
  multiple entries. Default `0.5`.

## Value

A data frame with columns:

- code_system:

  External database / code system name (e.g., `"CAS"`, `"PUBCHEM"`,
  `"ChEMBL"`, `"WHO-ATC"`).

- code:

  The identifier in that system.

- type:

  `"PRIMARY"` or `"ALTERNATIVE"`.

- url:

  URL to the external record (when available).

- comments:

  Additional context for the code (e.g., ATC path).

- is_classification:

  Logical; `TRUE` for classification codes.

- uuid:

  Internal GSRS UUID for the code record.

- date_retrieved:

  Date the response was received.

- query:

  The UNII supplied by the caller.

Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  # All codes for aspirin
  out <- gsrs_codes("R16CO5Y76E")
#> ℹ Fetching codes for UNII: R16CO5Y76E ...
#> ℹ Retrieved 85 code record(s).
  if (!is.null(out)) print(head(out))
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
#> 1              TRUE 02993f14-aa8c-b78d-df34-4d572f50698d 2026-05-01 01:57:43
#> 2             FALSE 08f6f535-d27d-44d2-b50f-57d838de41c1 2026-05-01 01:57:43
#> 3             FALSE 0a961196-b583-df05-b166-7a2f27fd8423 2026-05-01 01:57:43
#> 4              TRUE 0d10f32d-a67f-434b-9074-b3158112afad 2026-05-01 01:57:43
#> 5              TRUE 0f4c868d-c8e4-462b-ab6a-6cd9dc5dd9a2 2026-05-01 01:57:43
#> 6              TRUE 155f7e8e-14f8-4352-ab80-f146f2f7ca36 2026-05-01 01:57:43
#>        query
#> 1 R16CO5Y76E
#> 2 R16CO5Y76E
#> 3 R16CO5Y76E
#> 4 R16CO5Y76E
#> 5 R16CO5Y76E
#> 6 R16CO5Y76E

  Sys.sleep(2)
  # Only CAS and PubChem codes
  out_cas <- gsrs_codes("R16CO5Y76E", code_system = c("CAS", "PUBCHEM"))
#> ℹ Fetching codes for UNII: R16CO5Y76E ...
#> ℹ Retrieved 2 code record(s).
  if (!is.null(out_cas)) print(out_cas)
#>    code_system    code    type
#> 26     PUBCHEM    2244 PRIMARY
#> 43         CAS 50-78-2 PRIMARY
#>                                                      url comments
#> 26        https://pubchem.ncbi.nlm.nih.gov/compound/2244     <NA>
#> 43 https://commonchemistry.cas.org/detail?cas_rn=50-78-2     <NA>
#>    is_classification                                 uuid      date_retrieved
#> 26             FALSE 51e4a060-1493-4555-a282-045dd71a6f68 2026-05-01 01:57:46
#> 43             FALSE 9ecfcafa-8aef-49a9-b21b-5a0f94866669 2026-05-01 01:57:46
#>         query
#> 26 R16CO5Y76E
#> 43 R16CO5Y76E
# }
```
