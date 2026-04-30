# AI Data Analysis

<div class="row" markdown="1">
<div class="col-6" markdown="1">

## Lessons

<div id="lessons" markdown="1">

1.  [Introduction](@/intro/)
1.  [Conclusion](@/finale/)

</div>

</div>
<div class="col-6" markdown="1">

## Appendices

<div id="appendices" markdown="1">

1.  [License](@/license/)
1.  [Code of Conduct](@/conduct/)
1.  [Contributing](@/contributing/)
1.  [Bibliography](@/bibliography/)
1.  [Glossary](@/glossary/)

</div>
</div>
</div>

## Outline {: #outline}

-   Introduction (~45 minutes)
    -   What the workshop covers: the full data analysis pipeline from finding data to sharing results
    -   The tool stack: Marimo (reactive notebooks), Polars (dataframes), Altair (visualization), SQLite (database), bash (shell), Git (version control), and a browser-based LLM
    -   Setting up the environment: checking the `uv` virtual environment, launching Marimo, verifying imports
    -   Concerns about LLMs: hallucination and confabulation, environmental cost, labor issues in training data, effects on research employment
    -   Ground rules: always verify LLM output, note which parts of your work are LLM-assisted, keep a log
    -   Keeping a log: creating dated Markdown files in `log/` to record prompts given and actions taken
    -   Exercise: set up your project directory, create your first log file, and record what you have done so far

-   How LLMs Work (~1 hour)
    -   Tokenization: how words and sub-words map to integer token IDs, why token count matters for cost and limits
    -   The transformer architecture: attention mechanisms, predicting the next token from context
    -   Training: what it means to train on a large corpus, why the model stores statistical associations rather than facts
    -   Context windows: what they are, why size matters, what happens when a conversation exceeds the limit
    -   Temperature and sampling: why the same prompt can produce different answers, determinism vs. randomness
    -   Training data cutoff: why LLMs do not know about recent events and may cite outdated library APIs
    -   Hallucination and confabulation: why LLMs generate plausible-sounding but incorrect answers, how common this is
    -   Retrieval-augmented generation (RAG): how grounding an LLM in documents or databases reduces hallucination
    -   Exercise: ask an LLM to describe a Polars function, check the answer against the actual documentation, and log any discrepancies

-   Interacting with LLMs (~1 hour)
    -   Chat interfaces: writing effective prompts (specific, contextualized, step-by-step reasoning), iterative refinement
    -   The API: when to use it instead of a chat window, authentication, and cost
    -   Model Context Protocol (MCP): what it is, how it gives an LLM structured access to tools such as databases, files, and APIs
    -   Worked MCP example: connecting an LLM to a local SQLite file and querying it without writing SQL yourself
    -   Agents: how they differ from a single chat turn, how they plan and execute multi-step tasks, and their failure modes
    -   Skills and extensions: finding and installing them, writing a simple skill that automates a repeated prompt pattern
    -   Claude Code: running an LLM coding assistant in the terminal with access to your project files
    -   Exercise: use an MCP SQLite extension to answer a question about the penguins dataset without writing any SQL, and log the experience

-   Finding and Fetching Data (~1 hour)
    -   Where datasets live: government open data portals, Zenodo, Kaggle, GitHub repositories, and institutional repositories
    -   Evaluating a dataset before using it: license, provenance, documentation quality, size, and date last updated
    -   Shell commands for inspection: `curl -O`, `head -n`, `wc -l`, `cut -d, -f`, and `file`
    -   Common format tradeoffs: CSV (simple but fragile), JSON (nested but verbose), SQLite (queryable), Parquet (typed and efficient)
    -   Using an LLM to decode a README or data dictionary: worked example with Palmer Penguins metadata
    -   Verifying the LLM's summary against actual column names, units, and value ranges in the file
    -   Exercise: download the Palmer Penguins CSV, inspect it with shell commands, ask an LLM to summarize the columns and their units, and verify at least three claims the LLM makes

-   Querying Data with SQL (~1 hour)
    -   Connecting to a SQLite database from a Marimo notebook using the `sqlite3` module
    -   Asking an LLM to write queries: `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, joins, and subqueries
    -   The verification workflow: run the query, check row counts, spot-check values, ask the LLM to explain any clause you do not understand
    -   Common LLM mistakes with `NULL`: confusing `= NULL` with `IS NULL`, silently dropping rows
    -   Iterating when the first query is wrong: describing the error clearly and asking for a targeted fix
    -   Moving query results into Polars with `pl.read_database()`
    -   Exercise: use an LLM to write three queries of increasing complexity (basic select, filtered aggregate, join with `NULL` handling), verify each one, and log the prompts and any corrections needed

-   Cleaning and Analyzing Data (~1 hour)
    -   Reading data into Polars: `pl.read_csv()`, `pl.read_database()`, `pl.scan_csv()` for large files
    -   Inspecting a DataFrame: `.schema`, `.head()`, `.describe()`, `.null_count()`
    -   Identifying problems: missing values, wrong data types, inconsistent string values, and implausible outliers
    -   Asking an LLM for Polars cleaning code and checking that it uses the Polars API, not pandas
    -   Common cleaning operations: `.drop_nulls()`, `.fill_null()`, `.cast()`, `.str.strip_chars()`, `.with_columns()`
    -   Verifying cleaning: comparing null counts and DataFrame shape before and after
    -   Group statistics and correlation: `.group_by().agg()`, `pl.pearson_corr()`
    -   Identifying unreliable LLM interpretations: invented significance levels, wrong direction of effect
    -   Exercise: fix three data quality issues in a messy dataset using LLM-generated Polars code, verify each fix, and write one sentence of interpretation you are confident in

-   Visualizing Results (~1 hour)
    -   Altair's grammar of graphics: data, mark, and encoding as the three core components of a `Chart`
    -   Asking an LLM for Altair code and checking against the documentation before running (LLMs frequently use outdated Altair API versions)
    -   Common mark types: `.mark_point()`, `.mark_bar()`, `.mark_line()`, `.mark_rect()`
    -   Encoding channels: `x`, `y`, `color`, `size`, `tooltip`, and `facet`
    -   Accessibility: colorblind-safe color schemes, meaningful axis labels, readable font sizes
    -   Interactive charts in Marimo: selection, tooltips, and linked views
    -   Saving charts with `.save()` to PNG or SVG
    -   Iterating with LLM help: adding a regression line, changing axis scale, faceting by a categorical variable
    -   Exercise: use an LLM to generate a scatter plot of bill length vs. bill depth colored by species, fix one error in the generated code, add a body-mass tooltip, and save the figure

-   Keeping Records (~1 hour)
    -   Why reproducibility matters: re-running analysis after data updates, auditing your own work, sharing with reviewers
    -   Project directory structure: `data/`, `scripts/`, `notebooks/`, `results/`, `figures/`, `log/`
    -   What to put in log files: prompts given, which LLM outputs were used vs. discarded, corrections made, and why
    -   `.gitignore` patterns for analysis projects: raw data files, derived outputs that can be regenerated, `__pycache__/`
    -   Using an LLM to draft a project README: what to ask for, and what to verify (dependencies, method description, accuracy)
    -   Documenting LLM use for research integrity: noting which parts of an analysis are LLM-assisted
    -   Exercise: review your log files from the day, commit scripts and logs with descriptive messages, use an LLM to draft a README, and verify its accuracy

-   Conclusion (~30 minutes)
    -   Pipeline review: find → fetch → query → clean → analyze → visualize → record
    -   Critical evaluation checklist: row count checks, spot-checking values, reading generated code before running, verifying API calls against documentation
    -   When LLMs accelerate analysis vs. when they substitute for understanding you need to develop yourself
    -   Environmental and social impact revisited: energy cost per inference, labor behind training data, implications for research careers
    -   Where to go next: Marimo, Polars, and Altair documentation, communities, and staying current without becoming dependent
    -   Exercise: identify one result from today's work you would verify before including in a paper or report, and describe specifically how you would do it

## Acknowledgments {: #acknowledgments}

[*Greg Wilson*][wilson-greg] is a programmer, author, and educator based in Toronto.
He was the co-founder and first Executive Director of Software Carpentry
and received ACM SIGSOFT's Influential Educator Award in 2020.

<p class="center">
  <em>
    start where you are
    &middot;
    use what you have
    &middot;
    help who you can
  </em>
</p>

[repo]: https://github.com/gvwilson/aida
[wilson-greg]: https://third-bit.com/
