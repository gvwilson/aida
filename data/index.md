# Find and Fetch Data

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

## Exercises

1.  Prompt Claude to download the Palmer Penguins CSV and confirm that the file arrived intact
    -   How does it check the latter?
1.  Prompt Claude to extract one column and count how many distinct values it contains
    -   Did Claude Code use shell commands, Python, or something else?
    -   Were you able to read and validate its method?
1.  Prompt Claude to generate a data dictionary for the penguins CSV
    -   Verify its claims against the actual file
1.  Prompt Claude to describe the squirrels dataset
    -   Then prompt it to evaluate its own answer
1.  Prompt Claude to explain the tradeoffs between CSV and Parquet for a 10-million-row dataset
    -   How many of its claims can you confidently evaluate?
    -   What do you do about the others?
