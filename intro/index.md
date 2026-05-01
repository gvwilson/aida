# Introduction

-   What the workshop covers: the full data analysis pipeline from finding data to sharing results
-   The tool stack
    -   Marimo: computational notebook
    -   Polars: dataframes
    -   Altair: visualization
    -   SQLite: database
    -   bash: shell
    -   Git: version control
    -   Command-line LLM tool such as Claude Code
-   Setting up the environment
    -   Check the `uv` virtual environment
    -   Launch Marimo
-   Concerns about LLMs
    -   Hallucination and confabulation
    -   Environmental cost
    -   Labor issues in training data
    -   Effects on research employment
-   Ground rules
    -   Always verify LLM output
    -   Note which parts of your work are LLM-assisted
    -   Keep a log: create dated Markdown files in `log/` to record prompts given and actions taken
-   Exercises
    1.  Set up your project directory and verify that all required tools are installed and importable
    1.  Create your first log file and record the commands you ran during setup
    1.  Prompt Claude to explain what each tool in the stack does
        -   Compare its answers to the official documentation and note discrepancies
    1.  Identify one concern about LLM use in research that is not listed above and explain why it matters
    1.  Find and read the license for the Palmer Penguins dataset
        -   Record what it permits and prohibits
    1.  Write a prompt asking an LLM to summarize this workshop's goals
        -   Evaluate whether the summary is accurate
