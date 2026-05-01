# Search the GSRS substance database

Searches the FDA Global Substance Registration System (GSRS) using a
free-text or Lucene-style field query. Returns a tidy data frame of
matching substance records with key metadata fields.

## Usage

``` r
gsrs_search(query, top = 10L, skip = 0L, verbose = TRUE, delay = 0.5)
```

## Arguments

- query:

  Character string. The search query. Supports:

  - Free text (e.g., `"aspirin"`)

  - Lucene field syntax (e.g., `"root_names:aspirin"`,
    `"root_approvalID:R16CO5Y76E"`)

  - Wildcards (`*`, `?`) as per GSRS documentation.

- top:

  Integer. Maximum number of records to return per request. Default
  `10`. Use `NULL` or `Inf` to attempt to retrieve all records
  (paginates automatically; large result sets may be slow).

- skip:

  Integer. Number of records to skip (offset). Default `0`.

- verbose:

  Logical. If `TRUE`, emit progress messages. Default `TRUE`.

- delay:

  Numeric. Seconds to wait between paginated requests. Default `0.5`.

## Value

A data frame with columns:

- uuid:

  Internal GSRS UUID of the substance.

- approval_id:

  FDA UNII / approval ID.

- preferred_name:

  Preferred display name.

- substance_class:

  Substance class (e.g., `"chemical"`, `"structurallyDiverse"`).

- status:

  Record status (e.g., `"approved"`).

- definition_type:

  `"PRIMARY"` or `"ALTERNATIVE"`.

- definition_level:

  `"COMPLETE"` or `"INCOMPLETE"`.

- version:

  Record version string.

- names_url:

  URL to retrieve all names for this substance.

- codes_url:

  URL to retrieve all codes for this substance.

- self_url:

  Full URL for this substance record.

- date_retrieved:

  Date the response was received from the server.

Returns `NULL` on error (with a warning).

## See also

[`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md),
[`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md),
[`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md)

## Examples

``` r
# \donttest{
  Sys.sleep(2)
  out <- gsrs_search("aspirin", top = 5)
#> ℹ Fetching records 1 - 5 ...
#> ℹ Retrieved 5 record(s).
  if (!is.null(out)) print(head(out))
#>                                   uuid approval_id       preferred_name
#> 1 a05ec20c-8fe2-4e02-ba7f-df69e5e30248  R16CO5Y76E              Aspirin
#> 2 39305c46-e2bd-4343-bdd3-8502874c9f1e  E33TS05V6B     ASPIRIN ALUMINUM
#> 3 8919c8de-dccd-4d97-a4bc-82cd34a0616b  WOD7W0DGZS      Aspirin calcium
#> 4 38cc8efd-e65b-4ea9-83be-b37cf3694c38  YR4ND62LYK Aspirin copper dimer
#> 5 26fba4d9-e663-444a-84a6-c38fad3af682  T6EKB9V2O2           GUACETISAL
#>   substance_class   status definition_type definition_level version
#> 1        chemical approved         PRIMARY         COMPLETE     119
#> 2        chemical approved         PRIMARY         COMPLETE      16
#> 3        chemical approved         PRIMARY         COMPLETE      17
#> 4        chemical approved         PRIMARY         COMPLETE       8
#> 5        chemical approved         PRIMARY         COMPLETE      16
#>                                                                                  names_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)/names
#> 2 https://gsrs.ncats.nih.gov/api/v1/substances(39305c46-e2bd-4343-bdd3-8502874c9f1e)/names
#> 3 https://gsrs.ncats.nih.gov/api/v1/substances(8919c8de-dccd-4d97-a4bc-82cd34a0616b)/names
#> 4 https://gsrs.ncats.nih.gov/api/v1/substances(38cc8efd-e65b-4ea9-83be-b37cf3694c38)/names
#> 5 https://gsrs.ncats.nih.gov/api/v1/substances(26fba4d9-e663-444a-84a6-c38fad3af682)/names
#>                                                                                  codes_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)/codes
#> 2 https://gsrs.ncats.nih.gov/api/v1/substances(39305c46-e2bd-4343-bdd3-8502874c9f1e)/codes
#> 3 https://gsrs.ncats.nih.gov/api/v1/substances(8919c8de-dccd-4d97-a4bc-82cd34a0616b)/codes
#> 4 https://gsrs.ncats.nih.gov/api/v1/substances(38cc8efd-e65b-4ea9-83be-b37cf3694c38)/codes
#> 5 https://gsrs.ncats.nih.gov/api/v1/substances(26fba4d9-e663-444a-84a6-c38fad3af682)/codes
#>                                                                                       self_url
#> 1 https://gsrs.ncats.nih.gov/api/v1/substances(a05ec20c-8fe2-4e02-ba7f-df69e5e30248)?view=full
#> 2 https://gsrs.ncats.nih.gov/api/v1/substances(39305c46-e2bd-4343-bdd3-8502874c9f1e)?view=full
#> 3 https://gsrs.ncats.nih.gov/api/v1/substances(8919c8de-dccd-4d97-a4bc-82cd34a0616b)?view=full
#> 4 https://gsrs.ncats.nih.gov/api/v1/substances(38cc8efd-e65b-4ea9-83be-b37cf3694c38)?view=full
#> 5 https://gsrs.ncats.nih.gov/api/v1/substances(26fba4d9-e663-444a-84a6-c38fad3af682)?view=full
#>        date_retrieved
#> 1 2026-05-01 01:57:53
#> 2 2026-05-01 01:57:53
#> 3 2026-05-01 01:57:53
#> 4 2026-05-01 01:57:53
#> 5 2026-05-01 01:57:53
# }
```
