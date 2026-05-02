# Visualizing Results

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
