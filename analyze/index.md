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
-   Check invariants: row count before must equal rows kept plus rows dropped
-   Confirm that derived fractions or probabilities across all categories sum to 1.0

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
-   Directional bias: when a known artifact should push an estimate in a specific direction, check that it does
    -   For example, ignoring dropped rows should overestimate a rate, not underestimate it
    -   If the bias goes the wrong way, the method or the code is wrong

## Validating an analysis

-   Generate synthetic data with a known answer and confirm the analysis recovers it
    -   If the method cannot recover the true value from clean synthetic data, the code is wrong
    -   Make the synthetic data realistically noisy: if it is too clean, the test is not useful
-   Fit the same model two different ways and check that the results agree
    -   Compute a mean with `.mean()` and again with `.sum()` divided by `.len()` and confirm they match
    -   If two valid approaches disagree, at least one is wrong
-   Vary a parameter you are uncertain about and check whether your main conclusion changes
    -   If swapping a threshold from 2.0 to 2.5 standard deviations flips your result, you need more data or a clearer criterion

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
1.  Filter the penguins data to keep 90% Adelie and 10% Chinstrap penguins
    -   Prompt Claude to evaluate how well the rule "classify as Adelie if `bill_length_mm < 45`" performs
    -   Did its first response report accuracy alone? Prompt it specifically for precision and recall
    -   Check whether it flagged the class imbalance without being asked
1.  Prompt Claude to fit a linear regression of `body_mass_g` on `bill_length_mm`
    and interpret the slope
    -   Did it report a confidence interval for the slope?
    -   Did it hedge about causation, or did it imply that longer bills cause heavier birds?
    -   Rewrite its interpretation to accurately reflect what the regression can and cannot show
1.  Prompt Claude to add a column `mass_outlier` that is `True` where `body_mass_g` is
    more than two standard deviations from the mean *for that species*
    -   Prompt Claude to find out whether it used the overall mean or the per-species mean, then check the code
    -   Count the flagged rows and spot-check two or three of them against the species statistics
1.  Generate a synthetic dataset of 100 penguins where Adelie birds have a mean bill length
    of 38 mm and Chinstrap birds have a mean bill length of 49 mm (both with standard deviation 2 mm)
    -   Prompt Claude to fit a classifier that predicts species from bill length
    -   Confirm that the decision boundary falls between the two means
    -   Check whether the reported accuracy is consistent with the known overlap between the two distributions
1.  Compute the mean body mass of all penguins two ways: once with `.mean()` and once by
    computing the sum of all body mass values divided by the count of non-null rows
    -   Confirm that both answers agree to at least four significant figures
    -   If they differ, find the cause
