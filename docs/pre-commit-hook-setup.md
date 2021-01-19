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
