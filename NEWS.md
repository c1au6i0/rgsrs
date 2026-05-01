# rgsrs 0.1.0

## New functions

- `gsrs_search()`: free-text and Lucene-syntax search across GSRS substances,
  with optional automatic pagination.
- `gsrs_substance()`: fetch substance metadata by UNII (vectorized).
- `gsrs_names()`: retrieve all registered names / synonyms for one or more
  UNIIs.
- `gsrs_codes()`: retrieve all cross-reference codes (CAS, PubChem, ChEMBL,
  WHO-ATC, DrugBank, etc.) for one or more UNIIs, with optional `code_system`
  filter.
- `gsrs_unii_from_name()`: resolve substance names to their UNII identifiers.
- `gsrs_structure()`: fetch chemical structure data (SMILES, formula, MW,
  InChI, stereo info) by UNII.
- `gsrs_structure_search()`: substructure, similarity, exact, and flexible
  structure search by SMILES.
- `gsrs_chem_info()`: retrieve chemical structure information from any
  identifier — name, CAS, UNII, InChIKey, or SMILES.
- `gsrs_hierarchy()`: retrieve the parent/child relationship tree for a
  substance.
- `gsrs_browse()`: page through the full GSRS substance catalogue.
- `gsrs_vocabularies()`: retrieve all controlled vocabulary terms.
- `gsrs_all()`: convenience umbrella returning substance metadata, names,
  codes, structure, and hierarchy in a single named list.
- `write_dataframes_to_excel()`: write a named list of data frames to an Excel
  workbook (requires `openxlsx`).
