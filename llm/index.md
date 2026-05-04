# How LLMs Work

## Tokenization

-   Text is split into [%g token "tokens" %] before being processed
    -   A token is roughly 4 characters of English text
-   [%g tokenization "Tokenization" %] uses [%g bpe "Byte-Pair Encoding (BPE)" %]:
    common character sequences are merged into single tokens
-   One word can become several tokens: `"tokenization"` → `["token", "ization"]`
-   Capitalization matters: `"Cat"` and `"cat"` often have different token IDs
-   Non-English text is less efficiently tokenized:
    a Chinese character may be one token, but an emoji can be three or four
-   The same sentence tokenized by two different models may produce different token counts
-   Approximate rule of thumb: 1,000 English words ≈ 1,300 tokens
-   Token IDs are integers fed to the model
    -   The model never sees raw characters

```python
import anthropic
client = anthropic.Anthropic()
response = client.messages.count_tokens(
    model="claude-opus-4-6",
    messages=[{"role": "user", "content": "penguin bill length in millimeters"}]
)
print(response.input_tokens)   # number of tokens
```

-   Why token count matters
    -   API pricing is per token
    -   Input and output priced separately
-   Context window limits are measured in tokens, not words or characters

## The transformer architecture

-   A [%g transformer "transformer" %] is a stack of identical layers
    -   GPT-class models have dozens of layers
-   Each layer applies two operations: multi-head self-attention, then a feed-forward network
-   [%g self_attention "Self-attention" %] lets every token look at every other token in the context
    and decide how much to "attend" to each one
-   Attention weights are learned during training, not hand-coded
-   The feed-forward network applies a learned non-linear transformation to each token independently
-   Model size is measured in [%g model_parameters "parameters" %] (learned weights)
    -   Current [%g frontier_model "frontier models" %] have hundreds of billions
-   More parameters generally means better performance but higher cost and slower inference
-   The final layer outputs a probability distribution over the entire vocabulary (all possible next tokens)
-   The model does not "decide" the next token
    -   It assigns probabilities and then samples

## Training

-   [%g pre_training "Pre-training" %]: the model learns to predict the next token on a massive text corpus
-   Corpora include web pages, books, academic papers, and code — typically hundreds of billions of tokens
-   No human writes the training signal
    -   The loss is simply how wrong the next-token prediction was
-   The model stores statistical associations between tokens, not a lookup table of facts
-   [%g fine_tuning "Supervised fine-tuning" %] (SFT):
    the pre-trained model is further trained on curated instruction-response pairs
-   [%g rlhf "Reinforcement learning from human feedback" %] (RLHF): human raters rank model outputs
    -   The model is updated to produce higher-ranked responses
-   Fine-tuning is much cheaper than pre-training but still requires significant compute
-   Domain-specific fine-tuning (e.g., on medical literature) can improve accuracy in that domain
    without retraining from scratch

## Context windows

-   The [%g context_window "context window" %] is
    the maximum number of tokens the model can process in a single call,
    including both prompt and response
-   Current models range from ~8K tokens (smaller models) to over 1M tokens (long-context models)
-   Everything in the context window is processed together
    -   The model has no persistent memory between separate API calls
-   When a conversation exceeds the context limit, the application must truncate or summarize earlier content
-   Longer contexts cost more per call and have higher latency
-   Very long contexts can cause the model to pay less attention to information in the middle
    (the "lost in the middle" effect)
-   The context window includes the system prompt, conversation history, retrieved documents, and the response

## Temperature and sampling

-   After computing the probability distribution over next tokens, the model must choose one
-   [%g temperature "Temperature" %] scales the distribution before sampling:
    -   Low temperature sharpens it
    -   High temperature flattens it
-   Temperature 0: always pick the most probable token
    -   Output is deterministic for the same input
-   Temperature 1: sample proportionally from the distribution
    -   Output varies between calls
-   Temperature > 1: more random, often less coherent
    -   Useful for creative tasks
-   [%g top_p "Top-p (nucleus) sampling" %]: restrict sampling to
    the smallest set of tokens whose cumulative probability exceeds p (e.g., 0.9)
-   Most APIs expose both `temperature` and `top_p` as parameters

```python
import anthropic
client = anthropic.Anthropic()
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=256,
    temperature=0,  # deterministic
    messages=[{"role": "user", "content": "List three penguin species."}]
)
print(response.content[0].text)
```

-   Setting temperature to 0 does not guarantee identical outputs across model versions

## Training data cutoff

-   Model weights are frozen after training
    -   The model cannot learn new information without retraining or fine-tuning
-   The [%g training_cutoff "training cutoff" %] is
    the date after which new events and publications are not reflected in the model
-   The model may still generate confident-sounding text about post-cutoff events
    by extrapolating from prior patterns
-   Library APIs change after the cutoff
    -   LLMs frequently generate code using deprecated or removed functions

```python
# LLM may suggest the old Polars API:
df.groupby("species").agg(...)   # deprecated in Polars >= 0.19

# Correct current API:
df.group_by("species").agg(...)
```

-   Always check generated code against the current version of the documentation,
    not the LLM's description of it
-   Models are often vague about their exact cutoff date
    -   Treat stated cutoffs as approximate

## Hallucination

-   The model always generates the statistically most plausible continuation of the prompt
    -   It has no mechanism to refuse to answer
-   If the training data lacked coverage of a topic,
    the model fills the gap with plausible-sounding text
-   [%g hallucination "Hallucination" %] is not random noise
    -   It is coherent-sounding text that is factually wrong
    -   Also called [%g confabulation "confabulation" %]
-   Citations are particularly unreliable
    -   The model may generate a real author's name with a fabricated title and DOI
-   URLs are invented
    -   A hallucinated URL may look valid but return a 404
-   Numeric facts (population figures, p-values, dates) are common hallucination sites
-   The model does not know when it is hallucinating
    -   Confidence in tone is not correlated with accuracy
-   Hallucination rates vary by domain
    -   Well-covered topics (Python basics) hallucinate less than obscure ones (niche library internals)
-   Longer, more specific prompts with examples tend to reduce hallucination

## Retrieval-augmented generation

-   [%g rag "Retrieval-augmented generation" %] (RAG) augments the prompt
    with text retrieved from an external source at query time
-   The external source is typically a [%g vector_database "vector database" %]
    -   Documents are converted to [%g embedding "embedding vectors" %] and stored
-   At query time, the query is also embedded and the most similar document chunks are retrieved
-   Retrieved chunks are inserted into the prompt as context before the LLM generates a response
-   RAG reduces hallucination on domain-specific questions
    because the model has accurate source text in its context window
-   RAG does not eliminate hallucination: the model may still misread or misquote the retrieved text
-   The quality of retrieval depends on how well documents are chunked and how good the embedding model is
-   RAG requires maintaining and updating the document store as source material changes

## Checking LLM output

-   Does the result have the right shape?
    -   A list when a list was prompted for, a number when a number was prompted for, etc.
-   Are values in a plausible range?
    -   A mean bill length of 4600 mm is implausible for penguins
-   Does the output match an independent source?
    -   Cross-check a statistic against the original dataset
-   Does the code actually run without errors?
    -   Try running it
-   Does the code produce the same result on a small test case you can compute by hand?
-   Does the code give the right answer on the simplest possible input?
    -   An empty list, a single row, or all-identical values are the easiest cases to check by hand
    -   These boundary cases catch off-by-one errors and wrong defaults that plausible-looking inputs hide
-   Does the code preserve a quantity that should be conserved?
    -   A cleaning step should not change the total row count unless rows were explicitly dropped
    -   A normalization step should produce values that sum to 1.0
    -   A reformatting step should not change the number of records
-   When deciding whether a number is "close enough,"
    ask whether the difference is smaller than the natural variation in the data
    -   A discrepancy of 0.1 mm in penguin bill length means something different that
	    a discrepancy of 0.1 in a probability
    -   If the discrepancy is smaller than the measurement error in your data,
	    it is probably not worth worrying about
-   Are all package names and function signatures correct for the installed version?
-   These are the same questions to ask when checking any data analysis, LLM-generated or not

```python
# Quick sanity check: does the generated summary statistic match direct computation?
llm_answer = 43.9   # LLM claimed this was mean bill length for Adelie penguins
actual = df.filter(pl.col("species") == "Adelie")["bill_length_mm"].mean()
assert abs(llm_answer - actual) < 0.1, f"Mismatch: LLM={llm_answer}, actual={actual:.1f}"
```

-   Spot-checking is not sufficient for high-stakes decisions
    -   Full verification is required

## Exercises

1.  Use an LLM API to count tokens in the sentence "penguin bill length in millimeters"
    -   Then count tokens for the same sentence in another language and compare
1.  Prompt an LLM to describe the Polars `group_by` function
    -   Check its claims against the current Polars documentation and log any discrepancies
1.  Ask the same factual question twice with temperature 0 and then twice with temperature 1
    -   Record how often the high-temperature answers differ and what this implies for reproducibility
1.  Prompt an LLM to describe an event that occurred after its training cutoff
    -   Record how it signals (or fails to signal) uncertainty
1.  Prompt an LLM to cite three peer-reviewed papers on penguin bill morphology
    -   Look up the DOIs and/or titles it provides: do the papers exist? Are the citations accurate?
1.  Prompt an LLM to explain its own limitations regarding training data cutoffs
    -   Evaluate whether the explanation is accurate and complete based on what you have learned in this lesson
1.  Prompt an LLM to write a function that computes the mean of a list of numbers
    -   Test it on an empty list, a list with one element, and a list where all elements are identical
    -   Record which boundary cases (if any) it handled correctly without being told to
