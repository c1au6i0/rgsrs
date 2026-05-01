# Write a named list of data frames to an Excel workbook

Each element of `df_list` is written to its own sheet. Requires the
`openxlsx` package (listed in `Suggests`).

## Usage

``` r
write_dataframes_to_excel(df_list, filename)
```

## Arguments

- df_list:

  A named list of data frames.

- filename:

  Character string. Path to the output `.xlsx` file.

## Value

Invisible `filename`.

## Examples

``` r
# \donttest{
  tmp <- tempfile(fileext = ".xlsx")
  write_dataframes_to_excel(list(sheet1 = mtcars, sheet2 = iris), tmp)
# }
```
