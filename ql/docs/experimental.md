# Experimental CodeQL queries and libraries

In addition to our standard CodeQL queries and libraries, this repository may also contain queries and libraries of a more experimental nature. Experimental queries and libraries can be improved incrementally and may eventually reach a sufficient maturity to be included in our standard libraries and queries.

Experimental queries and libraries may not be actively maintained as the standard libraries evolve. They may also be changed in backwards-incompatible ways or may be removed entirely in the future without deprecation warnings.

## Requirements

1. **Directory structure**

    - Experimental queries and libraries are stored in the `ql/src/experimental` subdirectory, and any corresponding tests in `ql/test/experimental`.
    - The structure of an `experimental` subdirectory mirrors the structure of standard queries and libraries (or tests) in the parent directory.

2. **Query metadata**

    - The query `@id` must not clash with any other queries in the repository.
    - The query must have a `@name` and `@description` to explain its purpose.
    - The query must have a `@kind` and `@problem.severity` as required by CodeQL tools.

    For details, see the [guide on query metadata](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md).

3. **Formatting**

    - The queries and libraries must be [autoformatted](https://codeql.github.com/docs/codeql-for-visual-studio-code/about-codeql-for-visual-studio-code/).

4. **Compilation**

    - Compilation of the query and any associated libraries and tests must be resilient to future development of the standard libraries. This means that the functionality cannot use internal APIs, cannot depend on the output of `getAQlClass`, and cannot make use of regexp matching on `toString`.
    - The query and any associated libraries and tests must not cause any compiler warnings to be emitted (such as use of deprecated functionality or missing `override` annotations).

5. **Results**

    - The query must have at least one true positive result on some revision of a real project.

## Non-requirements

Other criteria typically required for our standard queries and libraries are not required for experimental queries and libraries. In particular, fully disciplined query [metadata](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md), query [help](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md), tests, a low false positive rate and performance tuning are not required (but nonetheless recommended).
