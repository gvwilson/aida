# Managing Data

## Starting point

-   Where datasets live
    -   What we hope for:
        government data portals,
        [Zenodo][zenodo],
        GitHub repositories,
        institutional repositories
    -   Reality: other people's laptops and random cloud storage
-   Project directory structure
    -   `data/`, `scripts/`, `notebooks/`, `results/`, `figures/`, `log/`
    -   `.gitignore` patterns for analysis projects
-   Evaluating a dataset
    -   License and provenance
    -   Documentation
    -   Size
    -   Date last updated
-   Shell commands for inspection
    -   `curl -O`, `head -n`, `wc -l`, `cut -d, -f`, and `file`
-   Common formats and tradeoffs
    -   CSV: simple but fragile
    -   JSON: nested but verbose
    -   [SQLite][sqlite]: queryable but not versionable
    -   [Parquet][parquet]: typed and efficient, also not versionable

## Data dictionaries

-   Use an LLM to *create* a [%g data_dictionary "data dictionary" %] from a raw file
    -   Ask for column names, infer types and units, summarize plausible value ranges
-   Use an LLM to *verify* a data dictionary
    -   Check its descriptions against actual column names, units, and value ranges in the file
    -   Cross-reference with the source documentation
    -   Confirm no columns are missing

## Prompt an LLM to *write* a project README

-   What to ask for
-   What to verify: dependencies, method description, accuracy

## Prompt an LLM to *check* a project README

-   Especially when you start work on someone else's project
-   Useful in conjunction with tools like [brief][brief]

## Random seeds

-   Set random seeds explicitly in any analysis that involves randomness:
    sampling, bootstrapping, or splitting data into training and test sets
-   Without a seed, two runs of the same script can produce different results,
    making it impossible to confirm that a change actually fixed a problem

## What to put in log files

-   Prompts
-   Which LLM outputs were used vs. discarded
-   What corrections were made and why

## Examples

### Generate a data dictionary for the penguins CSV {: #manage-data-dict}

You have just downloaded a CSV file and want to understand what it contains before analyzing it.
Rather than reading each column yourself,
you can give an LLM the first few lines and ask it to draft a
data dictionary that describes each column,
its data type and units,
and the range of values you should expect.
You must then check that dictionary against the actual file.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A vague prompt like this produces unreliable output:

> Tell me about the penguins dataset.

The LLM answers from its training data, not from the file in front of you.
It may describe a version of the dataset that differs from yours,
invent column names or units that do not exist,
or report statistics that do not match your file.
The answer will sound authoritative but you cannot verify any of it
without checking the original source yourself, at which point you did not need the LLM.
Fix it by pasting the actual file contents into the prompt.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I am pasting the first five lines of a CSV file below.
> List each column name exactly as it appears in the header,
> infer its most likely data type (integer, float, or string) and units if any,
> write a one-sentence description of what the column measures,
> and flag any column whose purpose is not obvious from its name.
> Do not add any columns that are not in the file.
>
> ```
> species,island,bill_length_mm,bill_depth_mm,flipper_length_mm,body_mass_g,sex
> Adelie,Torgersen,39.1,18.7,181,3750,MALE
> Adelie,Torgersen,39.5,17.4,186,3800,FEMALE
> Adelie,Torgersen,40.3,18.0,195,3250,FEMALE
> Adelie,Torgersen,NA,NA,NA,NA,NA
> ```

A typical response:

| Column | Type | Units | Description |
|---|---|---|---|
| `species` | string | | Penguin species (e.g., Adelie, Chinstrap, Gentoo) |
| `island` | string | | Island where the penguin was observed |
| `bill_length_mm` | float | mm | Length of the bill from base to tip; `NA` where not recorded |
| `bill_depth_mm` | float | mm | Depth (height) of the bill at its base; `NA` where not recorded |
| `flipper_length_mm` | integer | mm | Length of the flipper; `NA` where not recorded |
| `body_mass_g` | integer | g | Body mass; `NA` where not recorded |
| `sex` | string | | Sex of the penguin (`MALE`, `FEMALE`, or `NA`) |

The LLM also notes that the fourth data row is all `NA`,
which suggests there are rows with entirely missing measurements that may need to be dropped.

</details>

<details class="explanation" markdown="1">
<summary>Checking the data dictionary</summary>

Start with the column names.
Run `head -1 _extras/penguins.csv` and compare every name in the LLM's table
to the actual header one by one.
A hallucinated column name, or one that was silently corrected, means the dictionary cannot be trusted.

Next, check the value ranges.
Run `cut -d, -f3 _extras/penguins.csv | sort -n | head -3` to see the smallest bill lengths
and `cut -d, -f3 _extras/penguins.csv | sort -n | tail -3` to see the largest.
If the LLM claimed bill length is "typically between 35 and 60 mm",
confirm those numbers match the file.

Finally, check the missing value claim.
Run `grep -c "NA" _extras/penguins.csv` and compare the count
to the LLM's description of how missing values are encoded.
If the LLM said there are two rows with entirely missing values but `grep` finds
`NA` scattered across many rows, the explanation is wrong.

</details>

### Inspect an unfamiliar file with shell tools {: #manage-shell-inspect}

Before opening a data file in Python, you can learn a great deal from the command line in seconds.
Asking an LLM to write the shell commands that reveal encoding, line count, and first few rows
is faster than remembering the exact flags yourself,
and running those commands confirms the file is what it claims to be
before you start analyzing it.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this is too vague:

> How do I look at a CSV file?

The LLM will suggest opening it in a spreadsheet, loading it with Python, or using a text editor.
None of those report the file's encoding before you have committed to opening it,
and none can be scripted into a reproducible workflow.
Fix it by naming the file and the specific properties you want to know.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write and run three shell commands for `_extras/squirrels.csv`:
> one to report its encoding,
> one to count the number of lines,
> and one to show the first three rows.

A typical response:

```sh
file _extras/squirrels.csv
wc -l _extras/squirrels.csv
head -3 _extras/squirrels.csv
```

Running these shows the encoding (`UTF-8 Unicode text`),
the total line count,
and the header plus the first two data rows.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Compare the line count from `wc -l` to the count your collaborator or the dataset documentation claims.
The squirrels census documentation reports 3023 sightings;
`wc -l` returns one more because it counts the header row.
If `file` reports Latin-1 instead of UTF-8,
the file may contain characters outside the ASCII range that will raise errors when you load it into Python.

</details>

### Count distinct values in a column {: #manage-distinct-values}

Before running any analysis on the squirrels dataset,
you want to know how many distinct hectares appear in the data.
A single shell pipeline answers this without loading the file,
but the exact flags for `cut`, `sort`, and `wc` are easy to misremember.
An LLM writes the pipeline in seconds; you verify the result against the documentation.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this is incomplete:

> Count the hectares.

The LLM does not know which file, which column, or which tool you want.
It may write Python when you want a shell one-liner,
or it may include the header row in the count.
Fix it by naming the file, the column position, and the tools.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write and run a shell pipeline that counts the number of distinct values in column 4
> of `_extras/squirrels.csv`, excluding the header row.

A typical response:

```sh
tail -n +2 _extras/squirrels.csv | cut -d, -f4 | sort -u | wc -l
```

Running this returns `339`.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

The official squirrels census documentation says there are 339 hectares.
If your count is 340, the header was not excluded despite `tail -n +2`.
If it is 338,
run `tail -n +2 _extras/squirrels.csv | cut -d, -f4 | sort -u | head -5`
to inspect the first few values for inconsistent formatting
that might split one logical hectare into two distinct strings,
or tell the LLM that its answer is wrong,
explain *how* it is wrong,
and prompt it to try again.

</details>

### Compare a SQLite schema to the original CSV {: #manage-schema-vs-csv}

The penguins data is available both as a CSV and as a SQLite database.
The two should describe the same data,
but a database schema encodes type information that a CSV header cannot.
Checking them against each other can reveal mismatches before they cause silent errors.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write the sqlite3 commands to list all tables in `_extras/example.db`
> and display the full schema of the `penguins` table.

A typical response:

```sh
sqlite3 _extras/example.db ".tables"
sqlite3 _extras/example.db ".schema penguins"
```

The schema shows column types such as `real` and `integer`
that the CSV header does not provide.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Compare every column name in the schema to the CSV header from `head -1 _extras/penguins.csv`;
they should match exactly, including capitalization and underscores.
Then check the declared types against the values you see in the file:
if `flipper_length_mm` is declared as `integer` in the schema
but the CSV contains decimal values in some rows,
queries that filter on that column may behave unexpectedly.

</details>

### Evaluate a dataset's license {: #manage-license}

Before using a public dataset in a paper, you need to know what its license permits.
An LLM can explain what a specific license means,
but you must verify its summary against the actual license text before you rely on it.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this isn't useful:

> Can I use this dataset in my paper?

The LLM does not know which dataset, or whether your concern is the license,
the file permissions, the format, the content, or something else entirely.
Fix it by naming the license and describing your intended use in specific terms.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> The Palmer Penguins dataset is released under a CC0 1.0 Universal license.
> Does this license allow me to use the data in a published paper,
> include it as a downloadable supplement,
> and publish a cleaned version as a separate dataset?

A typical response explains that CC0 releases data into the public domain,
allowing all three uses without any attribution requirement,
though citing the original authors remains good practice.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Read the actual CC0 license at <https://creativecommons.org>
and confirm the LLM's summary for each use case.
Then ask: if the dataset were CC-BY-NC instead of CC0,
which of your three uses would be restricted?
Verify that answer against the CC-BY-NC license text as well.

</details>

### Assess whether a dataset is current enough {: #manage-staleness}

The squirrels dataset was collected in 2018.
Whether that makes it adequate depends entirely on your research question.
An LLM can help you think through the implications,
but the final judgment remains yours.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this cannot be answered:

> Is the squirrels dataset up to date?

"Up to date" means nothing without knowing what question you are trying to answer.
Fix it by stating your research question
and asking whether the dataset's collection date affects your ability to answer it.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> The Central Park squirrel census data was collected in October 2018.
> I want to study whether squirrel fur color distribution has changed over time.
> Is a single year of data from 2018 adequate, and if not, what data would I need?

A typical response explains that a trend question requires at least two comparable time points,
and notes that an earlier squirrel census was conducted in 2012 using similar methods.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Verify the claim about the 2012 census independently before designing a study around it.
If no 2012 census exists, or its methodology is too different to compare,
the LLM's suggestion doesn't help you.
Specific-sounding claims about the existence of external datasets are exactly
what LLMs hallucinate most confidently.

</details>

### Write a useful log entry {: #manage-log-entry}

A log entry that says "used LLM to count squirrels, kept output" is useless six months later.
A useful entry records the exact prompt, the tool, what was kept, and what was changed:
enough for a colleague to reproduce what you did without asking you.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this produces a generic template rather than a useful record:

> Write a log entry for my squirrel analysis.

The LLM doesn't know what details you want recorded,
so it will invent plausible-sounding steps.
Fix it by giving the LLM the specific facts and asking it only to format them.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I asked you to write a shell command to count squirrel sightings by primary fur color.
> The output showed gray as the most common color.
> Write a log entry based on our conversation in this session
> with five fields: date, prompt sent, tool used, output kept (yes/no), corrections made.

A typical response produces a structured entry with all five fields,
recording the exact prompt text and the specific correction rather than a paraphrase.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Confirm the log entry contains the exact prompt you sent, not a reworded version.
(Remember, LLMs can hallucinate about themselves…)
If you can,
ask a colleague whether they could reproduce your steps from the log entry alone.

</details>

### Add a defensive assertion to a data loading script {: #manage-assertion}

A script that loads a CSV and proceeds without checking its shape will silently produce wrong results
if the file is truncated, gains an extra column, or is replaced by a different dataset.
A two-line assertion can catch these problems immediately at the point of loading.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this is too vague to produce a useful assertion:

> Make my data loading script safer.

"Safer" could mean any number of things.
Fix it by naming the specific conditions you want to catch and the exact expected values.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have a Polars script that loads `_extras/penguins.csv`.
> Add two assertions after loading:
> one that raises an error if the number of columns is not 7,
> and one that raises an error if the number of rows is fewer than 340.
> Print the actual shape before checking.

A typical response:

```python
import polars as pl

df = pl.read_csv("_extras/penguins.csv")
print(f"Shape: {df.shape}")
assert df.shape[1] == 7, f"Expected 7 columns, got {df.shape[1]}"
assert df.shape[0] >= 340, f"Expected at least 340 rows, got {df.shape[0]}"
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the script against the real file and confirm both assertions pass.
Then verify the column assertion fires when it should:
run `cut -d, -f1-5 _extras/penguins.csv > /tmp/short.csv`,
change the filename in the script to `/tmp/short.csv`,
and confirm the script raises `AssertionError` with the expected message.
If the assertion passes when it should fail, the check is wrong.

</details>

### Inspect a CSV for blank rows {: #manage-blank-rows}

Blank rows in a CSV cause subtle errors:
a `wc -l` count that includes them will not match a Python row count,
and some parsers silently process empty records.
Checking for them before loading costs almost nothing.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write two shell commands for `_extras/squirrels.csv`:
> one that counts completely blank lines (lines with no characters at all),
> and one that counts lines where the first field is empty (lines starting with a comma).
> Explain the difference between the two checks.

A typical response:

```sh
grep -c "^$" _extras/squirrels.csv
grep -c "^," _extras/squirrels.csv
```

The LLM explains that `^$` matches lines with no characters,
while `^,` catches rows where the first field is missing but later fields may have values.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

A count of zero for both commands means neither problem is present.
If `grep -c "^$"` returns a non-zero count,
run `grep -n "^$" _extras/squirrels.csv | head -3` to find which line numbers are blank
and determine whether they represent missing records or file corruption.
A non-zero count from `grep -c "^,"` means some rows are missing their first field,
which may indicate that the delimiter or encoding is not what you assumed.

</details>

### Compare CSV and Parquet for a specific workflow {: #manage-format-tradeoff}

You have collected a dataset with ten million rows and need to decide whether to store it as CSV or Parquet.
The right answer depends on your workflow.
An LLM can explain the tradeoffs,
but a generic answer that does not account for your specific constraints is not useful.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this produces a textbook comparison:

> What is the difference between CSV and Parquet?

The LLM lists the standard advantages and disadvantages
without connecting them to how you will actually use the data.
Fix it by describing your workflow.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have a dataset with 10 million rows that I will share with two collaborators who use Python.
> I will version it in Git.
> Most analyses filter by date and by a categorical column.
> Give one concrete reason to prefer CSV and one to prefer Parquet.

A typical response notes that CSV is easiest to share and inspect manually but too large for Git,
while Parquet is compact and fast to filter but requires a compatible reader.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

There is no easy way to check a claim like this if you don't already know the answer.
A web search might be helpful, but an increasing number of "answers" are LLM-generated,
and just as likely to be wrong as the one you get by prompting the LLM directly.
In cases like this, you must rely on your own logic or ask a more knowledgeable colleague.

</details>

## Exercises

1.  Prompt an LLM to download the Palmer Penguins CSV and confirm that the file arrived intact.
    -   How does it check the latter?
1.  Prompt an LLM to extract one column and count how many distinct values it contains.
    -   Did the LLM use shell commands, Python, or something else?
    -   Were you able to read and validate its method?
1.  Prompt an LLM to generate a data dictionary for the penguins CSV.
    -   Verify its claims against the actual file.
1.  Prompt an LLM to describe the squirrels dataset.
    -   Then prompt it to evaluate its own answer.
1.  Prompt an LLM to convert `penguins.csv` to JSON.
    -   Count the records in both files and confirm they match.
    -   Check three rows by hand to make sure values were not renamed or dropped.
    -   Prompt an LLM to find out what it did with missing values, then verify that answer against the file.
1.  Prompt an LLM to convert the penguins JSON back to CSV.
    -   Compare the result to the original CSV.
    -   If there are any differences, trace where each one came from.
1.  Review your log files from the day.
    -   Identify the prompt that required the most iterations and explain why.
1.  Commit your scripts and logs with descriptive messages.
    -   Prompt an LLM to review your commit messages and suggest improvements.
1.  Write a short script that samples 20 rows from the penguins dataset with a fixed random seed
    -   Run it twice and confirm you get the same rows both times
    -   Change the seed by one and confirm the sample changes
1.  Write a `.gitignore` file for this project.
    -   Prompt an LLM to review it and identify any common patterns you missed.
1.  Prompt an LLM to draft a README for your project.
    -   Verify that every dependency it lists is actually used and every step it describes actually works.
