# Keep Records

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

1.  Review your log files from the day
    -   Identify the prompt that required the most iterations and explain why
1.  Commit your scripts and logs with descriptive messages
    -   Prompt Claude to review your commit messages and suggest improvements
1.  Write a `.gitignore` file for this project
    -   Prompt Claude to review it and identify any common patterns you missed
1.  Prompt Claude to draft a README for your project
    -   Verify that every dependency it lists is actually used and every step it describes actually works
1.  Identify one result in your analysis that you could not reproduce if you deleted the `log/` directory
    -   Describe what the log provides that the code alone does not
1.  Prompt Claude to rewrite a section of your analysis script to be more readable
    -   Run `ruff` on both versions and compare the results
