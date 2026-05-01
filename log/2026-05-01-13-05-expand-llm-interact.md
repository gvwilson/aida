# Expand llm/index.md and interact/index.md

## Prompt

Move outline material from README.md into individual lessons was already done.
Expand `llm/index.md` and `interact/index.md` so the number of factual statements triples.
Use point-form prose, triple-backquoted code blocks for code and sample output.
No tab characters.

## Actions

-   Read `llm/index.md` (43 lines), `interact/index.md` (43 lines), `intro/index.md` for style reference
-   Rewrote `llm/index.md` (144 lines): added BPE tokenization details, code block with tiktoken,
    transformer layer/attention/parameter scale details, SFT/RLHF training pipeline,
    context window sizing and "lost in the middle" effect, temperature 0/1/>1 and top-p with code block,
    training cutoff implications with deprecated API code example, hallucination mechanisms
    and common failure sites (citations, URLs, numbers), RAG pipeline steps and limitations,
    expanded output-checking checklist with assertion code block.
-   Rewrote `interact/index.md` (173 lines): added `llm` package CLI with pipe examples,
    Copilot/Cursor/Continue.dev editor tool details, full API authentication and response structure
    with code blocks and rate-limit retry pattern, prompt engineering techniques (specificity,
    role prompting, few-shot, structured output, negative constraints) with examples,
    MCP protocol mechanics (JSON-RPC, tool schema, local process), worked SQLite MCP example
    with config JSON and verification SQL, agent loop steps and risk/reversibility analysis,
    skill file format and installation.
-   Verified no tab characters in either file.
