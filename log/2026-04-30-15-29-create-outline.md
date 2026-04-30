# Create Outline

**Date (UTC):** 2026-04-30 15:29

## Prompts Given

1. Read CLAUDE.md, read the lessons mentioned in CLAUDE.md, and add a section 'Outline' to README.md immediately before "Acknowledgments" with a detailed point-form outline of topics to be covered in this one-day workshop.

2. Revise outline: use Altair/Polars/Marimo instead of matplotlib/pandas/Jupyter; add log file creation as a recommendation; expand material on how LLMs work; remove repetition of prerequisite material (basic Git workflow, etc.) to focus on LLM use; add material on MCP, agents, skills, and Claude Code.

3. Show the revised outline as a two-level point-form list before adding to README.md.

4. Add the outline to README.md.

5. Read prompt.txt and update the outline accordingly.

## Contents of prompt.txt

- Do not use a browser-based LLM. Instead, use modern command-line tools and/or components integrated into other tools that are recommended.
- Put more emphasis on how to check that the LLM is doing the right thing (and connect it with "how to check that data analysis is correct in general").
- Explain how to use an LLM to *create* a data dictionary as well as verify it.
- There must be at least six exercises per section.
- Are the LLM mistakes with `NULL` that you identify actually common? Justify this claim.
- Explain when and how to use tools like `ruff`, and how to use an LLM to find and correct code smells.
- The 'pipeline review' and 'critical evaluation checklist' portions of the Conclusion feel generic: remove them.

## Actions Taken

- Read `README.md`, `intro/index.md`, `finale/index.md`, and prerequisite tutorials in `$HOME/carp/` and `$HOME/sqlshort/`
- Drafted a nine-lesson outline (Introduction, How LLMs Work, Interacting with LLMs, Finding and Fetching Data, Querying Data with SQL, Cleaning and Analyzing Data, Visualizing Results, Keeping Records, Conclusion)
- Added `## Outline` section to `README.md` immediately before `## Acknowledgments`
- Updated outline based on prompt.txt:
    - Replaced "browser-based LLM" with "command-line LLM tools such as Claude Code" throughout
    - Added verification emphasis to How LLMs Work, Querying Data, Cleaning and Analyzing, and Visualizing sections, explicitly connecting to general data analysis checking practices
    - Added LLM-as-creator of data dictionaries (not just verifier) to Finding and Fetching Data
    - Expanded each section from one exercise to six
    - Removed the `= NULL` vs `IS NULL` claim after research found no empirical evidence that LLMs make this mistake commonly; replaced with the actually-documented common LLM SQL errors (schema hallucination, faulty joins, aggregation mistakes, missing filters, NULL sorting)
    - Added `ruff` for linting LLM-generated code and LLM-assisted code smell detection to Cleaning and Analyzing Data
    - Removed "Pipeline review" and "Critical evaluation checklist" bullets from Conclusion
- Created `log/` directory and this log file

## Decisions

- Used Palmer Penguins dataset as the running example throughout (consistent with `sqlshort`)
- Replaced matplotlib/pandas/Jupyter with Altair/Polars/Marimo per project requirements
- Omitted basic Git mechanics (init, add, commit, push) from content bullets as learners already know these from prerequisites; Git coverage focuses on analysis-specific concerns (.gitignore patterns, what to track, commit message quality)
- Exercises grouped under an "Exercises" bullet with nested items rather than a single "Exercise:" bullet per section
