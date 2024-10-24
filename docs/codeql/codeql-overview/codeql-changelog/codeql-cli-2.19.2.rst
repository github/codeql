.. _codeql-cli-2.19.2:

==========================
CodeQL 2.19.2 (2024-10-21)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.19.2 runs a total of 427 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The Python extractor will no longer extract the standard library by default, relying instead on models of the standard library. This should result in significantly faster extraction and analysis times, while the effect on alerts should be minimal. It will for a while be possible to force extraction of the standard library by setting the environment variable :code:`CODEQL_EXTRACTOR_PYTHON_EXTRACT_STDLIB` to :code:`1`.

Bug Fixes
~~~~~~~~~

*   The 2.19.1 release contained a bug in the query evaluator that under rare conditions could lead to wrong alerts or resource exhaustion. Although we have never seen the problem outside of internal testing, we encourage users on 2.19.1 to upgrade to 2.19.2.

Miscellaneous
~~~~~~~~~~~~~

*   The database relation :code:`sourceLocationPrefix` is changed for databases created with
    :code:`codeql test run`. Instead of containing the path of the enclosing qlpack, it now contains the actual path of the test, similar to if one had run :code:`codeql database create` on the test folder. For example, for a test such as
    :code:`<checkout>/cpp/ql/test/query-tests/Security/CWE/CWE-611/XXE.qlref` we now populate
    :code:`sourceLocationPrefix` with :code:`<checkout>/cpp/ql/test/query-tests/Security/CWE/CWE-611/` instead of :code:`<checkout>/cpp/ql/test/`. This change typically impacts calls to
    :code:`File.getRelativePath()`, and may as a result change the expected test output.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/unclear-array-index-validation` ("Unclear validation of array index") query has been improved to reduce false positives and increase true positives.
*   Fixed false positives in the :code:`cpp/uninitialized-local` ("Potentially uninitialized local variable") query if there are extraction errors in the function.
*   The :code:`cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to detect byte arrays.
*   The :code:`cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to recognize dynamic checks prior to possible dangerous widening.

Ruby
""""

*   The :code:`rb/diagnostics/extraction-errors` diagnostic query has been split into :code:`rb/diagnostics/extraction-errors` and :code:`rb/diagnostics/extraction-warnings`, counting extraction errors and warnings respectively.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added taint flow model for :code:`fopen` and related functions.
*   The :code:`SimpleRangeAnalysis` library (:code:`semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis`) now generates more precise ranges for calls to :code:`fgetc` and :code:`getc`.

Golang
""""""

*   Added member predicates :code:`StructTag.hasOwnFieldWithTag` and :code:`Field.getTag`, which enable CodeQL queries to examine struct field tags.
*   Added member predicate :code:`InterfaceType.hasPrivateMethodWithQualifiedName`, which enables CodeQL queries to distinguish interfaces with matching non-exported method names that are declared in different packages, and are therefore incompatible.

Python
""""""

*   Modelled that :code:`re.finditer` returns an iterable of :code:`re.Match` objects. This is now understood by the API graph in many cases.
*   Type tracking, and hence the API graph, is now able to correctly trace through comprehensions.
*   More precise modelling of the dataflow through comprehensions. In particular, captured variables are now handled correctly.
*   Dataflow out of yield is added, allowing proper tracing through generators.
*   Added several models of standard library functions and classes, in anticipation of no longer extracting the standard library in a future release.

Ruby
""""

*   The :code:`ExtractionError` class has been split into :code:`ExtractionError` and :code:`ExtractionWarning`, reporting extraction errors and warnings respectively.
