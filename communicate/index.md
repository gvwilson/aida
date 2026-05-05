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

## Examples

### Draft a methods paragraph describing a data cleaning step {: #communicate-methods-para}

After dropping rows with missing values from the penguins dataset,
you need to document what you did so that someone else could reproduce your analysis.
A methods paragraph is not a casual summary; it needs to be specific enough to replicate.
You can ask an LLM to draft one,
but you must supply all the relevant facts yourself,
or it will invent them.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A vague prompt like this produces text that sounds like a methods section but is not one:

> Write a methods section for my penguin analysis.

The LLM has no idea what methods you actually used,
so it will invent plausible-sounding ones.
It might claim you removed outliers when you did not,
or report a sample size that is wrong.
The prose will be fluent and the passive voice will be impeccable,
but the content will be fiction.
The fix is to give it the specific facts first and ask it only to arrange them into sentences.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I cleaned a CSV file for a penguin morphology analysis.
> The original file had 344 rows and 7 columns
> (species, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex).
> I dropped all rows where any measurement column was missing,
> which removed 11 rows and left 333 rows with complete measurements.
> I standardized the `sex` column to uppercase (`MALE`, `FEMALE`, or `NA`).
> Write one paragraph suitable for a biology journal methods section
> describing these two cleaning steps.
> Use the passive voice and be specific about the numbers.

A typical response:

> Raw penguin morphological data were obtained as a comma-separated values file
> containing 344 records across seven variables.
> Records with missing values in any of the four morphological measurement columns
> (bill length, bill depth, flipper length, and body mass) were excluded,
> reducing the dataset to 333 complete cases.
> The sex variable was standardized to uppercase
> to ensure consistent encoding across all records.

</details>

<details class="explanation" markdown="1">
<summary>Checking the methods paragraph</summary>

Verify every number against your actual data.
The paragraph claims 344 original rows: run `wc -l _extras/penguins.csv`
and subtract one for the header to confirm.
It claims 333 rows after cleaning: run your cleaning script,
print the shape of the resulting dataframe, and confirm.

Read the paragraph aloud and ask whether every sentence could only apply to your data
or whether it could describe any dataset.
"Records with missing values were excluded" applies to thousands of projects;
"11 rows were excluded because at least one morphological measurement was missing" is specific.
Generic sentences are a sign that the LLM padded the paragraph with nothing.

Finally, check whether the paragraph describes only what you told it.
If the LLM added a step you did not mention,
such as removing duplicate rows or converting units,
it invented that step and you must remove it.

</details>

### Reformat a citation from author-date to numbered style {: #communicate-citation-reformat}

Different journals require different citation formats, and reformatting a reference by hand is tedious and error-prone.
An LLM can reformat citations quickly, but it occasionally transposes author names, garbles titles, or invents page numbers.
Every field of the result must be verified against the original source.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this leaves too much to chance:

> Reformat this citation for a journal.

The LLM does not know which journal, which citation style, or which reference you mean.
It may produce something that looks plausible but uses the wrong style entirely.
Fix it by naming the citation style and pasting the full reference text.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Reformat this reference into numbered citation style for PLOS ONE:
> Gorman KB, Williams TD, Fraser WR (2014) Ecological sexual dimorphism
> and environmental variability within a community of Antarctic penguins.
> PLoS ONE 9(3): e90081.

A typical response:

> 1. Gorman KB, Williams TD, Fraser WR. Ecological sexual dimorphism and environmental variability
>    within a community of Antarctic penguins. PLoS ONE. 2014;9(3):e90081.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Look up the paper and check every field: author order, year, full title, journal name,
volume number, issue number, and article identifier.
Pay particular attention to author initials, which LLMs frequently swap.
If PLOS ONE has publicly available author guidelines, confirm the citation format against those
rather than assuming the LLM used the correct style.

</details>

### Write alt text for a data visualization {: #communicate-alt-text}

Alt text allows screen reader users to understand what a chart shows.
Most researchers omit it entirely because writing good alt text is harder than it looks.
An LLM can draft it from chart code alone,
but the draft must be checked against the actual rendered chart.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this produces alt text that could apply to any histogram:

> Write alt text for my histogram.

The LLM will produce something like "a histogram showing the distribution of values,"
which tells a screen reader user nothing specific.
Fix it by pasting the chart code so the LLM can read the actual variables, units, and data source.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Here is Altair code that generates a histogram of `body_mass_g` for all penguins.
> Write one sentence of alt text that describes what the chart shows,
> including the variable name, its units, and the approximate shape of the distribution.
> [paste the chart code]

A typical response:
"Histogram of penguin body mass in grams (range approximately 2700--6300 g),
showing a roughly bell-shaped distribution with a slight right skew
and a peak near 3500--4000 g."

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Render the chart and compare its actual x-axis range and distribution shape
to what the alt text claims.
Verify the range against the Polars DataFrame:
`pl.read_csv("_extras/penguins.csv")["body_mass_g"].drop_nulls().min()` and `.max()`.
If the LLM described the shape as "roughly symmetric" but the chart shows a clear skew,
the alt text is misleading and must be corrected.

</details>

### Add a regression line to a scatter plot {: #communicate-regression-line}

A scatter plot of two continuous variables becomes more informative when it includes a regression line
showing the direction and approximate slope of the relationship.
An LLM can add this to existing Altair code,
but you must confirm that the line goes in the direction the data actually support.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have an Altair scatter plot of `bill_length_mm` on the x-axis versus `body_mass_g` on the y-axis
> for all penguins, with points colored by `species`.
> Add a single linear regression line across all penguins (ignoring species) using Altair's `transform_regression`.
> Draw the line in gray so it does not conflict with the species colors.

A typical response adds a second layer to the existing chart:

```python
regression = base.transform_regression(
    "bill_length_mm", "body_mass_g"
).mark_line(color="gray")
chart = scatter + regression
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Render the chart and confirm the regression line slopes upward from left to right.
The Pearson correlation between `bill_length_mm` and `body_mass_g` is positive,
so an upward slope is the only correct result.
If the line slopes downward, either the x and y encodings are swapped
or the regression was computed on the wrong columns.
Also check that the line extends across the full range of the data, not just a subset.

</details>

### Add descriptive axis labels and a title {: #communicate-axis-labels}

Altair uses column names as default axis labels, which are often machine-readable rather than human-readable.
A chart labeled `bill_length_mm` communicates less than one labeled "Bill length (mm)."
An LLM can replace default labels in seconds,
but you must confirm that each label is accurate and includes units.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this produces unpredictable changes:

> Make my chart look more professional.

"Professional" is not specific enough.
The LLM may change the color scheme, add gridlines, or alter the font size
without touching the axis labels that most need improvement.
Fix it by asking specifically for the labels and title you need.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> My Altair histogram of `body_mass_g` uses the default axis labels.
> Update it so the x-axis label reads "Body mass (g)",
> the y-axis label reads "Number of penguins",
> and the chart has a title that describes what it shows rather than just naming the variable.

A typical response updates the encoding with explicit `title` parameters
and adds `.properties(title="Distribution of penguin body mass")`.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Render the chart and read each label aloud.
Confirm the x-axis label includes units.
Ask whether the title describes what the chart shows or just what data it uses:
"Penguin body mass" is a data label; "Distribution of penguin body mass across three species" is a chart description.
If the title could apply equally to a table or a list of numbers, it is not specific enough.

</details>

### Expand a one-sentence result into a results paragraph {: #communicate-results-paragraph}

A results section does not just report numbers;
it interprets them and acknowledges their limitations.
An LLM can expand a bare finding into a paragraph,
but it often removes hedges that matter scientifically,
and you must put them back.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Expand this one-sentence result into a two-paragraph results section for a biology journal:
> "Bill length was positively correlated with body mass (Pearson r = 0.59, p < 0.001, n = 333)."
> Do not imply causation.
> Do not remove any hedging language from the original sentence.

A typical response produces two paragraphs describing the strength and direction of the correlation
and noting that the relationship was observed across all three species combined.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Read both paragraphs and mark every hedge or qualifier present in the original sentence.
Check whether each survived the expansion.
"Positively correlated" should not become "birds with longer bills tend to be heavier"
if that phrasing implies a directional relationship not supported by the correlation alone.
Also check whether the LLM added any claim that goes beyond what a correlation coefficient can show,
such as predicting body mass from bill length without fitting an explicit regression.

</details>

### Draft an LLM use disclosure statement {: #communicate-disclosure}

Many journals now require authors to disclose whether they used LLM tools in preparing a manuscript.
Every disclosure should name the tool, state how it was used,
and describe how the output was verified.
An LLM can help you draft this statement,
but you must supply the specific facts.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

A prompt like this produces a generic template:

> Write an LLM disclosure statement for my paper.

The LLM knows nothing about which tool you used, how you used it, or how you verified the output.
It will write a statement that could describe anyone's use of any tool.
Fix it by providing the specific details.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Write a one-paragraph disclosure statement for a biology paper.
> I used an LLM (Claude Sonnet, Anthropic, accessed January 2025) to draft the methods section.
> I verified every number in the draft against my analysis script.
> I rewrote three sentences where the draft described steps I did not perform.

A typical response produces a statement that names the tool, version, and access date,
describes the specific use (drafting the methods section),
and summarizes the verification steps.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Check that the statement includes all four elements a journal is likely to require:
model name and version, access date, description of use, and description of verification.
Ask a colleague to read it and identify any claim they would want to verify before submitting the paper.
If the statement says you "reviewed" the draft but does not say what you checked,
it is not specific enough to be useful.

</details>

### Evaluate a log-scale axis choice {: #communicate-log-scale}

A log scale makes it easier to see proportional differences across a wide range of values
and harder to see absolute differences.
An LLM can add a log scale to a chart in seconds,
but whether that choice helps or hinders depends on the data,
and you must make that judgment yourself.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have an Altair bar chart showing mean bill length per penguin species.
> Render it with a linear y-axis and again with a log-scale y-axis.
> Then explain in one sentence when a log scale is appropriate and when it is not.

A typical response adds `.scale(type="log")` to the y encoding
and explains that a log scale is appropriate when values span several orders of magnitude
or when proportional comparisons matter more than absolute differences.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Render both charts and compare them.
Mean bill lengths for the three species differ by only a few millimetres,
so the log-scale version will look nearly identical to the linear version.
The LLM's explanation of when to use a log scale may be correct in general
but inapplicable to this specific dataset.
If it recommended the log scale without noting that the data do not span multiple orders of magnitude,
the recommendation is not grounded in the actual values.

</details>

### Translate a statistical result into plain language {: #communicate-plain-language}

A plain-language summary of a statistical result must be accurate without being technical.
The challenge is that simplification often removes precision,
and an LLM will sometimes remove a hedge that changes the scientific meaning of the sentence.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Translate this result into plain language suitable for a science blog aimed at curious non-specialists:
> "Bill length was significantly positively correlated with body mass across all three species
> (Pearson r = 0.59, p < 0.001, n = 333)."
> Do not introduce any causal claim not present in the original.

A typical response produces something like:
"Across the 333 penguins in the dataset, birds with longer bills tended to be heavier,
and this pattern was unlikely to be due to chance."

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Check the translation for three types of error.
First, causal language: "birds with longer bills tended to be heavier" is acceptable;
"longer bills make penguins heavier" is not.
Second, missing qualifications: the original says "across all three species combined";
if the translation implies the relationship holds within each species separately, that may not be true.
Third, invented precision: if the translation adds a specific example ("for every extra millimeter of bill...")
that was not in the original, it is adding information the data do not support.

</details>

### Summarize a methods paragraph in one sentence {: #communicate-methods-summary}

Summarizing your own methods paragraph is harder than it looks,
because you know too much to notice when you have omitted something essential.
An LLM can produce a one-sentence summary,
but you must check whether a reader who only sees the summary could still reproduce the key steps.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Summarize this methods paragraph in one sentence, preserving every detail
> a reader would need in order to reproduce the data cleaning step:
> [paste the methods paragraph from the earlier example]

A typical response:
"Eleven records missing at least one morphological measurement were removed from the 344-row
penguin dataset, leaving 333 complete cases with the sex variable standardized to uppercase."

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Read the summary and ask: if this were the only description a collaborator had,
could they reproduce the cleaning exactly?
Check whether the summary mentions the number of rows removed (11),
the remaining count (333),
and the specific columns that were checked for missing values.
If any of these are missing, add the omitted detail and ask the LLM to revise.
A summary that says only "rows with missing values were removed" is accurate but not reproducible.

</details>

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
