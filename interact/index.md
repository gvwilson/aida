# Interacting with LLMs

-   FIXME: this references Claude specifically - can it be made generic?

## Command-line tools

-   [llm][llm] is a CLI tool that lets you send prompts and receive responses without opening a browser
-   Authenticate once on first use

```bash
$ llm "Tell me a science joke"
```

-   Piping text through stdin lets you chain llm calls with other shell tools

```bash
$ cat results.txt | llm "Extract all numeric values and list them"
```

-   llm is useful for quick one-off queries,
    batch processing in shell scripts,
    and working in environments without a GUI
-   Use `--help` to see available flags for model selection and output format

## Editor and notebook integrations

-   Editor integrations see your open files as context
    -   They hallucinate less on code that is already on screen
-   Inline completions are accepted with Tab and can be rejected with Escape
    -   Treat them like fancy autocomplete, not ground truth
-   Marimo has MCP server support,
    letting notebooks talk to LLM tools without leaving the notebook interface
    -   marimo-pair can query the contents of Python's memory,
        which makes it very powerful for [%g eda "exploratory data analysis" %]

## Writing effective prompts

-   Be specific: vague prompts produce vague answers
    -   Weak: "Analyze my data"
    -   Stronger: "Given this CSV of penguin measurements, compute the mean bill length per species"
-   Provide context: include relevant column names, file formats, or domain vocabulary
-   Ask for step-by-step reasoning:
    "Write a step-by-step plan before taking action" often improves accuracy
-   [%g role_prompting "Role prompting" %]:
    starting with "You are an expert in…" can improve domain-specific responses
-   [%g few_shot "Few-shot examples" %]:
    show the model one or two input-output pairs before your actual query

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

-   Negative constraints help
    -   E.g., "Do not include code comments", "Do not summarize the question back to me"
-   Iterative refinement
    -   Send a follow-up prompt correcting or extending the previous response rather than starting over
-   Long, complex prompts can be broken into smaller prompts that build on each other

## Model Context Protocol

-   [%g mcp "Model context protocol" %] (MCP) is
    an open standard for connecting LLM applications to external tools and data sources
-   It uses [%g json_rpc "JSON-RPC" %]
    -    The LLM client sends a request describing a tool call
    -    The MCP server executes it and returns a result
-   An MCP server exposes a set of tools,
    each with a name, description, and [%g json_schema "JSON schema" %] for its inputs
-   The LLM sees tool descriptions in its context and can choose to call a tool
    -   The client executes the actual call
-   Common MCP servers: filesystem access, SQLite databases, web search, GitHub, and calendar
-   MCP decouples the LLM from the tool implementation: the same server works with any MCP-compatible client
-   The server runs as a local process
    -   It does not need to send your data to a third-party service (though it can)

## MCP example

-   Install the SQLite MCP server: `uvx mcp-server-sqlite --db-path penguins.db`
-   Add it to your config so your LLM knows it is available
    -   FIXME: how to do this for llm as opposed to Claude?

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

-   Ask a natural-language question
    -   The model calls the `query` tool automatically:

```
User: How many distinct species are in the penguins table?
Claude: [calls query tool with select count(distinct species) from penguins]
Result: 3
```

-   Verify by running the SQL yourself:

```bash
sqlite3 penguins.db "select count(distinct species) from penguins;"
```

-   The LLM constructs the SQL
    -   You verify the result
    -   Neither step replaces the other

## Agents

-   A single prompt produces one response
    -   An [%g agent "agent" %] runs a loop: observe → plan → act → observe → …
-   Agents use tool calls to gather information and take actions: web search, code execution, file read/write
-   The agent loop continues until the model decides the task is complete or a maximum step count is reached
-   Agents can take irreversible actions: deleting files, sending requests to external APIs, committing code
-   Risk compounds with step count:
    an error in step 2 can cause every subsequent step to be wrong
-   Human-in-the-loop checkpoints (requiring approval before certain tool calls)
    reduce the damage done by mistakes
-   Agents work well for tasks with clear success criteria that can be verified programmatically
-   Agents work poorly for tasks requiring subjective judgment or where the environment is ambiguous
-   Always review the full list of actions an agent took before accepting its output

## Skills and extensions

-   A [%g skill "skill" %] is a Markdown file containing a system prompt
    that specializes the model's behavior for a task
-   Skills are stored in `~/.claude/` and are available across projects
-   A skill can instruct the model to always check documentation before generating code,
    always output JSON,
    or always log its reasoning
-   Finding community skills:
    the Claude Code documentation and GitHub list commonly used skills
-   Installing a skill
    -   Copy the `.md` file to `~/.claude/`
    -   Reference it by name in a prompt or config

```bash
$ cat ~/.claude/check-docs.md

# Check Python documentation before using external library

Before generating any Python code that uses an external library,
state the library version and confirm the API against the official docs.
```

-   Writing a skill automates a prompt pattern you would otherwise repeat by hand in every session

## Exercises

-   Use an LLM in the terminal to ask a question about a CSV file in your project
    -   Check its answer against the result of a direct shell command on the same file
-   Install an MCP SQLite server, connect to the penguins database, and ask how many distinct species there are
    -   Verify the answer with a direct SQLite query run from the shell
-   Write a two-sentence skill that instructs an LLM to always check Polars documentation before generating code
    -   Test it on a data-loading task and record whether it changed the output
-   Prompt an agent to find and fix a syntax error in a short Python script
    -   Review every tool call it made
    -   Note which changes were correct and which introduced new problems
-   Identify one task from your daily workflow where an agent would be helpful and one where it would be risky
    -   Focus on reversibility and verifiability
