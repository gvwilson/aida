# Interacting with LLMs

## Command-line tools

-   Several CLI tools let you send prompts and receive responses without opening a browser
-   `claude` is Anthropic's official CLI (Claude Code); `openai` is OpenAI's
-   Simon Willison's `llm` package provides a unified interface to many providers

```bash
pip install llm
llm keys set openai          # store API key once
llm "Summarize this file" < data/penguins.csv
```

-   Piping text through stdin lets you chain LLM calls with other shell tools

```bash
cat results.txt | llm "Extract all numeric values and list them"
```

-   CLIs are useful for quick one-off queries, batch processing in shell scripts, and working in environments without a GUI
-   Each vendor CLI uses its own auth and model selection flags
    -   Check `--help` for options

## Editor and notebook integrations

-   GitHub Copilot: in-editor inline completion and chat, available for VS Code, JetBrains, and Vim
-   Cursor: a VS Code fork with LLM assistance built into the editor core
    -   Can edit multiple files in one prompt
-   Continue.dev: open-source VS Code extension that works with many models including local ones
-   Marimo has MCP server support, letting notebooks talk to LLM tools without leaving the notebook interface
-   Editor integrations see your open files as context
    -   They hallucinate less on code that is already on screen
-   Inline completions are accepted with Tab and can be rejected with Escape
    -   Treat them like autocomplete, not ground truth

## The API

-   Use the API when you need to call an LLM from Python code: inside a notebook, a script, or a pipeline
-   Authentication is done via an environment variable, not hardcoded in source files

```bash
export ANTHROPIC_API_KEY="sk-ant-..."   # add to ~/.zshrc or ~/.bashrc
```

```python
import anthropic
client = anthropic.Anthropic()   # reads ANTHROPIC_API_KEY automatically
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=512,
    messages=[{"role": "user", "content": "How many rows are in a 10x10 grid?"}]
)
print(response.content[0].text)
```

-   The response object contains `content` (a list of content blocks), `usage` (token counts), and `stop_reason`
-   Cost is `(input_tokens * input_price) + (output_tokens * output_price)`
    -   Check the provider's pricing page
-   [%g rate-limit "Rate limits" %] apply: requests per minute and tokens per minute
    -   Exceeded limits raise HTTP 429 errors
-   Use exponential back-off when retrying rate-limited requests

```python
import time
for attempt in range(5):
    try:
        response = client.messages.create(...)
        break
    except anthropic.RateLimitError:
        time.sleep(2 ** attempt)
```

## Writing effective prompts

-   Be specific: vague prompts produce vague answers
    -   Weak: "Analyze my data"
    -   Stronger: "Given this CSV of penguin measurements, compute the mean bill length per species"
-   Provide context: include relevant column names, file formats, or domain vocabulary
-   Ask for step-by-step reasoning: "Think step by step before giving your final answer" often improves accuracy
-   [%g role-prompting "Role prompting" %]: starting with "You are an expert in ..." can improve domain-specific responses
-   [%g few-shot "Few-shot examples" %]: show the model one or two input-output pairs before your actual query

```
Convert species codes to full names. Examples:
Input: "Adel" -> Output: "Adelie"
Input: "Chin" -> Output: "Chinstrap"
Input: "Gent" -> Output:
```

-   Ask for structured output when you need to parse the response programmatically

```
Return your answer as JSON with keys "species", "mean_bill_mm", and "sample_size".
Do not include any other text.
```

-   Negative constraints help: "Do not include code comments", "Do not summarize the question back to me"
-   Iterative refinement: send a follow-up prompt correcting or extending the previous response rather than starting over
-   Long, complex prompts can be broken into smaller prompts that build on each other

## Model Context Protocol (MCP)

-   [%g mcp "MCP" %] is an open standard for connecting LLM applications to external tools and data sources
-   It uses JSON-RPC
    -    The LLM client sends a request describing a tool call
    -    The MCP server executes it and returns a result
-   An MCP server exposes a set of *tools*, each with a name, description, and JSON schema for its inputs
-   The LLM sees tool descriptions in its context and can choose to call a tool
    -   The client executes the actual call
-   Common MCP servers: filesystem access, SQLite databases, web search, GitHub, and calendar
-   MCP decouples the LLM from the tool implementation: the same server works with any MCP-compatible client
-   The server runs as a local process
    -   It does not require sending your data to a third-party service

## Worked MCP example

-   Install the SQLite MCP server: `uvx mcp-server-sqlite --db-path penguins.db`
-   Add it to your Claude Code config so Claude knows it is available:

```json
{
  "mcpServers": {
    "penguins": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "penguins.db"]
    }
  }
}
```

-   Ask a natural-language question in Claude Code
    -   The model calls the `query` tool automatically:

```
User: How many distinct species are in the penguins table?
Claude: [calls query tool with SELECT COUNT(DISTINCT species) FROM penguins]
Result: 3
```

-   Verify by running the SQL yourself:

```bash
sqlite3 penguins.db "SELECT COUNT(DISTINCT species) FROM penguins;"
```

-   The LLM constructs the SQL
    -   You verify the result
    -   Neither step replaces the other

## Agents

-   A single prompt produces one response
    -   An [%g agent "agent" %] runs a loop: observe → plan → act → observe → ...
-   Agents use tool calls (web search, code execution, file read/write) to gather information and take actions
-   The agent loop continues until the model decides the task is complete or a maximum step count is reached
-   Agents can take irreversible actions: deleting files, sending requests to external APIs, committing code
-   Risk compounds with step count: an error in step 2 can cause every subsequent step to be wrong
-   Human-in-the-loop checkpoints (requiring approval before certain tool calls) reduce the blast radius of mistakes
-   Agents work well for tasks with clear success criteria that can be verified programmatically
-   Agents work poorly for tasks requiring subjective judgment or where the environment is ambiguous
-   Always review the full list of actions an agent took before accepting its output

## Skills and extensions

-   A [%g skill "skill" %] is a Markdown file containing a system prompt that specializes the model's behavior for a task
-   Skills are stored in `~/.claude/` and are available across projects
-   A skill can instruct the model to always check documentation before generating code, always output JSON, or always log its reasoning
-   Finding community skills: the Claude Code documentation and GitHub list commonly used skills
-   Installing a skill: copy the `.md` file to `~/.claude/` and reference it by name in a prompt or config

```bash
# Example skill file: ~/.claude/check-docs.md
# ---
# name: check-docs
# ---
# Before generating any Python code that uses an external library,
# state the library version and confirm the API against the official docs.
```

-   Writing a skill automates a prompt pattern you would otherwise repeat by hand in every session

## Exercises

-   Use Claude Code in the terminal to ask a question about a CSV file in your project
    -   Compare the answer to what you get from piping the same file through the `llm` CLI
-   Install an MCP SQLite server, connect to the penguins database, and ask how many distinct species there are
    -   Verify the answer with a direct SQLite query run from the shell
-   Write a two-sentence skill that instructs an LLM to always check Polars documentation before generating code
    -   Test it on a data-loading task and record whether it changed the output
-   Call the Anthropic API from a short Python script to summarize a dataset
    -   Print the `usage` field of the response
    -   Record how many input and output tokens the call consumed and estimate its cost
-   Ask an agent to find and fix a syntax error in a short Python script
    -   Review every tool call it made
    -   Note which changes were correct and which introduced new problems
-   Identify one task from this workshop where an agent would be helpful and one where it would be risky
    -   Write a one-sentence justification for each, focusing on reversibility and verifiability
