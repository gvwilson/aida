# Clean and Analyze Data

## Reading data into Polars

-   `pl.read_csv()`, `pl.read_database()`, `pl.scan_csv()` for large files

## Inspecting a dataframe

-   `.schema`, `.head()`, `.describe()`, `.null_count()`

## Identifying problems

-   Missing values
-   Wrong data types
-   Inconsistent string values
-   Implausible outliers

## Prompt Claude for Polars code and check that it doesn't use Pandas

-   LLMs frequently mix the two

## Common cleaning operations

-   `.drop_nulls()`, `.fill_null()`, `.cast()`, `.str.strip_chars()`, `.with_columns()`

## Verify cleaning

-   Compare null counts and dataframe shape before and after
-   Spot check that no valid rows were dropped

## Use Claude to find and correct code smells

-   Ask it to review a script for repeated logic, hardcoded values, and readability problems

## Use `ruff` to lint Claude Code-generated Python code before running it

-   Catch unused imports, undefined variables, and style violations

## Group statistics and correlation

-   `.group_by().agg()`, `pl.pearson_corr()`

## Identify unreliable interpretations

-   Invented significance levels
-   Wrong direction of effect
-   Conflating correlation with causation

## Exercises

1.  Load the penguins data into Polars and confirm that row and column counts match the original file
1.  Prompt Claude to generate code that fills missing body mass values with the species median
    -   Verify that the null count decreases by the expected amount
1.  Prompt Claude to generate a cleaning script
    -   Run `ruff` on it and fix every warning, using Claude Code to explain any you do not understand
1.  Prompt Claude to review a ten-line Polars script for code smells
    -   Apply one suggested improvement and confirm the output is unchanged
1.  Compute the Pearson correlation between bill length and body mass
    -   Prompt Claude to interpret the result
    -   Evaluate whether its interpretation is justified by the number alone
1.  Identify a Claude interpretation of a group statistic that overstates certainty
    -   Rewrite it to accurately reflect what the data show
