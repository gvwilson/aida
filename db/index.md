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
