# Glossary

## A

<span id="agent">agent</span>
:   An LLM application that runs an observe-plan-act loop, using tool
    calls to gather information and take actions over multiple steps
    rather than producing a single response.

## B

<span id="bpe">Byte-Pair Encoding (BPE)</span>
:   A tokenization algorithm that repeatedly merges the most frequent
    adjacent byte or character pair, building a vocabulary of subword
    units used to split text into tokens.

## C

<span id="confabulation">confabulation</span>
:   Another term for hallucination; emphasizes that the model is
    producing coherent-sounding but fabricated content rather than
    retrieving stored facts. The two words are used interchangeably
    in the literature.

<span id="context_window">context window</span>
:   The maximum number of tokens a language model can process in a
    single call, including both the prompt (system message,
    conversation history, retrieved documents) and the response.

## D

<span id="data_dictionary">data dictionary</span>
:   A document or table that describes each column in a dataset: its
    name, data type, units, allowed values, and meaning. A good data
    dictionary lets a new user understand the dataset without reading
    the original collection code or paper.

## E

<span id="embedding">embedding</span>
:   A numeric vector that represents a piece of text in a
    high-dimensional space such that semantically similar texts have
    similar vectors; used in retrieval-augmented generation to find
    relevant documents.

<span id="eda">exploratory data analysis</span>
:   The process of summarizing, visualizing, and investigating a
    dataset to understand its structure, identify anomalies, and
    uncover patterns before formal modeling or hypothesis testing.

<span id="exponential_backoff">exponential backoff</span>
:   A retry strategy in which the delay between successive attempts
    increases exponentially (e.g., 1s, 2s, 4s, 8s) to reduce load on a
    service that has returned a rate-limit or server error.

## F

<span id="few_shot">few-shot prompting</span>
:   A prompting technique that includes one or more example
    input-output pairs in the prompt to show the model the desired
    format or behavior before posing the actual query.

<span id="fine_tuning">fine-tuning</span>
:   Additional training of a pre-trained model on a smaller, curated
    dataset to improve its performance on a specific task or domain;
    includes supervised fine-tuning (SFT) and reinforcement learning
    from human feedback (RLHF).

<span id="frontier_model">frontier model</span>
:   One of the most capable large language models currently available,
    typically from a major AI lab and trained at enormous scale; the
    term is relative and shifts as new models are released.

## G

## H

<span id="hallucination">hallucination</span>
:   The generation of plausible-sounding but factually incorrect text
    by a language model, also called confabulation; occurs because the
    model generates the statistically most likely continuation of a
    prompt rather than verifying facts.

## I

## J

<span id="json_schema">JSON schema</span>
:   A vocabulary for describing the structure and constraints of JSON
    documents, including required fields, data types, and allowed
    values; used in MCP tool definitions to specify the expected
    format of inputs and outputs.

<span id="json_rpc">JSON-RPC</span>
:   A lightweight remote procedure call protocol that encodes requests
    and responses as JSON; used by the Model Context Protocol to let
    LLM clients call tools on a local or remote server.

## K

## L

<span id="linter">linter</span>
:   A tool that analyzes source code without running it and reports
    style violations, unused imports, undefined variables, and other
    common mistakes.

<span id="lorenz_curve">Lorenz curve</span>
:   A plot of the cumulative share of something held by the bottom *x*
    fraction of the population (sorted from least to most); a
    perfectly equal distribution produces the 45-degree diagonal,
    while any inequality bows the curve below it.

## M

<span id="mcp">Model Context Protocol</span> (MCP)
:   An open standard using JSON-RPC that allows LLM applications to
    connect to external tools and data sources — such as databases,
    file systems, and web search — through a common interface.

<span id="model_parameters">model parameters</span>
:   The numeric weights of a neural network, learned during training;
    model size is typically measured in the number of parameters, with
    current frontier models having hundreds of billions.

## N

## O

## P

<span id="pre_training">pre-training</span>
:   The initial training phase in which a language model learns to
    predict the next token on a large text corpus; produces a
    general-purpose model that is subsequently refined by fine-tuning.

<span id="precision_recall">precision and recall</span>
:   Two measures of a classifier's accuracy on a particular class.
    Precision is the fraction of positive predictions that are
    correct; recall is the fraction of actual positives that were
    found. A classifier can improve one at the expense of the other,
    so both are needed to evaluate performance honestly.

## Q

<span id="q_q_plot">Q-Q plot</span>
:   A graph that assesses whether a dataset follows a theoretical
    distribution by plotting its quantiles against the expected
    quantiles of that distribution, with points falling along a
    straight line indicating a good fit.

## R

<span id="rate_limit">rate limit</span>
:   A constraint imposed by an API provider on how many requests or
    tokens a client may submit per unit of time; exceeded limits
    return HTTP 429 errors and require retrying with exponential
    back-off.

<span id="rlhf">reinforcement learning from human feedback</span> (RLHF)
:   A fine-tuning technique in which human raters rank model outputs
    and the model is updated to produce higher-ranked responses; used
    to improve helpfulness and reduce harmful outputs.

<span id="rag">retrieval-augmented generation</span> (RAG)
:   A technique that retrieves relevant document chunks from an
    external source at query time and inserts them into the prompt,
    grounding the model's response in accurate source text and
    reducing hallucination.

<span id="role_prompting">role prompting</span>
:   A prompting technique that instructs the model to adopt a specific
    persona or area of expertise (e.g., "You are an expert
    statistician") to improve domain-specific responses.

## S

<span id="self_attention">self-attention</span>
:   A mechanism in transformer models in which each token is weighted
    by its relevance to every other token in the context window; the
    weights are learned during training and allow the model to capture
    long-range dependencies in text.

<span id="skill">skill</span>
:   A Markdown file containing a system prompt that specializes an LLM
    application's behavior for a recurring task. Claude Code stores
    skills in `~/.claude/` and are available across all projects.

<span id="sycophancy">sycophancy</span>
:   The tendency of an LLM to agree with or flatter the user rather than
    provide accurate information; a side effect of training with reinforcement
    learning from human feedback, where raters tend to prefer agreeable
    responses over correct but contradictory ones.

## T

<span id="temperature">temperature</span>
:   A parameter that scales the probability distribution over next
    tokens before sampling; temperature 0 makes output deterministic,
    temperature 1 samples proportionally, and values above 1 produce
    more varied and less coherent output.

<span id="token">token</span>
:   The basic unit of text processed by a language model; roughly 4
    characters of English on average, produced by splitting input text
    with a tokenization algorithm such as Byte-Pair Encoding.

<span id="tokenization">tokenization</span>
:   The process of splitting input text into tokens before feeding it
    to a language model, typically using an algorithm such as
    Byte-Pair Encoding; different models use different tokenizers and
    may produce different token counts for the same text.

<span id="top_p">top-p sampling</span>
:   A sampling strategy, also called nucleus sampling, that restricts
    token selection to the smallest set of tokens whose cumulative
    probability exceeds a threshold p (e.g., 0.9), preventing very
    low-probability tokens from being chosen.

<span id="training_cutoff">training cutoff</span>
:   The date after which new information is not reflected in a model's
    weights; events, publications, and API changes after this date are
    unknown to the model, which may still generate confident-sounding
    text about them by extrapolating from prior patterns.

<span id="transformer">transformer</span>
:   A neural network architecture based on stacked self-attention
    layers that underlies most modern large language models; each
    layer applies self-attention followed by a feed-forward network,
    allowing the model to process all tokens in the context window in
    parallel.

## U

## V

<span id="vector_database">vector database</span>
:   A database that stores documents as embedding vectors and supports
    fast retrieval of the most semantically similar documents for a
    given query; used as the external knowledge store in
    retrieval-augmented generation.

## W

## X

## Y

## Z
