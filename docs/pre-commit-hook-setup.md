# CodeQL pre-commit-hook setup

As stated in [CONTRIBUTING](../CONTRIBUTING.md) all CodeQL files must be formatted according to our [CodeQL style guide](ql-style-guide.md). You can use our pre-commit hook to avoid committing incorrectly formatted code. To use it, simply copy the [pre-commit](../misc/scripts/pre-commit) script to `.git/hooks/pre-commit` and make sure that:

- The script is executable. On Linux and macOS this can be done using `chmod +x`.
- The CodeQL CLI has been added to your `PATH`.

The script will abort a commit that contains incorrectly formatted code in .ql or .qll files and print an error message like:

```
> git commit -m "My commit."
ql/cpp/ql/src/Options.qll would change by autoformatting.
ql/cpp/ql/src/printAst.ql would change by autoformatting.
```

If you prefer to have the script automatically format the code (and not abort the commit), you can replace the line `codeql query format --check-only` with `codeql query format --in-place` (and `exit $exitVal` with `exit 0`).

## Using the `pre-commit` framework

Alternatively, you can use the [pre-commit framework](https://pre-commit.com/). There are some pre-commit hooks already configured on [`.pre-commit-config.yaml`](../.pre-commit-config.yaml). In order to install them you need to follow pre-commit's [installation instructions](https://pre-commit.com/#installation) and then run `pre-commit install`.

By default, pre-commit will check and fix
* trailing whitespaces;
* absence of double newlines at end of files;
* QL formatting;
* files out of sync (see [`config/sync-files.py`](../config/sync-files.py)).

It will run the checks only on files changed by the commit (except for the file sync check) and it will skip all files under `test` directories unless they are `.ql`, `.qll` or `.qlref` files.

If you want to change one of these default behaviours (for example, you want to skip the out-of-sync file check, or you prefer to pass `--check-only` instead of `--in-place` to the query formatter), run
```
git update-index --assume-unchanged .pre-commit-config.yaml
```
and you can then modify the configuration at your will.
