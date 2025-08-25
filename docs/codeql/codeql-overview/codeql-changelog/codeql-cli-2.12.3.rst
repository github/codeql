.. _codeql-cli-2.12.3:

==========================
CodeQL 2.12.3 (2023-02-23)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.3 runs a total of 385 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 122 queries (covering 31 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where the CLI would refuse to complete database creation if the OS reports less than about 1.5 GB of physical memory. Now an attempt will be made even on low-memory systems (but it might still run out of memory unless there's swap space available).

New Features
~~~~~~~~~~~~

*   The CodeQL compiler now produces better error messages when it is unable to find a QL library that the query being evaluated depends on.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The :code:`java/index-out-of-bounds` query has improved its handling of arrays of constant length, and may report additional results in those cases.

Ruby
""""

*   The :code:`rb/polynomial-redos` query now considers the entrypoints of the API of a gem as sources.

New Queries
~~~~~~~~~~~

Golang
""""""

*   Added a new query, :code:`go/unhandled-writable-file-close`, to detect instances where writable file handles are closed without appropriate checks for errors.

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/xxe-local`, which is a version of the XXE query that uses local sources (for example, reads from a local file).

Ruby
""""

*   Added a new query, :code:`rb/regex/badly-anchored-regexp`, to detect regular expression validators that use :code:`^` and :code:`$` as anchors and therefore might match only a single line of a multi-line string.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The precision of the :code:`go/log-injection` query was decreased from :code:`high` to :code:`medium`, since it may not be able to identify every way in which log data may be sanitized. This also aligns it with the precision of comparable queries for other languages.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Python
""""""

*   Python 2 is no longer supported for extracting databases using the CodeQL CLI. As a consequence,
    the previously deprecated support for :code:`pyxl` and :code:`spitfire` templates has also been removed. When extracting Python 2 code, having Python 2 installed is still recommended, as this ensures the correct version of the Python standard library is extracted.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   C# 11: Added extractor support for the :code:`scoped` modifier annotation on parameters and local variables.

Golang
""""""

*   Support for the Twirp framework has been added.

Java/Kotlin
"""""""""""

*   Removed the first argument of :code:`java.nio.file.Files#createTempDirectory(String,FileAttribute[])` as a "create-file" sink.
*   Added the first argument of :code:`java.nio.file.Files#copy` as a "read-file" sink for the :code:`java/path-injection` query.
*   The data flow library now disregards flow through code that is dead based on some basic constant propagation, for example, guards like :code:`if (1+1>3)`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added dataflow sources for the `express-ws <https://www.npmjs.com/package/express-ws>`__ library.

Python
""""""

*   Fixed module resolution so we properly recognize that in :code:`from <pkg> import *`, where :code:`<pkg>` is a package, the actual imports are made from the :code:`<pkg>/__init__.py` file.

Ruby
""""

*   Ruby 3.1: one-line pattern matches are now supported. The AST nodes are named :code:`TestPattern` (:code:`expr in pattern`) and :code:`MatchPattern` (:code:`expr => pattern`).

New Features
~~~~~~~~~~~~

Golang
""""""

*   Go 1.20 is now supported. The extractor now functions as expected when Go 1.20 is installed; the definition of :code:`implementsComparable` has been updated according to Go 1.20's new, more-liberal rules; and taint flow models have been added for relevant, new standard-library functions.

Java/Kotlin
"""""""""""

*   Kotlin versions up to 1.8.20 are now supported.
