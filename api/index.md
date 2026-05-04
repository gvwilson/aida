# Using the API

-   Use the API when you need to call an LLM from Python code inside a notebook, a script, or a pipeline
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

-   The response object contains `content` (a list of content blocks),
    `usage` (token counts),
    and `stop_reason`
-   Cost is `(input_tokens * input_price) + (output_tokens * output_price)`
    -   Check the provider's pricing page
-   [%g rate_limit "Rate limits" %] apply: requests per minute and tokens per minute
    -   Exceeded limits raise HTTP 429 errors
-   Use [%g exponential_backoff "exponential back-off" %] when retrying rate-limited requests

```python
import time
for attempt in range(5):
    try:
        response = client.messages.create(...)
        break
    except anthropic.RateLimitError:
        time.sleep(2 ** attempt)
```

## Exercises

-   Call the LLM API from a short Python script to summarize a dataset
    -   Print the `usage` field of the response
    -   Record how many input and output tokens the call consumed and estimate its cost
