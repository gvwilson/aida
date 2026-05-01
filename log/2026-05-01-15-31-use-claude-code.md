# Use Claude Code in All Examples

## Prompt

Modify existing lessons as needed so that all examples use Claude Code.

## Actions

- Replaced `tiktoken` (OpenAI library) tokenization example in `llm/index.md` with `anthropic` SDK `count_tokens` call.
- Updated first exercise in `llm/index.md` to use `claude` CLI instead of an online tokenizer.
- Rewrote "Command-line tools" section in `interact/index.md` to use `claude` as the primary CLI; removed `llm` package and `openai` CLI references.
- Changed first exercise in `interact/index.md` to remove comparison with `llm` CLI.
- Changed "Ask an LLM" / "Prompt an LLM" / "Use an LLM" phrasing in body content and exercises throughout `data/`, `db/`, `analyze/`, `visualize/`, `records/`, and `finale/` to "Use Claude Code" / "Ask Claude Code".
