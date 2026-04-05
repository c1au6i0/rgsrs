# Changelog

All notable changes to `rgsrs` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## rgsrs 0.1.0 (development)

### Added
- `gsrs_search()`: free-text and Lucene-syntax search across GSRS substances,
  with optional automatic pagination.
- `gsrs_substance()`: fetch substance metadata by UNII (vectorized).
- `gsrs_names()`: retrieve all registered names / synonyms for one or more
  UNIIs.
- `gsrs_codes()`: retrieve all cross-reference codes (CAS, PubChem, ChEMBL,
  WHO-ATC, DrugBank, etc.) for one or more UNIIs, with optional `code_system`
  filter.
- `gsrs_unii_from_name()`: resolve substance names to their UNII identifiers.
- `gsrs_all()`: convenience umbrella returning substance metadata, names, and
  codes in a single named list.
- `write_dataframes_to_excel()`: write a named list of data frames to an Excel
  workbook (requires `openxlsx`).
