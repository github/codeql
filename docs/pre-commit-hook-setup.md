# CodeQL pre-commit-hook setup

As stated in [CONTRIBUTING](../CONTRIBUTING.md) all CodeQL files must be formatted according to our [CodeQL style guide](ql-style-guide.md). You can use our pre-commit hook to avoid committing incorrectly formatted code. To use it, simply copy the [pre-commit](../misc/scripts/pre-commit) script to `.git/modules/ql/hooks/pre-commit` and make sure that it is executable.

The script will abort a commit that contains incorrectly formatted code in .ql or .qll files and print an error message like:

```
> git commit -m "My commit."
code/ql/cpp/ql/src/Options.qll would change by autoformatting.
code/ql/cpp/ql/src/printAst.ql would change by autoformatting.
```

If you prefer to have the script automatically format the code (and not abort the commit), you can replace the line `codeql query format --check-only` with `codeql query format --in-place` (and `exit $exitVal` with `exit 0`).
