# Visualize Results

## Altair's grammar of graphics: data, mark, and encoding

-   Common mark types: `.mark_point()`, `.mark_bar()`, `.mark_line()`, `.mark_rect()`
-   Encoding channels: `x`, `y`, `color`, `size`, `tooltip`, and `facet`
-   Interaction: selection

## Prompt Claude for Altair code and check against the documentation before running

-   LLMs frequently use outdated APIs

## Verify a chart

-   Does it show the expected number of points?
-   Do axis ranges match the data?
-   Does the color legend list all categories?

## Save charts as PNG or SVG with `.save()`

## Iterat with Claude Code help

-   Add a regression line
-   Change axis scale
-   Facet by a categorical variable

## Accessibility: colorblind-safe color schemes, meaningful axis labels, readable font sizes

-   Prompt Claude to check charts against these criteria
-   Prompt Claude to generate alt text describing a chart from code and from prompt plus code

## Exercises

1.  Use Claude Code to generate a histogram of body mass
    -   Verify that the x-axis range matches the min and max from the Polars DataFrame
1.  Use Claude Code to generate a bar chart of mean bill length by species
    -   Check that the number of bars matches the number of distinct species
1.  Use Claude Code to generate Altair code using a method that does not exist
    -   Identify the error and prompt Claude to fix it using the current API
1.  Add a `tooltip` encoding showing body mass and island
    -   Verify that hovering displays both fields correctly
1.  Replace the default color scheme with a colorblind-safe palette suggested by Claude Code
    -   Verify it against a colorblindness simulator
1.  Prompt Claude to facet the scatter plot by island
    -   Confirm that each facet contains only penguins from that island
