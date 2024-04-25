# Supported CodeQL queries and libraries

Queries and libraries outside [the `experimental` directories](experimental.md) are _supported_ by GitHub, allowing our users to rely on their continued existence and functionality in the future:

1. Once a query or library has appeared in a stable release, a one-year deprecation period is required before we can remove it. There can be exceptions to this when it's not technically possible to mark it as deprecated.
2. Major changes to supported queries and libraries are always announced in the [change notes for stable releases](../change-notes/).
3. We will do our best to address user reports of false positives or false negatives.

Because of these commitments, we set a high bar for accepting new supported queries. The requirements are detailed in the rest of this document.

## Steps for introducing a new supported query

The process must begin with the first step and must conclude with the final step. The remaining steps can be performed in any order.

1. **Have the query merged into the appropriate `experimental` subdirectory**

   See [CONTRIBUTING.md](../CONTRIBUTING.md).

2. **Write a query help file**

   Query help files explain the purpose of your query to other users. Write your query help in a `.qhelp` file and save it in the same directory as your query. For more information on writing query help, see the [Query help style guide](query-help-style-guide.md).

   - Note, in particular, that almost all queries need to have a pair of "before" and "after" examples demonstrating the kind of problem the query identifies and how to fix it. Make sure that the examples are actually consistent with what the query does, for example by including them in your unit tests. Examples must be original, not copied from third-party sources.
   - At the time of writing, there is no way of previewing help locally. Once you've opened a PR, a preview will be created as part of the CI checks. A GitHub employee will review this and let you know of any problems.

3. **Write unit tests**

   Add one or more unit tests for the query (and for any library changes you make) to the `ql/<language>/ql/test/experimental` directory. Tests for library changes go into the `library-tests` subdirectory, and tests for queries go into `query-tests` with their relative path mirroring the query's location under `ql/<language>/ql/src/experimental`.

   - See the section on [Testing custom queries](https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/testing-custom-queries) in the [CodeQL CLI documentation](https://docs.github.com/en/code-security/codeql-cli) for more information.
   - See [C/C++ CodeQL tests](/cpp/ql/test/README.md) for more information about contributing tests for C/C++ queries in particular.

4. **Test for correctness on real-world code**

   Test the query on a number of large real-world projects to make sure it doesn't give too many false positive results. Adjust the `@precision` and `@problem.severity` attributes in accordance with the real-world results you observe. See the advice on query metadata below.

   GitHub is running a private beta test of a new feature for testing CodeQL queries at scale from VS Code. To request access to the beta program, please respond to this [GitHub Discussion](https://github.com/orgs/community/discussions/40453).
   
5. **Test and improve performance**

   There must be a balance between the execution time of a query and the value of its results: queries that are highly valuable and broadly applicable can be allowed to take longer to run. In all cases, you need to address any easy-to-fix performance issues before the query is put into production.

   QL performance profiling and tuning is an advanced topic, and some tasks will require assistance from GitHub employees. With that said, there are several things you can do.

   - Understand [the evaluation model of QL](https://codeql.github.com/docs/ql-language-reference/evaluation-of-ql-programs/). It's more similar to SQL than to any mainstream programming language.
   - Most performance tuning in QL boils down to computing as few tuples (rows of data) as possible. As a mental model, think of predicate evaluation as enumerating all combinations of parameters that satisfy the predicate body. This includes the implicit parameters `this` and `result`.
   - The major libraries in CodeQL are _cached_ and will only be computed once for the entire suite of queries. The first query that needs a cached _stage_ will trigger its evaluation. This means that query authors should usually only look at the run time of the last stage of evaluation.
   - In [the settings for the VSCode extension](https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/customizing-settings/), check the box "Running Queries: Debug" (`codeQL.runningQueries.debug`). Then find "CodeQL Query Server" in the VSCode Output panel (View -> Output) and capture the output when running the query. That output contains timing and tuple counts for all computed predicates.
   - To clear the entire cache, invoke "CodeQL: Clear Cache" from the VSCode command palette.

6. **Make sure your query has the correct metadata**

   For the full reference on writing query metadata, see the [Query metadata style guide](query-metadata-style-guide.md). The following constitutes a checklist.

   a. Each query needs a `@name`, a `@description`, and a `@kind`.

   b. Alert queries also need a `@problem.severity` and a `@precision`.

      - The severity is one of `error`, `warning`, or `recommendation`.
      - The precision is one of `very-high`, `high`, `medium` or `low`. It may take a few iterations to get this right.

   c. All queries need an `@id`.

      - The ID should be consistent with the ids of similar queries for other languages; for example, there is a C/C++ query looking for comments containing the word "TODO" which has id `cpp/todo-comment`, and its C# counterpart has id `cs/todo-comment`.

   d. Provide one or more `@tags` describing the query.

      - Tags are free-form, but we have some conventions. At a minimum, most queries should have at least one of `correctness`, `maintainability` or `security` to indicate the general kind of issue the query is intended to find. Security queries should also be tagged with corresponding [CWE](https://cwe.mitre.org/data/definitions/1000.html) numbers, for example `external/cwe/cwe-119` (prefer the most specific CWE that encompasses the target of the query).

7. **Move your query out of `experimental`**

   - The structure of an `experimental` subdirectory mirrors the structure of its parent directory, so this step may just be a matter of removing the `experimental/` prefix of the query and test paths. Be sure to also edit any references to the query path in tests.
   - Add the query to one of the legacy suite files in `ql/<language>/config/suites/<language>/` if it exists. Note that there are separate suite directories for C and C++, `c` and `cpp` respectively, and the query should be added to one or both as appropriate.
   - Add a release note to `change-notes/<next-version>/analysis-<language>.md`.
   - Your pull request will be flagged automatically for a review by the documentation team to ensure that the query help file is ready for wider use.
