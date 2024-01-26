.. _codeql-cli-2.9.4:

=========================
CodeQL 2.9.4 (2022-06-20)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.9.4 runs a total of 335 security queries when configured with the Default suite (covering 142 CWE). The Extended suite enables an additional 104 queries (covering 30 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Users of CodeQL Packaging Beta can now optionally authenticate to Container registries on GitHub Enterprise Server (GHES) versions 3.6 and later using standard input instead of the :code:`CODEQL_REGISTRIES_AUTH` environment variable. To authenticate via standard input, pass
    :code:`--registries-auth-stdin`. The value you provide will override the value of the :code:`CODEQL_REGISTRIES_AUTH` environment variable.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   Calls to :code:`Zip::File.open` and :code:`Zip::File.new` have been added as :code:`FileSystemAccess` sinks. As a result queries like :code:`rb/path-injection` now flag up cases where users may access arbitrary archive files.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   An :code:`isBraced` predicate was added to the :code:`Initializer` class which holds when a C++ braced initializer was used in the initialization.
