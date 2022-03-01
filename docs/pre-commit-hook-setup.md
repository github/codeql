# CodeQL pre-commit-hook setup


As stated in [CONTRIBUTING](../CONTRIBUTING.md) all CodeQL files must be formatted according to our [CodeQL style guide](ql-style-guide.md). You can use a pre-commit hook to avoid committing incorrectly formatted code, as well as prevent some other easily checkable errors.

## Using the `pre-commit` framework

Preferably, you can use the [pre-commit framework](https://pre-commit.com/). There are some pre-commit hooks already configured on [`.pre-commit-config.yaml`](../.pre-commit-config.yaml). In order to install them you need to follow pre-commit's [installation instructions](https://pre-commit.com/#installation) and then run `pre-commit install`. Typically (assuming you have [`pip`](https://pip.pypa.io/en/stable/installation/) installed):
```
python3 -m pip install pre-commit
pre-commit install
```

Also, make sure that the CodeQL CLI has been added to your `PATH`.

By default, pre-commit will check and fix:
* trailing whitespaces;
* absence of or duplicate newlines at end of files;
* QL formatting;
* files out of sync (see [`config/sync-files.py`](../config/sync-files.py)).

It will additionally check:
* `.qhelp` files for query help generation.

It will run the checks only on files changed by the commit (except for the file sync check) and it will skip all files under `test` directories unless they are `.ql`, `.qll` or `.qlref` files.

If you want to change any behaviour (for example, you want to skip the out-of-sync file check, or you want to avoid auto-fixing formatting or file syncing), you can copy the configuration file to a separate location, modify it and use that. For example
```
cp .pre-commit-config.yaml ~/my-codeql-pre-commit-config.yaml
pre-commit install --config ~/my-codeql-pre-commit-config.yaml
# edit ~/my-codeql-pre-commit-config.yaml to your liking
```

You can for example:
* change `--in-place` to `--check-only` in the `codeql-format` hook to have it report formatting problems instead of auto-fixing them;
* remove `--latest` in the `sync-files` hook to do the same;
* remove any hook altogether.

## Manual approach

You can have the formatting check in place by copying the [pre-commit](../misc/scripts/pre-commit) script to `.git/hooks/pre-commit` and make sure that:

- The script is executable. On Linux and macOS this can be done using `chmod +x`.
- The CodeQL CLI has been added to your `PATH`.

The script will abort a commit that contains incorrectly formatted code in .ql or .qll files and print an error message like:

```
> git commit -m "My commit."
ql/cpp/ql/src/Options.qll would change by autoformatting.
ql/cpp/ql/src/printAst.ql would change by autoformatting.
```

If you prefer to have the script automatically format the code (and not abort the commit), you can replace the line `codeql query format --check-only` with `codeql query format --in-place` (and `exit $exitVal` with `exit 0`).
