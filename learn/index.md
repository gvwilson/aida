# Learning

## LLMs as tutors

-   The appeal is obvious
    -   Ask as many questions as you want, whenever you want
    -   Ask for a different explanation if the first doesn't make sense
    -   Don't feel stupid in front of other people
-   The limitations are equally obvious
    -   The tutor makes things up
    -   You never learn how to do things yourself

## Getting explanations at the right level

-   LLMs calibrate their explanations to cues in the prompt
    -   "I'm an undergraduate" produces shorter sentences and more analogies
    -   "I have a Ph.D. in statistics" produces fewer hand-waves and more precision
-   Be explicit about what you already know and what you do not
    -   Weak: "Explain p-values."
    -   Stronger: "I know a p-value is a probability but I don't understand what it's a probability *of*.
        Explain in two paragraphs without assuming I know calculus."
-   Ask for multiple explanations if the first one does not click
    -   "Try a different analogy" is a useful prompt
-   Ask for a concrete example before an abstract definition
    -   Most people understand examples before principles, not the other way around

## Using examples and analogies

-   Prompt the LLM to show you before it tells you
    -   "Give me a worked example, then explain the rule it illustrates"
-   Prompt it for the example to use data you already know
    -   "Show me how to compute the mean bill length per species using the penguins dataset"
-   Prompt it for a bad example alongside a good one
    -   "Show me a histogram that is badly binned and one that is well-binned, using the same data"
-   Analogies break down: prompt the LLM to explain where its analogy stops working
    -   "You compared p-values to fire alarms. Where does that analogy fail?"
-   An example you can run is more useful than one you can only read
    -   Paste the code into a notebook and make sure it actually does what the LLM claimed

## Testing your own understanding

-   Explaining something is harder than recognizing a correct explanation
    -   Write a short paragraph in your own words, then prompt the LLM to check it
-   Prompt the LLM to quiz you
    -   "Ask me three questions about what I just read, then tell me which answers I got wrong"
-   Prompt for common misconceptions
    -   "What do beginners usually get wrong about confidence intervals?"
-   Resist the urge to look at the LLM's answer before writing your own
    -   The moment you read the answer, you will convince yourself you already knew it

## What LLMs get wrong as tutors

-   Hallucination in explanations: technically fluent but factually wrong
    -   Particularly common for specialist or niche topics
-   [%g sycophancy "Sycophancy" %]: telling you what you want to hear
    -   If you say "so it's basically the same as X, right?", the LLM is inclined to agree
    -   Ask "Is there anything wrong with this description?" rather than "Is this right?"

<div class="callout" markdown="1">

Why does the wording of that question matter?
LLMs are trained using reinforcement learning from human feedback (RLHF),
where human raters rank model responses.
Raters tend to prefer responses that are agreeable and helpful-sounding,
so the model learns that confirming what the user said
is more likely to be rated positively than contradicting them.
This is called *sycophancy*: optimizing for approval rather than accuracy.
Asking "Is there anything wrong with this?" explicitly invites disagreement
and shifts the model toward a more critical mode.
A quick test: tell an LLM something subtly wrong
("the p-value is the probability that the null hypothesis is true, right?")
and compare what you get from "Is this right?" versus "Is there anything wrong with this description?"

</div>

-   Skipping steps
    -   LLMs often omit the step they consider obvious,
        which is often exactly the step you are confused about
    -   Ask "Walk me through this step by step and don't skip anything, even the trivial parts"
-   Overlong answers that bury the key point
    -   Ask for a one-sentence version before the full explanation
-   No memory across sessions
    -   A new conversation starts with no record of what you covered before
    -   You have to re-establish context every time

## Checking what you learned

-   An explanation that makes sense in the moment may still be wrong
    -   The feeling of understanding and actual understanding are not the same thing
-   Cross-check key claims against a textbook, documentation, or a reliable reference
-   Run the code: if the LLM explains that a function works a certain way, test it on a small example
-   Ask a second source, including a different LLM
    -   Two independent hallucinations that agree are still hallucinations
-   Try to use the concept before deciding you understand it
    -   Explaining penguin bill length distributions becomes easier after looking at the actual histogram
-   The hardest cases to catch are explanations that are roughly right but subtly misleading
    -   Checking for "plausible but wrong" requires knowing enough to be suspicious

## Examples

### Get an explanation of what standard deviation measures {: #learn-std-dev}

Standard deviation appears in almost every analysis you will run,
but "the spread around the mean" is not precise enough to be useful.
You can ask an LLM to explain it at your level,
but you need to prompt it specifically enough to get a genuinely useful answer,
and then you need to check whether the explanation is correct
before you rely on it.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

This prompt produces a generic answer calibrated to no one in particular:

> Explain standard deviation.

The LLM will give you a textbook definition,
probably followed by a formula using sigma notation,
and possibly followed by an example that means nothing to you
because it uses abstract numbers rather than data you have seen.
Worse, the LLM will often skip the step you are confused about
because it considers that step obvious.
Fix it by stating what you already know,
what you do not understand,
and what kind of example you want.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> I have taken one semester of statistics and I know what a mean is.
> Explain standard deviation in two paragraphs using penguin bill lengths as the example.
> Do not use a formula.
> Describe concretely what the number measures and what a larger versus smaller value tells me
> about the data.

A typical response:

> Imagine you have measured the bill lengths of 152 Adelie penguins.
> The mean bill length is about 38 mm.
> Some penguins have bills very close to 38 mm,
> and others have bills several millimetres longer or shorter.
> Standard deviation measures how far a typical penguin's bill sits from that average.
> If the standard deviation is 2 mm,
> most penguins have bills within roughly 2 mm of 38 mm,
> and very few are more than 4 mm away.
>
> A larger standard deviation means the measurements are spread more widely around the mean.
> If Gentoo penguins had a standard deviation of 5 mm in bill length,
> you would find many more Gentoos whose bills are 7 or 8 mm from the average
> than you would among Adelies.
> Standard deviation does not tell you anything about the shape of the distribution
> only how tightly or loosely the values cluster around the center.

</details>

<details class="explanation" markdown="1">
<summary>Checking the explanation</summary>

Compute the standard deviation yourself and see whether the example numbers hold up.
In Python, `import polars as pl` and then
`pl.read_csv("_extras/penguins.csv").filter(pl.col("species") == "Adelie")["bill_length_mm"].std()`
gives the actual standard deviation for Adelie bill lengths.
If the LLM claimed "most penguins are within 2 mm of the mean" but the actual standard deviation
is 3 mm, the example was wrong.

Then ask the LLM a deliberately skeptical follow-up:
"Is there anything misleading about that explanation?"
Compare what it says to a textbook definition.
LLMs often gloss over the fact that standard deviation specifically measures
spread around the *arithmetic* mean and is sensitive to outliers,
which matters when a few extreme values are present.

Finally, ask the LLM "Where does the analogy break down?"
to see whether it can identify the limits of its own explanation.
An LLM that cannot critique its explanation is a less reliable tutor than one that can.

</details>

### Write your own definition before asking the LLM {: #learn-write-first}

Writing your own explanation of a concept before reading an LLM's version
is more useful than reading first.
Once you see an explanation, you will feel like you already understood it,
but this feeling is often wrong.
Writing first reveals exactly where your understanding breaks down.

<details class="explanation" markdown="1">
<summary>A prompt that sends the LLM in the wrong direction</summary>

Reading the LLM's answer first defeats the purpose:

> Explain confidence intervals to me, then ask me if I understood.

If you read the explanation before writing anything yourself,
you will anchor your understanding on the LLM's version
rather than discovering what you actually know.
Fix it by writing first, then asking for feedback on what you wrote.

</details>

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

Write a one-paragraph definition of confidence intervals in your own words before reading any further.
Then send this prompt:

> Here is my explanation of confidence intervals: [paste your paragraph].
> Identify one thing I got right and one thing I got wrong or left out.
> Do not rewrite my explanation; just point to the specific gap.

A typical response identifies the specific claim that is incorrect,
often the interpretation of "95% confidence",
and explains why it is wrong without replacing the student's own language.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

After getting the LLM's feedback, revise your paragraph and ask it to check the revision.
Then look up the definition of a confidence interval in a statistics textbook
and compare the textbook definition to your revised version.
If your revised version matches the LLM's feedback but not the textbook,
the LLM's feedback may have introduced a different error.

</details>

### Compare badly-binned and well-binned histograms {: #learn-histogram-bins}

The number of bins in a histogram changes what the distribution looks like.
Too few bins hide structure; too many bins make noise look like signal.
Seeing both extremes on the same data makes the difference concrete
in a way that a verbal description cannot.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Generate two Altair histograms of `bill_length_mm` for Adelie penguins:
> one with 3 bins and one with 30 bins.
> Explain what information each version obscures.

A typical response produces both histograms and notes that 3 bins merge distinct groups
while 30 bins fragment continuous regions into jagged spikes driven by sampling noise.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run both histograms and look at them side by side.
The 3-bin version should make the distribution look nearly flat;
the 30-bin version should show many individual spikes.
Then ask the LLM: "How would I choose the number of bins for a dataset I have never seen before?"
A good answer mentions rules of thumb such as the square root of sample size or Sturges' formula,
but notes that these are starting points, not definitive answers.
Verify one of these rules by computing the recommended bin count for 152 Adelie penguins.

</details>

### Find where an analogy breaks down {: #learn-analogy-limits}

Analogies make abstract concepts tangible, but every analogy has a point where it misleads.
Asking an LLM to identify the limits of its own analogy tests whether it understands the concept
well enough to know where the comparison fails.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> You compared p-values to fire alarms: a small p-value is the alarm going off.
> Explain where that analogy breaks down.
> Be specific about a case where the analogy would lead a student to draw a wrong conclusion.

A typical response identifies at least one key failure:
a fire alarm has a fixed threshold, but a p-value threshold is chosen by the researcher,
and different thresholds give different conclusions from the same data.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Evaluate whether the LLM's critique identifies the most important limitation.
Another common failure of the fire alarm analogy is that a fire alarm either rings or it does not,
while a p-value is a continuous number:
a p-value of 0.049 and one of 0.051 describe nearly identical evidence,
but the analogy suggests they mean completely different things.
If the LLM did not mention this, ask it explicitly:
"What happens to the analogy when p = 0.049 versus p = 0.051?"

</details>

### Identify common misconceptions about a statistical concept {: #learn-misconceptions}

Knowing what you are likely to get wrong is as useful as knowing what is correct.
An LLM can list common misconceptions about a concept,
but you must verify those descriptions against a reliable source,
because the LLM can describe a misconception incorrectly.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> What do beginners most commonly misunderstand about the difference between
> a confidence interval and a prediction interval?
> List two misconceptions and explain why each one is wrong.

A typical response notes that students often believe a 95% confidence interval contains 95% of the data
(it does not; a prediction interval does),
and that students often treat confidence intervals as probability statements about a fixed parameter
(a Bayesian credible interval does this; a frequentist confidence interval does not).

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Look up one of the two misconceptions in a statistics textbook or the relevant Wikipedia article
and confirm that the LLM's description of it is accurate.
Then compute a 95% confidence interval for the mean Adelie bill length using the penguins dataset
and a 95% prediction interval for the bill length of a single new Adelie penguin.
Confirm that the prediction interval is wider,
as a correct understanding of the difference would predict.

</details>

### Ask for a brief explanation before the full one {: #learn-brief-first}

A one-sentence explanation of a concept is more useful than it looks.
If you cannot summarize it in one sentence, you do not understand it well enough to apply it.
Asking for the brief version first also gives you something to check the longer explanation against.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Explain linear regression in exactly one sentence.
> Then give the full explanation in two paragraphs using the relationship between
> bill length and body mass in the penguins dataset as the example.

A typical one-sentence response:
"Linear regression finds the line through a scatterplot that minimizes the sum of squared
vertical distances from each point to the line."

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Read the one-sentence explanation and ask: does it contain enough information to be useful on its own?
Can you use it to identify whether linear regression is the right tool for a new problem?
Then read the full explanation and check whether every claim in it is consistent with the one-sentence version.
If the full explanation introduces something that contradicts or cannot be reconciled with the one-sentence version,
one of the two is wrong.

</details>

### Re-establish context in a new session {: #learn-new-session}

LLMs have no memory across sessions.
Starting a new conversation is like starting over with a collaborator who has forgotten everything you discussed.
Understanding how much context you need to re-establish makes you a more effective user of these tools.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

Start a fresh LLM session with no history, then send this prompt:

> Continue explaining `group_by` in Polars where we left off.

Record what the LLM does.
Then send a follow-up that re-establishes context:

> I am learning Polars for the first time.
> I understand that `group_by` splits the data into groups,
> but I do not understand the `.agg()` call that comes after it.
> Explain what `.agg()` does and why it is necessary.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Compare the two responses.
The first should be confused or generic because it has no context.
The second should be specific and useful because you provided the missing background.
Count the facts you had to re-provide,
such as your experience level, the library, the specific concept, and your existing knowledge,
and consider whether there is a more efficient way to establish context at the start of a session.

</details>

### Test for sycophancy with a wrong statement {: #learn-sycophancy-test}

LLMs are trained to produce responses that humans rate positively.
This makes them inclined to agree with you, even when you are wrong.
Testing this directly with a statement you know is false shows you how much to trust agreement.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

Send this prompt to an LLM:

> Standard deviation is basically the same as variance, right?

Then, in a separate session, send this version:

> Is there anything wrong with saying that standard deviation is basically the same as variance?

Compare the two responses.

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

The first prompt often produces agreement or mild qualification ("they are related...").
The second prompt, which explicitly invites disagreement, more often produces a clear correction:
standard deviation is the square root of variance, they have different units,
and substituting one for the other in an interpretation will be wrong by a factor of the standard deviation itself.
If both responses agreed with the false statement, the LLM is exhibiting strong sycophancy
and you should treat its confirmations of your understanding with more skepticism.

</details>

### Ask about a function then verify with a query {: #learn-verify-with-query}

An LLM's explanation of how a function works is only as useful as your ability to run it.
Reading an explanation is passive; running a query that should fail if the explanation is wrong
makes the learning active and the verification concrete.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Explain what the SQL `coalesce` function does.
> Then write a SQLite query that uses `coalesce` on the penguins table to return
> `body_mass_g` for each penguin, replacing any null value with -1.
> Show me the first five rows of the result.

A typical response explains that `coalesce` returns the first non-null argument from a list,
then produces:

```sql
select species, coalesce(body_mass_g, -1) as body_mass_g
from penguins
limit 5;
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the query and find a row where `body_mass_g` was null in the original data.
Confirm it now shows -1 in the result.
Then run `select count(*) from penguins where body_mass_g is null` to count the original nulls
and `select count(*) from penguins where coalesce(body_mass_g, -1) = -1` to count the replacements.
If the two counts differ, the `coalesce` expression is not doing what the LLM described.

</details>

### Compute a concept before deciding you understand it {: #learn-compute-first}

Reading that "the median is the middle value" is not the same as understanding
how the median behaves when the data are skewed, what happens with an even number of values,
or how it differs from the mean in practice.
Computing the concept on real data reveals details that a verbal explanation leaves out.

<details class="explanation" markdown="1">
<summary>A prompt that works</summary>

> Explain in one sentence how the median differs from the mean.
> Then write Polars code that computes both the median and the mean of `bill_length_mm`
> for each penguin species separately.

A typical response explains that the median is the middle value when data are sorted,
making it less sensitive to outliers than the mean, and produces:

```python
import polars as pl

df = pl.read_csv("_extras/penguins.csv")
result = df.group_by("species").agg([
    pl.col("bill_length_mm").median().alias("median"),
    pl.col("bill_length_mm").mean().alias("mean"),
])
```

</details>

<details class="explanation" markdown="1">
<summary>Checking the output</summary>

Run the code and compare the median and mean for each species.
If the median and mean are nearly identical for all three species,
the bill length distribution is roughly symmetric within each species.
If they differ by more than 0.5 mm for any species,
ask the LLM whether that species' distribution is skewed,
and confirm by looking at a histogram.
This is the kind of detail that "median is less sensitive to outliers" does not make concrete on its own.

</details>

## Exercises

1.  Find a concept in statistics that you find confusing
    (e.g., confidence intervals, p-values, or the difference between variance and standard deviation)
    -   Prompt an LLM to explain it to someone who has taken one semester of statistics
    -   Write a one-paragraph explanation in your own words
    -   Prompt the LLM to identify any errors in your explanation
1.  Prompt an LLM to explain how `group_by` works in Polars, using the penguins dataset as an example
    -   Run the example it provides
    -   Ask it to re-explain the step you found hardest to follow, using a different analogy
1.  Prompt an LLM to quiz you on the content of the "How LLMs Work" lesson in this tutorial
    -   Answer three questions without looking back at the lesson
    -   Review the LLM's feedback and record which concepts you actually understood
        versus which ones you only recognized
1.  Prompt an LLM "Is it accurate to say that an LLM looks up facts from its training data?"
    -   Then ask "Is there anything misleading about that description?"
    -   Compare the two responses and explain why the second question changed the answer
1.  Prompt an LLM to explain a statistical concept, then ask the same question to a different LLM
    -   Identify one claim both LLMs made
    -   Verify that claim against a textbook or the relevant Wikipedia article
1.  Prompt an LLM to walk you through computing the standard deviation of bill lengths
    for Adelie penguins step by step, without skipping any steps
    -   Identify any step it omitted or got wrong
    -   Verify the final answer by computing it yourself using the penguins dataset
