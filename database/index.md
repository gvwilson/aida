# Work with Databases

## Connect to a SQLite database from a Marimo notebook using `sqlite3`

## Prompt Claude to write queries

1.  State the goal ("find all female penguins that weigh more than 3kg")
1.  Specify `select`, `where`, `order by`, `group by`, aggregation, `having`, `join` explicitly
1.  Compare results

## Common errors in LLM-generated SQL

-   Schema hallucination: inventing table or column names that do not exist
-   Faulty joins: wrong type, missing or ambiguous conditions
-   Aggregation mistakes: grouping errors, aggregating the wrong column
-   Missing filters: omitting `where` conditions implied by the question
-   Mishandling nulls in `order by` or aggregation

## Verify query results

-   Check row counts against known totals
-   Spot-check individual values
-   Confirm aggregates are in a plausible range
-   Check that a partition covers all rows: subgroup counts must sum to the total, and fractions must sum to 1.0
    -   A `group by` that drops rows (e.g., because of `null` values in the grouping column) is a common silent error

## Iterate when the first query is wrong

-   Describe the error clearly
-   Explain what a correct answer looks like

## Exercises

1.  Prompt Claude to count the total number of rows in the penguins table
    -   Verify the result matches `wc -l` on the CSV minus the header
1.  Prompt Claude to compute average body mass by species
    -   Check whether each value is in a plausible range for that species
1.  Prompt Claude to write a query that references a column name you slightly misspell in the prompt
    -   Does it hallucinate a column or flag the error?
1.  Prompt Claude to write a join query
    -   How can you validate that the query is correct?
1.  Prompt Claude to explain a clause you have not used before
    (e.g., using `coalesce`, `like`, or a window function)
    -   Write a query using it and verify the output
1.  Prompt Claude to write a query that cross-tabulates species and island
    in the penguins table (one row per species, one column per island, counts in cells)
    -   Sum a row and verify it equals the count for that species from a separate `group by` query
    -   Sum a column and verify it equals the count for that island
1.  Prompt Claude to write a query that flags penguins whose `body_mass_g`
    is more than two standard deviations from the mean for their species
    -   Verify two or three flagged rows by computing the species mean and standard deviation yourself
    -   Did Claude use a subquery or a window function? Check whether the approach is actually correct
1.  Prompt Claude to compute what fraction of each species is female
    (`sex = 'FEMALE'` count divided by total count per species)
    -   Verify that the fractions for each species sum to approximately 1.0
    -   Prompt Claude to explain what it did with rows where `sex` is `null`,
        then confirm its answer against the query
