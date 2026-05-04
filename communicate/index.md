# Communicating

-  Writing and visualization

## Why use an LLM for scientific writing

-   Scientists have used spell checkers and citation managers since they were invented
-   LLMs are "just" a more powerful version of these
    -   The word "just" is doing a lot of work in that sentence
-   If you stop thinking about what you are saying,
    you stop saying anything worth reading

## What LLMs can help with

-   Drafting: producing a rough first version of a methods section, abstract, or cover letter
-   Editing: suggesting ways to shorten sentences, improve flow, or reduce jargon
-   Summarizing: condensing a long paper into a paragraph to check your own understanding
-   Reformatting: converting references to a required citation style
-   Translation: moving text between registers (e.g., technical to plain-language summary)

## What LLMs get wrong

-   Fabricating citations: producing plausible-sounding but nonexistent references
-   Overstating confidence: removing hedges and qualifications that matter in scientific prose
-   Losing precision: substituting near-synonyms that change the meaning of a claim
-   Generic phrasing: producing sentences that sound polished but say nothing specific
-   Misrepresenting methods: paraphrasing a procedure in ways that omit critical details

## Prompt for drafts

-   Provide the specific claim you want to make before asking for prose
-   Include the key numbers, citations, or conditions that must appear
-   Ask for a draft, not a final version: plan to rewrite rather than just accept
-   Specify the audience and register explicitly (e.g., "write for a methods section in a biology journal")

## Prompt for editing

-   Paste your own text and ask for specific changes, not a general rewrite
-   Ask it to flag passive constructions, not eliminate them: some are correct
-   Ask it to identify long sentences rather than shorten them automatically
-   Ask why a suggested change improves the text: vague style advice is not useful

## Verify LLM-generated writing

-   Check every citation against the actual source
    -   You *do* use a citation manager, right?
-   Confirm that quantitative claims match your data or the cited paper
-   Read the output aloud: fluent prose can hide missing substance
-   Ask a colleague to read it without knowing an LLM was involved: does it sound like you?

## Academic integrity

-   Follow your institution's policy on LLM use in submitted work
    -   If the institution has one, that is
-   Disclose LLM assistance where required or where it is a reasonable expectation
-   Do not submit LLM-generated text as your own analysis or interpretation
-   The LLM is not responsible for errors in your paper: you are

## How to document LLM use

-   Model identification
-   Prompts (e.g., include the log files with your datasets and results)
-   How you verified its work

> ChatGPT-4o (OpenAI, accessed March 2025) was used to assist with
> initial coding of interview transcripts. All AI-generated codes were
> reviewed and revised by the authors. Prompts used are provided in
> Supplement S2.

## Altair Basics

-   Common mark types: `.mark_point()`, `.mark_bar()`, `.mark_line()`, `.mark_rect()`
-   Encoding channels: `x`, `y`, `color`, `size`, `tooltip`, and `facet`
-   Interaction: selection
-   Save charts as PNG or SVG with `.save()`

## Verify a chart

-   Does it show the expected number of points?
-   Do axis ranges match the data?
-   Does the color legend list all categories?

## Iterate with LLM help

-   Add a regression line
-   Change axis scale
-   Facet by a categorical variable

## Accessibility

-   Colorblind-safe color schemes, meaningful axis labels, readable font sizes, alt text
    -   An LLMs can do the tedious work, so no longer any excuse *not* to do all this
-   Prompt an LLM to check charts against these criteria
-   Prompt an LLM to generate alt text describing a chart from code and from prompt plus code

## Exercises

1.  Write a two-sentence summary of a paper you have read recently
    -   Ask an LLM to expand it into a full abstract paragraph
    -   Identify two places where the expansion added words without adding meaning
1.  Paste a methods paragraph from your own work into an LLM and ask it to shorten it by 30%
    -   Check whether any shortened version omits information a reader would need to reproduce the experiment
1.  Ask an LLM to generate three citations supporting a specific claim in your field
    -   Look up each citation and report how many are real,
        how many are fabricated,
        and how many exist but do not support the claim
1.  Take a sentence from a paper that uses the passive voice correctly
    (e.g., "Samples were centrifuged at 3000 rpm")
    -   Ask an LLM to rewrite the paragraph in the active voice
    -   Evaluate whether every change it made actually improved the prose
1.  Write a one-paragraph plain-language summary of a technical result
    -   Ask an LLM to revise it for a general audience
    -   Identify one place where the revision introduced an error or overstatement
1.  Ask an LLM to write a cover letter for a paper submission to a specific journal
    -   Identify every sentence that could apply to any paper by any author
    -   Rewrite those sentences to say something specific about your work
1.  Prompt an LLM to generate a histogram of body mass
    -   Verify that the x-axis range matches the min and max from the Polars DataFrame
1.  Prompt an LLM to generate a bar chart of mean bill length by species
    -   Check that the number of bars matches the number of distinct species
1.  Prompt an LLM to generate Altair code using a method that does not exist
    -   Identify the error and prompt LLM to fix it using the current API
1.  Add a `tooltip` encoding showing body mass and island
    -   Verify that hovering displays both fields correctly
1.  Replace the default color scheme with a colorblind-safe palette suggested by the LLM
    -   Verify it against a colorblindness simulator
1.  Prompt an LLM to facet the scatter plot by island
    -   Confirm that each facet contains only penguins from that island
1.  Prompt an LLM to generate a [%g q_q_plot "Q-Q plot" %] of `body_mass_g` for Gentoo penguins
    to check whether body mass is approximately normally distributed
    -   Verify that both axes are labeled and that a diagonal reference line is drawn
    -   Generate a perfectly normal sample of the same size and confirm its Q-Q plot is straight
1.  Use the squirrel census to count sightings per hectare,
    then prompt an LLM to generate a [%g lorenz_curve "Lorenz curve" %]
    showing how unevenly sightings are distributed across hectares
    -   Verify that the curve starts at (0, 0) and ends at (1, 1)
    -   Verify that the curve bows noticeably below the diagonal line of perfect equality
    -   If the curve does not satisfy either condition, trace the bug in the LLM's code
1.  Download the [NOAA GISTEMP][gistemp] global mean surface temperature anomaly dataset
    -   Prompt an LLM to plot the time series and add a vertical marker line at 1988
        (the year James Hansen testified to the US Senate about climate change)
    -   Verify that the marker falls on the correct year and is visible against the background
    -   Check that the x-axis labels show years, not integer indices
1.  Prompt an LLM to generate a 2D bin plot (heatmap) of `bill_length_mm` vs. `body_mass_g`
    for all penguins, where color encodes the count of observations in each bin
    -   Verify that the color scale increases with count
    -   Verify that the axis ranges cover all the data
    -   Check whether empty bins are shown as a neutral color rather than the lowest-count color
