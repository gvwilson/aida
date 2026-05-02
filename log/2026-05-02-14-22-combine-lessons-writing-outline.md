# Combine Lessons and Writing Outline

## Prompts

1.  Create a new log file. Combine `database/index.md` and `analyze/index.md` into a new file
    `coding/index.md`. Consolidate general advice, but keep advice specific to SQL and Python.
    Keep all of the exercises. Once you are done, delete the original files. Title the new lesson
    "Coding" and add it to `README.md` after deleting references to the old lessons. When you are
    done, create a new lesson `writing/index.md` and outline a lesson on using LLMs for scientific
    writing. Use H2 section headings and lists rather than creating one flat list.

## Actions

-   Read `database/index.md` and `analyze/index.md`
-   Created `coding/index.md` combining both lessons:
    -   General sections: prompting strategy, common LLM errors, verification
    -   SQL section: SQL-specific errors, SQL-specific verification
    -   Python section: Polars reading/inspection, identifying problems, cleaning,
        verification, code quality, group stats, unreliable interpretations, validation
    -   All exercises from both original files, grouped under SQL and Python subheadings
-   Created `writing/index.md` as a new lesson outline with sections on:
    what LLMs help with, what they get wrong, prompting for drafts, prompting for editing,
    verification, academic integrity, and exercises
-   Updated `README.md`: replaced `database` and `analyze` entries with `coding`,
    added `writing` after `visualize`
-   Deleted `database/index.md`, `analyze/index.md`, and their directories
