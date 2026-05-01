# Managing Data

## Where datasets live

-   What we hope for: government data portals, Zenodo, GitHub repositories, institutional repositories
-   Reality: other people's laptops and random cloud storage

## Evaluating a dataset

-   License and provenance
-   Documentation
-   Size
-   Date last updated

## Shell commands for inspection

-   `curl -O`, `head -n`, `wc -l`, `cut -d, -f`, and `file`

## Common format tradeoffs

-   CSV: simple but fragile
-   JSON: nested but verbose
-   SQLite: queryable but not versionable
-   Parquet: typed and efficient, also not versionable

## Use Claude to *create* a data dictionary from a raw file

-   Ask for column names, infer types and units, summarize plausible value ranges

## Use Claude to *verify* a data dictionary

-   Check its descriptions against actual column names, units, and value ranges in the file
-   Cross-reference with the source documentation
-   Confirm no columns are missing

## Translating between CSV and JSON

Most datasets arrive as CSV, but many web APIs return JSON, and some tools expect one format
or the other.  Translating between them by hand is tedious and error-prone, which makes it
a good job for Claude — as long as you check what it produces.

CSV is a flat table: every row has the same columns, and values cannot be nested.  JSON can
represent hierarchies, lists within lists, and fields that only exist in some records.
Converting CSV to JSON is usually straightforward, but going the other way can require
decisions about how to flatten nested structures, and those decisions are easy to get wrong.

To ask Claude to translate a file, a prompt like this works well:

> Convert `penguins.csv` to `penguins.json`.  Preserve all column names exactly as they appear
> in the header row.  Use an array of objects, one per row.  Do not invent or drop fields.

The explicit instructions matter.  Without them, Claude might silently rename columns to
match some assumed convention, drop rows it considers malformed, or produce a single object
instead of an array.

Once Claude returns the converted file, verify it before using it:

-   Count the records: `wc -l penguins.csv` (minus the header) should equal
    the length of the JSON array.
-   Spot-check a few rows by comparing the CSV and JSON values side by side for the
    same record.
-   Confirm that column names in the JSON match the CSV header exactly — casing matters
    for most tools.
-   If the CSV had missing values, check how they appear in the JSON: as `null`,
    as empty strings, or as absent keys.  Pick one and make Claude be consistent.

Going from JSON to CSV adds a step: you need to decide what the columns are.  If the JSON
is a flat array of uniform objects, Claude can infer them.  If the objects have different
keys or nested values, tell Claude explicitly how to handle each case, then verify that
no data was silently dropped in the flattening.

## Why reproducibility matters

-   Re-run analysis after data updates
-   Audit your own work
-   Share with reviewers

## Project directory structure

-   `data/`, `scripts/`, `notebooks/`, `results/`, `figures/`, `log/`
-   `.gitignore` patterns for analysis projects

## What to put in log files

-   Prompts
-   Which LLM outputs were used vs. discarded
-   What corrections were made and why

## Prompt Claude to draft a project README

-   What to ask for
-   What to verify: dependencies, method description, accuracy

## Document LLM use for research integrity

-   FIXME

## Exercises

1.  Prompt Claude to download the Palmer Penguins CSV and confirm that the file arrived intact.
    -   How does it check the latter?
1.  Prompt Claude to extract one column and count how many distinct values it contains.
    -   Did Claude Code use shell commands, Python, or something else?
    -   Were you able to read and validate its method?
1.  Prompt Claude to generate a data dictionary for the penguins CSV.
    -   Verify its claims against the actual file.
1.  Prompt Claude to describe the squirrels dataset.
    -   Then prompt it to evaluate its own answer.
1.  Prompt Claude to convert `penguins.csv` to JSON.
    -   Count the records in both files and confirm they match.
    -   Check three rows by hand to make sure values were not renamed or dropped.
    -   Ask Claude what it did with missing values, then verify that answer against the file.
1.  Prompt Claude to convert the penguins JSON back to CSV.
    -   Compare the result to the original CSV.
    -   If there are any differences, trace where each one came from.
1.  Review your log files from the day.
    -   Identify the prompt that required the most iterations and explain why.
1.  Commit your scripts and logs with descriptive messages.
    -   Prompt Claude to review your commit messages and suggest improvements.
1.  Write a `.gitignore` file for this project.
    -   Prompt Claude to review it and identify any common patterns you missed.
1.  Prompt Claude to draft a README for your project.
    -   Verify that every dependency it lists is actually used and every step it describes actually works.
