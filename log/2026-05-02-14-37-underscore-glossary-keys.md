# Replace Hyphens with Underscores in Glossary Keys

## Prompts

1. Start a new log file. Use underscores instead of hyphens for all glossary keys.

## Actions

Changed 11 glossary `id` attributes in `glossary/index.md` from hyphenated to underscore form:

| Old key | New key |
|---|---|
| `context-window` | `context_window` |
| `few-shot` | `few_shot` |
| `fine-tuning` | `fine_tuning` |
| `model-parameters` | `model_parameters` |
| `pre-training` | `pre_training` |
| `rate-limit` | `rate_limit` |
| `role-prompting` | `role_prompting` |
| `self-attention` | `self_attention` |
| `top-p` | `top_p` |
| `training-cutoff` | `training_cutoff` |
| `vector-database` | `vector_database` |

Updated all corresponding `[%g ... %]` references in:

-   `llm/index.md` (8 references)
-   `interact/index.md` (3 references)

## Prompts (continued)

2. Find fifteen glossary candidates for the learner persona; add the ones the user approves.

## Actions (continued)

Added 7 new entries to `glossary/index.md`:

-   `confabulation` (C)
-   `data_dictionary` (D)
-   `frontier_model` (F) -- was already referenced by `[%g frontier_model %]` in `llm/index.md`
-   `json_rpc` (J) -- was already referenced by `[%g json_rpc %]` in `interact/index.md`
-   `linter` (L)
-   `parquet` (P)
-   `precision_recall` (P)
