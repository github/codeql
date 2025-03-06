.. _codeql-cli-2.19.4:

==========================
CodeQL 2.19.4 (2024-12-02)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.19.4 runs a total of 432 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 5 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   On MacOS, :code:`arch -arm64` commands no longer fail when they are executed via :code:`codeql database create --command`,
    via :code:`codeql database trace-command`, or are run after :code:`codeql database init --begin-tracing`. Note that build commands invoked this way still will not normally be traced, so this is useful only for running ancillary commands which are incidental to building your code.
*   Fixed a bug where :code:`codeql test run` would not preserve test databases on disk after a test failed.

Improvements
~~~~~~~~~~~~

*   CodeQL now supports passing values containing the equals character (:code:`=`) to extractor options via the :code:`--extractor-option` flag. This allows cases like :code:`--extractor-option opt=key=value`, which sets the extractor option :code:`opt` to hold the value :code:`key=value`, whereas previously that would have been rejected with an error.
*   The :code:`codeql pack bundle` command now sets the numeric user and group IDs of entries in the generated
    :code:`tar` archive to :code:`0`. This avoids failures like :code:`IllegalArgumentException: user id '7111111' is too big ( > 2097151 )` when the numeric user ID is too large.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   The behaviour of the :code:`subtypes` column in models-as-data now matches other languages more closely.
*   Fixed a bug which meant that some qualified names for promoted methods were not being recognised in some very specific circumstances.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   Added modeling of the :code:`bottle` framework, leading to new remote flow sources and header writes

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The Models as Data models for .NET 8 Runtime now include generated models for higher order methods.

Golang
""""""

*   The :code:`subtypes` column has been set to true in all models-as-data models except some tests. This means that existing models will apply in some cases where they didn't before, which may lead to more alerts.

Java/Kotlin
"""""""""""

*   In a switch statement with a constant switch expression, all non-matching cases were being marked as unreachable, including those that can be reached by falling through from the matching case. This has now been fixed.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added taint-steps for :code:`Array.prototype.with`.
*   Added taint-steps for :code:`Array.prototype.toSpliced`
*   Added taint-steps for :code:`Array.prototype.toReversed`.
*   Added taint-steps for :code:`Array.prototype.toSorted`.
*   Added support for :code:`String.prototype.matchAll`.
*   Added taint-steps for :code:`Array.prototype.reverse`.
