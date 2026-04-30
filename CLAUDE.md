# Claude

This project is an introductory tutorial on how to analyze data using
LLMs in conjunction with SQL, Python, Git, and Unix command-line
tools.

## Audience

Learners have completed the first year of an undergraduate degree,
during which they have done one semester of basic calculus and one
semester of basic statistics.  Learners have just completed the
tutorials in the Markdown files in the following directories, but have
not yet had time to practice these skills:

-   $HOME/carp/git-novice/
-   $HOME/carp/python-novice-inflammation/
-   $HOME/carp/shell-novice/
-   $HOME/sqlshort/

Learners want to be able to find, get, clean, load, analyze, and
visualize data. They do *not* want to become full-time software
engineers; instead, they regard programming as a means to an end.
They care about reproducibility, and want to be able to have
confidence in their results, but are not going to write complex
workflow descriptions or extensive unit test suites.

Learners frequently use LLM tools like Claude and ChatGPT instead of
search engines. They frequently use LLM tools to summarize documents
or write first drafts of emails. They do not understand how such tools
work, but would like to. They are nervous that these tools are going
to deskill or eliminate research jobs, and are very concerned about
the social and environmental impact of these tools in general.

## Skills

-   Load the `learning-goal` and `learning-opportunities` skills.
-   Run `brief` to get an overview of this repository.

## Interaction

-   Save a summary of prompts given and actions taken in Markdown
    files in `./log`.  Each log file's name is
    `YYYY-MM-DD-HH-MM-some-slug.md`. The first part specifies when the
    log file was created (as UTC timestamp down to the level of
    minutes); the second part (`some-slug`) is a multipart hyphenated
	slug identifying the topic, such as `create-outline` or `define-terms`.
-   If the topic of the work changes mid-session, prompt to see if a
    new log file should be created.
-   Run shell commands that do not modify files without asking for permission.

## Style Rules

-   Lessons are written as point-form notes. See the 'change' workshop
    for examples.
-   Each lesson should take about an hour to work through.
-   Do not use **bold** in prose. Only use *italics* sparingly.
-   Figures, code inclusions, citations, and glossary references are
    formatted using `mccole` shortcodes.
-   Do not attempt to be funny or offer generic positive feedback to
    readers.
-   Use `[text][key]` format for external links, and define `key` in
    `_extras/links.md`.
-   Only use semi-colons and em-dashes rarely.
-   Only use inline three-item lists rarely.

## Structure

-   Lessons are written in Markdown and compiled to HTML using the
    `mccole` static site generator.  `mccole` is installed in the `uv`
    virtual environment for this project, which is active.
-   Boilerplate Markdown files:
    -   `CODE_OF_CONDUCT.md`
    -   `CONTRIBUTING.md`
    -   `LICENSE.md`
-   Lesson files:
    -   `README.md`: lesson home page (including table of contents used by `mccole`).
    -   `*/index.md`: lessons (see `README.md` for order).
    -   `docs`: generated HTML.
    -   `_extras/links.md`: Markdown link definitions included in all other Markdown files.
    -   `_static/`: web site assets.
    -   `_templates/`: `jinja2` page template.

## Build and Test Commands

-   Repeatable actions are saved in `Makefile`.
    -   Run `make` with no arguments to get an up-to-date list of targets.
-   `make site` rebuilds the website from the Markdown files.
-   `make check` checks the generated HTML.

## Bibliography

The bibliography is stored in `bibliography/index.md` as a Markdown
definition list. Each entry has the form:

    <span id="NameDDDD">NameDDDD</span>
    :   Author:
        Title.
        Publisher,
        Year,
        ISBN.

where `DDDD` is a four-digit year. Extend this format for journal
articles and web sites in a way that is consistent with standard
citation practices. To reference a citation in a lesson, use:

    [%b Key1 Key2 Key3 %]

## Glossary

The glossary is stored in `glossary/index.md` as a Markdown definition
list.  Each entry has the form:

    <span id="some-key">term being defined</span>
    :   definition

To reference a glossary term in a lesson, use the shortcode:

    [%g some-key "display text" %]

where `some-key` matches the `id` attribute of the glossary entry
and `display text` is the phrase as it appears in the lesson prose.
