# Introduction

## What the workshop covers

-   The full data analysis pipeline from finding data to sharing results

## The tool stack

-   bash: shell
-   [uv][uv]: package and project management
-   [Marimo][marimo]: computational notebook
-   [Polars][polars]: dataframes
-   [Altair][altair]: visualization
-   [SQLite][sqlite]: database
-   Git: version control
-   [llm][llm]: command-line tool for interacting with LLMs

## Setup

-   Create the `uv` virtual environment
-   Install software
-   Create directory structure

## Concerns about LLMs

-   Hallucination and confabulation
-   Environmental cost
-   Labor issues in training data
-   Effects on research employment

## Ground rules

-   Always verify LLM output
-   Keep a log
-   Report which parts of your work are LLM-assisted
-   Learn as you go

## Exercises

1.  Set up your project directory and verify that all required tools are installed and importable
1.  Create your first log file and record the commands you ran during setup
1.  Prompt an LLM to explain what each tool in the stack does
    -   Compare its answers to the official documentation and note discrepancies
1.  Identify one concern about LLM use in research that is not listed above and explain why it matters
1.  Find and read the license for the Palmer Penguins dataset
    -   Record what it permits and prohibits
1.  Write a prompt asking an LLM to summarize this workshop's goals
    -   Evaluate whether the summary is accurate
