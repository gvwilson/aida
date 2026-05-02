# Coding

## Prompting an LLM to write code

-   When asking an LLM to write code, be as specific as possible:
    -   State the goal in plain language before asking for code
    -   Name the library or tool you want it to use
    -   Say what the input looks like and what the output should be
    -   Compare the result against something you can verify independently
-   When the first attempt is wrong:
    -   Describe what is wrong, not just that it is wrong
    -   Explain what a correct answer would look like
    -   Ask it to explain what its code does before asking it to fix anything

## Common LLM errors in generated code

-   Hallucinating names: inventing table columns, function arguments, or parameter names that do not exist
-   Mixing libraries: using Pandas syntax in Polars code, or vice versa
-   Inventing significance levels or statistical thresholds without justification
-   Conflating correlation with causation in interpretations
-   Directional bias errors:
    when a known artifact should push an estimate one way, check that it does
    -   If the bias goes the wrong way, the method or the code is wrong

## Verifying results

-   Check counts against known totals from an independent source
-   Spot-check individual values by hand
-   Confirm aggregates are in a plausible range
-   Check that a partition covers all rows:
    subgroup counts must sum to the total, and fractions must sum to 1.0

## Common errors in LLM-generated SQL

-   Schema hallucination: inventing table or column names that do not exist
-   Faulty joins: wrong type, missing or ambiguous conditions
-   Aggregation mistakes: grouping errors, aggregating the wrong column
-   Missing filters: omitting `where` conditions implied by the question
-   Mishandling nulls in `order by` or aggregation
-   A `group by` that drops rows (e.g., because of `null` values in the grouping column)
    is a common silent error

## Verifying query results

-   Check row counts against known totals
-   Spot-check individual values
-   Confirm aggregates are in a plausible range
-   Check that subgroup counts sum to the total and fractions sum to 1.0

## Reading and inspecting data with Polars

-   `pl.read_csv()`, `pl.read_database()`, `pl.scan_csv()` for large files
-   Inspect with `.schema`, `.head()`, `.describe()`, `.null_count()`
-   `.drop_nulls()`, `.fill_null()`, `.cast()`, `.str.strip_chars()`, `.with_columns()`
-   Prompt explicitly for Polars: LLMs frequently produce Pandas syntax instead

## Identifying problems

-   Missing values
-   Wrong data types
-   Inconsistent string values
-   Implausible outliers
-   Compare null counts and dataframe shape before and after
-   Spot-check that no valid rows were dropped
-   Check invariants: row count before must equal rows kept plus rows dropped
-   Confirm that derived fractions or probabilities across all categories sum to 1.0
-   Invented significance levels
-   Wrong direction of effect
-   Conflating correlation with causation
-   Overstating certainty about group differences

## Code quality

-   Use `ruff` to [%g linter "lint" %] LLM-generated Python code before running it
    -   Catches unused imports, undefined variables, and style violations
-   Ask the LLM to review code for repeated logic, hardcoded values, and readability problems

### Validating an analysis

-   Generate synthetic data with a known answer and confirm the analysis recovers it
    -   If the method cannot recover the true value from clean synthetic data, the code is wrong
    -   Make the synthetic data realistically noisy: if it is too clean, the test is not useful
-   Fit the same model two different ways and check that the results agree
    -   Compute a mean with `.mean()` and again with `.sum()` divided by `.len()` and confirm they match
    -   If two valid approaches disagree, at least one is wrong
-   Vary a parameter you are uncertain about and check whether your main conclusion changes
    -   If swapping a threshold from 2.0 to 2.5 standard deviations flips your result,
        you need more data or a clearer criterion

## Exercises

1.  Prompt an LLM to count the total number of rows in the penguins table
    -   Verify the result matches `wc -l` on the CSV minus the header
1.  Prompt an LLM to compute average body mass by species
    -   Check whether each value is in a plausible range for that species
1.  Prompt an LLM to write a query that references a column name you slightly misspell in the prompt
    -   Does it hallucinate a column or flag the error?
1.  Prompt an LLM to write a join query
    -   How can you validate that the query is correct?
1.  Prompt an LLM to explain a clause you have not used before
    (e.g., `coalesce`, `like`, or a window function)
    -   Write a query using it and verify the output
1.  Prompt an LLM to write a query that cross-tabulates species and island
    in the penguins table (one row per species, one column per island, counts in cells)
    -   Sum a row and verify it equals the count for that species from a separate `group by` query
    -   Sum a column and verify it equals the count for that island
1.  Prompt an LLM to write a query that flags penguins whose `body_mass_g`
    is more than two standard deviations from the mean for their species
    -   Verify two or three flagged rows by computing the species mean and standard deviation yourself
    -   Did the LLM use a subquery or a window function? Check whether the approach is actually correct
1.  Prompt an LLM to compute what fraction of each species is female
    (`sex = 'FEMALE'` count divided by total count per species)
    -   Verify that the fractions for each species sum to approximately 1.0
    -   Prompt the LLM to explain what it did with rows where `sex` is `null`,
        then confirm its answer against the query
1.  Load the penguins data into Polars and confirm that row and column counts match the original file
1.  Prompt an LLM to generate code that fills missing body mass values with the species median
    -   Verify that the null count decreases by the expected amount
1.  Prompt an LLM to generate a cleaning script
    -   Run `ruff` on it and fix every warning, using the LLM to explain any you do not understand
1.  Prompt an LLM to review a ten-line Polars script for code smells
    -   Apply one suggested improvement and confirm the output is unchanged
1.  Compute the Pearson correlation between bill length and body mass
    -   Prompt an LLM to interpret the result
    -   Evaluate whether its interpretation is justified by the number alone
1.  Identify an LLM interpretation of a group statistic that overstates certainty
    -   Rewrite it to accurately reflect what the data show
1.  Filter the penguins data to keep 90% Adelie and 10% Chinstrap penguins
    -   Prompt an LLM to evaluate how well the rule "classify as Adelie if `bill_length_mm < 45`" performs
    -   Did its first response report accuracy alone? Prompt it specifically for
        [%g precision_recall "precision and recall" %]
    -   Check whether it flagged the class imbalance without being asked
1.  Prompt an LLM to fit a linear regression of `body_mass_g` on `bill_length_mm`
    and interpret the slope
    -   Did it report a confidence interval for the slope?
    -   Did it hedge about causation, or did it imply that longer bills cause heavier birds?
    -   Rewrite its interpretation to accurately reflect what the regression can and cannot show
1.  Prompt an LLM to add a column `mass_outlier` that is `True` where `body_mass_g` is
    more than two standard deviations from the mean *for that species*
    -   Ask the LLM whether it used the overall mean or the per-species mean, then check the code
    -   Count the flagged rows and spot-check two or three of them against the species statistics
1.  Generate a synthetic dataset of 100 penguins where Adelies have a mean bill length of 38 mm
    and Chinstraps have a mean bill length of 49 mm (both with standard deviation 2 mm)
    -   Prompt an LLM to fit a classifier that predicts species from bill length
    -   Confirm that the decision boundary falls between the two means
    -   Check whether the reported accuracy is consistent with the known overlap between the two distributions
1.  Compute the mean body mass of all penguins two ways: once with `.mean()` and once by
    computing the sum of all body mass values divided by the count of non-null rows
    -   Confirm that both answers agree to at least four significant figures
    -   If they differ, find the cause
