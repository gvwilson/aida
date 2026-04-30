# Create Outline

**Date (UTC):** 2026-04-30 15:29

## Prompts Given

1. Read CLAUDE.md, read the lessons mentioned in CLAUDE.md, and add a section 'Outline' to README.md immediately before "Acknowledgments" with a detailed point-form outline of topics to be covered in this one-day workshop.

2. Revise outline: use Altair/Polars/Marimo instead of matplotlib/pandas/Jupyter; add log file creation as a recommendation; expand material on how LLMs work; remove repetition of prerequisite material (basic Git workflow, etc.) to focus on LLM use; add material on MCP, agents, skills, and Claude Code.

3. Show the revised outline as a two-level point-form list before adding to README.md.

4. Add the outline to README.md.

## Actions Taken

- Read `README.md`, `intro/index.md`, `finale/index.md`, and prerequisite tutorials in `$HOME/carp/` and `$HOME/sqlshort/`
- Drafted a nine-lesson outline (Introduction, How LLMs Work, Interacting with LLMs, Finding and Fetching Data, Querying Data with SQL, Cleaning and Analyzing Data, Visualizing Results, Keeping Records, Conclusion)
- Added `## Outline` section to `README.md` immediately before `## Acknowledgments`
- Created `log/` directory and this log file

## Decisions

- Used Palmer Penguins dataset as the running example throughout (consistent with `sqlshort`)
- Replaced matplotlib/pandas/Jupyter with Altair/Polars/Marimo per project requirements
- Omitted basic Git mechanics (init, add, commit, push) from the outline as learners already know these from prerequisites; focused Git coverage on analysis-specific concerns (.gitignore patterns, what to track)
