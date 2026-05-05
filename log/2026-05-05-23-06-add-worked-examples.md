# Add Worked Examples to manage, code, communicate, learn

## Prompt

The `manage`, `code`, `communicate`, and `learn` lessons need worked examples as well as exercises.

0. Start a new log file. Copy this entire prompt into it before doing anything else.

1. Create a H2 heading `Examples` immediately before `Exercises` in each `index.md` file.

2. Each example must start with a brief H3 header summarizing the problem to be solved. See the H2 headers in $HOME/unbreak/interpy/index.md for style.

3. Each example must have a one-paragraph description of the problem, which must be relevant to the material in the lesson.

4. Examples may have starter code and/or starter data, such as Python files, shell scripts, JSON or CSV files, etc. These must be stored in files in the lesson's directory and included in the `index.md` file using mccole's `%inc` inclusion tag.

5. Each example may include a prompt that is not useful to show how not to use LLMs. In this case, the example must discuss how the prompt sends the LLM in the wrong direction, how to spot that, and how to correct it. This discussion must be in a `<details class="explanation" markdown="1">` with a `<summary>` containing the words "Reveal".

6. Each example must include a useful brief prompt for an LLM that satisfies the guidelines given in this tutorial, followed by the output or result. The prompt and its output or result must also be wrapped in `details` as above.

7. Each example must include the question "How can we check this?", followed by a discussion of how a human being can test, check, verify, or validate the LLM's output. The discussion must be wrapped in a `details` as above.

8. Each example may then have another prompt/output/validation sequence continuing on from the useful one to show how to use LLMs in a cyclic workflow.

9. Write the first example for each lesson and prompt me to check them before proceeding to write more.

## Actions

- Read prompt.txt
- Ran `brief .` to get project overview
- Read manage/index.md, code/index.md, communicate/index.md, learn/index.md
- Read $HOME/unbreak/interpy/index.md for H3 header style
- Read _extras/links.md, _extras/penguins.csv header for dataset details
- Created log file 2026-05-05-23-06-add-worked-examples.md
- Added first example to manage/index.md: "Generate a data dictionary for the penguins CSV"
- Added first example to code/index.md: "Count the number of penguins of each species"
- Added first example to communicate/index.md: "Draft a methods paragraph describing a data cleaning step"
- Added first example to learn/index.md: "Get an explanation of what standard deviation measures"
- Prompted user to review before adding more examples
