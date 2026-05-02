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
