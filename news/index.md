# Changelog

## rgsrs 0.1.0

### New functions

- [`gsrs_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_search.md):
  free-text and Lucene-syntax search across GSRS substances, with
  optional automatic pagination.
- [`gsrs_substance()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_substance.md):
  fetch substance metadata by UNII (vectorized).
- [`gsrs_names()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_names.md):
  retrieve all registered names / synonyms for one or more UNIIs.
- [`gsrs_codes()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_codes.md):
  retrieve all cross-reference codes (CAS, PubChem, ChEMBL, WHO-ATC,
  DrugBank, etc.) for one or more UNIIs, with optional `code_system`
  filter.
- [`gsrs_unii_from_name()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_unii_from_name.md):
  resolve substance names to their UNII identifiers.
- [`gsrs_structure()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure.md):
  fetch chemical structure data (SMILES, formula, MW, InChI, stereo
  info) by UNII.
- [`gsrs_structure_search()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_structure_search.md):
  substructure, similarity, exact, and flexible structure search by
  SMILES.
- [`gsrs_chem_info()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_chem_info.md):
  retrieve chemical structure information from any identifier — name,
  CAS, UNII, InChIKey, or SMILES.
- [`gsrs_hierarchy()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_hierarchy.md):
  retrieve the parent/child relationship tree for a substance.
- [`gsrs_browse()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_browse.md):
  page through the full GSRS substance catalogue.
- [`gsrs_vocabularies()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_vocabularies.md):
  retrieve all controlled vocabulary terms.
- [`gsrs_all()`](https://c1au6i0.github.io/rgsrs/reference/gsrs_all.md):
  convenience umbrella returning substance metadata, names, codes,
  structure, and hierarchy in a single named list.
- [`write_dataframes_to_excel()`](https://c1au6i0.github.io/rgsrs/reference/write_dataframes_to_excel.md):
  write a named list of data frames to an Excel workbook (requires
  `openxlsx`).
