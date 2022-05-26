# Contributing to CodeQL

We welcome contributions to our CodeQL libraries and queries. Got an idea for a new check, or how to improve an existing query? Then please go ahead and open a pull request! Contributions to this project are [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the [project's open source license](LICENSE).

There is lots of useful documentation to help you write queries, ranging from information about query file structure to tutorials for specific target languages. For more information on the documentation available, see [CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/codeql-queries) on [codeql.github.com](https://codeql.github.com).

## Change notes

Any nontrivial user-visible change to a query pack or library pack should have a change note. For details on how to add a change note for your change, see [this guide](docs/change-notes.md).

## Submitting a new experimental query

If you have an idea for a query that you would like to share with other CodeQL users, please open a pull request to add it to this repository. New queries start out in a `<language>/ql/src/experimental` directory, to which they can be merged when they meet the following requirements.

1. **Directory structure**

    There are six language-specific query directories in this repository:

      * C/C++: `cpp/ql/src`
      * C#: `csharp/ql/src`
      * Java: `java/ql/src`
      * JavaScript: `javascript/ql/src`
      * Python: `python/ql/src`
      * Ruby: `ruby/ql/src`

    Each language-specific directory contains further subdirectories that group queries based on their `@tags` or purpose.
    - Experimental queries and libraries are stored in the `experimental` subdirectory within each language-specific directory in the [CodeQL repository](https://github.com/github/codeql). For example, experimental Java queries and libraries are stored in `java/ql/src/experimental` and any corresponding tests in `java/ql/test/experimental`.
    - The structure of an `experimental` subdirectory mirrors the structure of its parent directory.
    - Select or create an appropriate directory in `experimental` based on the existing directory structure of `experimental` or its parent directory.

2. **Query metadata**

    - The query `@id` must conform to all the requirements in the [guide on query metadata](docs/query-metadata-style-guide.md#query-id-id). In particular, it must not clash with any other queries in the repository, and it must start with the appropriate language-specific prefix.
    - The query must have a `@name` and `@description` to explain its purpose.
    - The query must have a `@kind` and `@problem.severity` as required by CodeQL tools.

    For details, see the [guide on query metadata](docs/query-metadata-style-guide.md).

    Make sure the `select` statement is compatible with the query `@kind`. See [About CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/about-codeql-queries/#select-clause) on codeql.github.com.

3. **Formatting**

    - The queries and libraries must be autoformatted, for example using the "Format Document" command in [CodeQL for Visual Studio Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/about-codeql-for-visual-studio-code).

    If you prefer, you can either:
    1. install the [pre-commit framework](https://pre-commit.com/) and install the configured hooks on this repo via `pre-commit install`, or
    2. use this [pre-commit hook](misc/scripts/pre-commit) that automatically checks whether your files are correctly formatted.

    See the [pre-commit hook installation guide](docs/pre-commit-hook-setup.md) for instructions on the two approaches.

4. **Compilation**

    - Compilation of the query and any associated libraries and tests must be resilient to future development of the [supported](docs/supported-queries.md) libraries. This means that the functionality cannot use internal libraries, cannot depend on the output of `getAQlClass`, and cannot make use of regexp matching on `toString`.
    - The query and any associated libraries and tests must not cause any compiler warnings to be emitted (such as use of deprecated functionality or missing `override` annotations).

5. **Results**

    - The query must have at least one true positive result on some revision of a real project.

6. **Query help files and unit tests**

	- Query help (`.qhelp`) files and unit tests are optional (but strongly encouraged!) for queries in the `experimental` directories. For more information about contributing query help files and unit tests, see [Supported CodeQL queries and libraries](docs/supported-queries.md).

Experimental queries and libraries may not be actively maintained as the supported libraries evolve. They may also be changed in backwards-incompatible ways or may be removed entirely in the future without deprecation warnings.

After the experimental query is merged, we welcome pull requests to improve it. Before a query can be moved out of the `experimental` subdirectory, it must satisfy [the requirements for being a supported query](docs/supported-queries.md).

## Using your personal data

If you contribute to this project, we will record your name and email address (as provided by you with your contributions) as part of the code repositories, which are public. We might also use this information to contact you in relation to your contributions, as well as in the normal course of software development. We also store records of CLA agreements signed in the past, but no longer require contributors to sign a CLA. Under GDPR legislation, we do this on the basis of our legitimate interest in creating the CodeQL product.

Please do get in touch (privacy@github.com) if you have any questions about this or our data protection policies.

## Bazel
Please notice that any bazel targets and definitions in this repository are currently experimental
and for internal use only.
