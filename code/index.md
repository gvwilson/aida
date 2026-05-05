# Coding

## Prompting an LLM to write code

-   When prompting an LLM to write code, be as specific as possible:
    -   State the goal in plain language before asking for code
    -   Name the library or tool you want it to use
    -   Say what the input looks like and what the output should be
    -   Compare the result against something you can verify independently
-   When the first attempt is wrong:
    -   Describe what is wrong, not just that it is wrong
    -   Explain what a correct answer would look like
    -   Ask it to explain what its code does before asking it to fix anything
-   FIXME: example session

## Code quality

-   Use `ruff` to [%g linter "lint" %] LLM-generated Python code before running it
    -   Catches unused imports, undefined variables, and style violations
-   Prompt the LLM to review code for repeated logic, hardcoded values, and readability problems

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

## Identifying problems in analysis

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

## Examples

### Count the number of penguins of each species {: #code-count-species}

You have loaded the penguins data into a SQLite database and want to know
how many individuals of each species were observed.
This is the kind of simple aggregate question that SQL handles naturally,
and the result is easy enough to verify from the raw CSV
that it makes a good first test of whether the LLM's output can be trusted.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this is too vague to be useful:

> Count the penguins.

The LLM does not know whether you want a single total, counts per species,
or something else entirely.
It may write a SQL query, a Python script, or a shell command,
and you have no way to tell it which approach fits your setup.
The result may be technically correct for some interpretation of the question
but useless for yours.
Fix it by naming the table, the column to group by, and the database engine.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write a SQLite query that counts the number of rows in the `penguins` table
> grouped by `species`.
> Return the species name and the count,
> sorted by count from largest to smallest.
> Name the count column `n`.

A typical response:

```sql
select species, count(*) as n
from penguins
group by species
order by n desc;
```

Running this against the example database gives:

| species | n |
|---|---|
| Adelie | 152 |
| Gentoo | 124 |
| Chinstrap | 68 |

</details>

<details class="explanation" markdown="1">
<summary>Checking the query result</summary>

First, confirm the counts sum to the total number of data rows.
The penguins CSV has a header row, so the number of data rows is
`wc -l _extras/penguins.csv` minus one.
If the sum of the three counts does not match that number,
either the query dropped some rows or the CSV contains blank lines.

Second, spot-check one species directly.
Run `grep -c "^Adelie" _extras/penguins.csv` to count lines that begin with `Adelie`
and compare it to the query result of 152.
If they differ, either the query is wrong or there are rows in the database
that do not appear in the CSV.

Third, check the sort order by eye.
Adelie is the most common penguin in the dataset, which is easy to verify
against the original Palmer Penguins publication.
If the LLM listed Chinstrap first, the `order by` clause is wrong.

</details>

### Inspect the join type a query uses {: #code-join-type}

When an LLM writes a join query, it chooses a join type and may not explain why.
An inner join silently drops rows that do not match in both tables;
a left join keeps all rows from the left table and fills unmatched columns with nulls.
The difference can change your row count dramatically without producing any error.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this leaves too many decisions to the LLM:

> Write a query that combines penguins and islands.

The LLM does not know the table names, the join key, or which join type fits your question.
Fix it by stating the tables, the key column, and what you want to happen to unmatched rows.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> The `penguins` table has a column `island`.
> Suppose there is an `islands` table with one row per island and a column `island` as the key.
> Write a SQLite query that joins `penguins` to `islands` so that every penguin appears in the result,
> even if its island is not in the `islands` table.
> State which join type you used and why.

A typical response uses a left join and explains that an inner join would silently drop penguins
whose island does not appear in the `islands` table.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Count the rows in the result and compare to the total rows in `penguins`.
If you asked for every penguin to appear and the result has fewer rows,
the query used an inner join instead of a left join.
Ask the LLM to count how many penguins would be dropped by an inner join for this specific dataset.

</details>

### Check where nulls appear in a sorted result {: #code-null-sort}

SQL does not specify where nulls appear in an `order by` result.
SQLite places nulls first in ascending order; PostgreSQL places them last.
If your analysis depends on the first or last row of a sorted result,
a null in the sort column can silently change the answer.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write a SQLite query that returns all penguins sorted by `body_mass_g` from lightest to heaviest.
> After writing the query, tell me where rows with a null `body_mass_g` will appear in the result.

A typical response produces the query and states that SQLite places nulls first in ascending order.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the query against `_extras/example.db` and examine the first five rows.
If the LLM said nulls appear first, confirm that the first rows have no `body_mass_g` value.
Then run the same query with `order by body_mass_g desc` and check where nulls appear in that result.
If the behavior differs from the LLM's prediction, it described a different database engine's rules.

</details>

### Detect Pandas syntax in Polars code {: #code-api-mixing}

If you describe a task using one library's vocabulary and ask for code in another,
an LLM may mix the two APIs.
The code will fail at runtime, but the error message may not make it obvious which library is at fault.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

Describing a Polars task in Pandas terms invites mixing:

> I have a pandas DataFrame with columns `species` and `bill_length_mm`.
> Compute the mean bill length per species using Polars.

The LLM may produce Pandas method calls (`.groupby()`, `.mean()`) inside Polars code.
Fix it by describing the data accurately and specifying the library without ambiguity.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

After getting mixed code, send this follow-up:

> The code you wrote uses `.groupby()`, which is a Pandas method.
> The data is a Polars DataFrame.
> Rewrite only the grouping line using the correct Polars API.

A typical response replaces `.groupby("species").mean()` with
`.group_by("species").agg(pl.col("bill_length_mm").mean())`.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the corrected code against `_extras/penguins.csv` loaded with Polars
and confirm it produces one row per species with a `bill_length_mm` mean column.
Verify the Adelie mean is approximately 38.8 mm by computing it manually on a few rows.

</details>

### Ask for a method that does not exist {: #code-nonexistent-method}

LLMs occasionally hallucinate library method names that sound plausible but do not exist.
The code runs until it hits that line and then raises an `AttributeError`.
Observing this failure and correcting it is more instructive than avoiding it,
because it shows you exactly what hallucination looks like in practice.

<details class="explanation" markdown="1">
<summary>A prompt that produces a hallucination</summary>

> Use the Polars method `.group_mean()` to compute average flipper length by island.

There is no `.group_mean()` method in Polars.
An LLM that generates code using it without flagging the problem is hallucinating.
An LLM that flags the problem immediately is behaving correctly.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that fixes the problem</summary>

If the LLM produced broken code, send this follow-up:

> The method `.group_mean()` does not exist in Polars.
> Rewrite the computation using only methods that appear in the Polars documentation for `GroupBy`.

A typical correct response:

```python
import polars as pl

df = pl.read_csv("_extras/penguins.csv")
result = df.group_by("island").agg(pl.col("flipper_length_mm").mean())
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the corrected code and confirm it produces one row per island.
Verify the result has three rows (Biscoe, Dream, Torgersen)
by checking that the islands in the output match the distinct values in the CSV.
If a fourth island appears, the LLM hallucinated a value.

</details>

### Interpret a correlation without implying causation {: #code-correlation-causation}

Pearson correlation measures the strength of a linear relationship.
It does not tell you which variable drives the other, whether both are driven by a third variable,
or whether the relationship holds outside the range you measured.
An LLM asked to "interpret" a correlation often states or implies causation,
and you must notice and correct that.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Using the penguins dataset, compute the Pearson correlation between `bill_depth_mm` and `body_mass_g`
> for all species combined.
> Then write two sentences interpreting the result.
> Do not imply that either variable causes the other.

A typical response computes the correlation (approximately -0.47 for all species combined)
and notes that penguins with deeper bills tend to have lower body mass across the dataset,
without claiming that bill depth determines mass.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Check the interpretation for causal language: "leads to," "causes," "results in," or "because of."
If you find any, rewrite the sentence to say only what the correlation shows.
Then compute the same correlation separately for each species.
If the within-species correlations have a different sign than the combined correlation,
ask the LLM to explain why, and verify that its explanation is correct.
(This is a well-known phenomenon called Simpson's paradox.)

</details>

### Test sensitivity to a threshold choice {: #code-threshold-sensitivity}

Statistical thresholds like "two standard deviations from the mean" are conventions, not laws.
If your conclusion changes substantially when you move the threshold by half a unit,
the conclusion is not robust.
Testing this costs one extra line of code and can prevent you from overstating a result.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> In the penguins dataset, I flagged penguins as outliers where `body_mass_g` is more than
> 2.0 standard deviations from the species mean.
> Change the threshold to 2.5 standard deviations and report how many rows are flagged under each threshold.
> Then tell me whether either threshold is scientifically justified.

A typical response computes both counts and notes that 2.0 and 2.5 are both common conventions
with no universal justification for preferring one.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Compute both counts yourself and confirm the LLM's numbers.
Then ask: if your main conclusion changes depending on the threshold,
what does that tell you about its robustness?
A conclusion that is sensitive to an arbitrary choice requires more data or a clearer criterion,
not just a different threshold.

</details>

### Validate an analysis against a known synthetic result {: #code-synthetic-validation}

If an LLM-generated analysis cannot recover the correct answer from data where the answer is known,
the analysis is wrong.
Generating synthetic data with a known property and confirming the script recovers it
is one of the strongest tests you can run.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Generate a Polars DataFrame with 200 rows and one column called `value`,
> where the values are drawn from a normal distribution with a true mean of 50.0 and standard deviation of 5.0.
> Set a random seed of 42.
> Then compute the mean of `value` and report how close it is to 50.0.

A typical response:

```python
import polars as pl
import numpy as np

rng = np.random.default_rng(42)
df = pl.DataFrame({"value": rng.normal(50.0, 5.0, 200)})
print(df["value"].mean())
```

The result is close to 50.0 but not exactly 50.0.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the script and confirm the computed mean is within 1.0 of 50.0.
Ask the LLM to explain in one sentence why the result is unlikely to be exactly 50.0.
If the explanation does not mention sampling variability or the finite sample size, it is incomplete.
Then change the seed from 42 to 43 and confirm the mean changes but remains close to 50.0.

</details>

### Check how GROUP BY handles null values {: #code-groupby-nulls}

A `group by` query creates one group per distinct value in the grouping column.
If that column contains nulls, different databases handle them differently:
SQLite groups nulls together; some databases silently drop them.
The only reliable way to know what your database does is to test it explicitly.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write a SQLite query that groups squirrels by `Primary Fur Color` and counts each group.
> Then explain whether rows where `Primary Fur Color` is null will appear in the result,
> and if so, what label they will have.

A typical response produces the query and explains that SQLite includes a row for null values
labeled with an empty string or `null` in the output.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the query against the squirrels database.
Then run a separate query with `where "Primary Fur Color" is null` and count those rows.
Add the null count to the non-null group counts and confirm the total equals the number of data rows.
If the total is wrong, either the LLM's description of null handling is incorrect
or there are rows in the database that do not appear in any group.

</details>

### Write post-cleaning invariant checks {: #code-invariants}

After cleaning a dataset, it is easy to accidentally drop valid rows, introduce new nulls,
or change the set of categories.
Three short assertions that check for these problems take two minutes to write
and catch errors that would otherwise propagate silently through every subsequent analysis.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have a Polars cleaning script that processes the penguins dataset.
> Add code after cleaning that checks three invariants:
> the row count equals rows kept plus rows dropped;
> no column has more null values after cleaning than before;
> the set of distinct values in the `species` column is unchanged.
> Raise an informative error if any check fails.

A typical response:

```python
species_before = set(df_raw["species"].unique().to_list())
# ... cleaning steps ...
assert df_raw.shape[0] == df_clean.shape[0] + rows_dropped, "Row count mismatch"
for col in df_raw.columns:
    assert df_clean[col].null_count() <= df_raw[col].null_count(), f"Nulls increased in {col}"
assert set(df_clean["species"].unique().to_list()) == species_before, "Species set changed"
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the checks against your cleaned dataset and confirm all three pass.
Then deliberately introduce a bug—for example, drop all Gentoo rows—and confirm
the third assertion fires with an informative message.
If the assertion raises a generic `AssertionError` with no message,
prompt the LLM to add a descriptive message to each one.

</details>

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
