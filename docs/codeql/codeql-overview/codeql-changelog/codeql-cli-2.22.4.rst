.. _codeql-cli-2.22.4:

==========================
CodeQL 2.22.4 (2025-08-21)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.22.4 runs a total of 478 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 130 queries (covering 32 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/short-global-name` query will no longer give alerts for instantiations of template variables, only for the template itself.
*   Fixed a false positive in :code:`cpp/overflow-buffer` when the type of the destination buffer is a reference to a class/struct type.

Golang
""""""

*   Go 1.25 is now supported.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/regex-injection` query no longer considers environment variables as sources by default. Environment variables can be re-enabled as sources by setting the threat model to include the "environment" category.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/cleartext-storage-database`, for detecting cases where sensitive information is stored non-encrypted in a database.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Ruby
""""

*   Made the following changes to :code:`NetHttpRequest`

    *   Adds :code:`connectionNode`, like other Ruby HTTP clients
    *   Makes :code:`requestNode` and :code:`connectionNode` public so subclasses can use them
    *   Adds detection of :code:`Net::HTTP.start`, a common way to make HTTP requests in Ruby

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added library models for the relevant method calls under :code:`jakarta.servlet.ServletRequest` and :code:`jakarta.servlet.http.HttpServletRequest` as remote flow sources.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The guards libraries (:code:`semmle.code.cpp.controlflow.Guards` and :code:`semmle.code.cpp.controlflow.IRGuards`) have been improved to recognize more guards.
*   Improved dataflow through global variables in the new dataflow library (:code:`semmle.code.cpp.dataflow.new.DataFlow` and :code:`semmle.code.cpp.dataflow.new.TaintTracking`). Queries based on these libraries will produce more results on codebases with many global variables.
*   The global value numbering library (:code:`semmle.code.cpp.valuenumbering.GlobalValueNumbering` and :code:`semmle.code.cpp.ir.ValueNumbering`) has been improved so more expressions are assigned the same value number.

Java/Kotlin
"""""""""""

*   Guard implication logic involving wrapper methods has been improved. In particular, this means fewer false positives for :code:`java/dereferenced-value-may-be-null`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Improved modeling of command-line argument parsing libraries `arg <https://www.npmjs.com/package/arg>`__, `args <https://www.npmjs.com/package/args>`__, `command-line-args <https://www.npmjs.com/package/command-line-args>`__ and `commander <https://www.npmjs.com/package/commander>`__

Rust
""""

*   |link-code-let-chains-in-code-if-and-code-while-1|_ are now supported, as well as |link-code-if-let-guards-in-code-match-expressions-2|_.
*   Added more detail to models of :code:`postgres`, :code:`rusqlite`, :code:`sqlx` and :code:`tokio-postgres`. This may improve query results, particularly for :code:`rust/sql-injection` and :code:`rust/cleartext-storage-database`.

.. |link-code-let-chains-in-code-if-and-code-while-1| replace:: :code:`let` chains in :code:`if` and :code:`while`\ 
.. _link-code-let-chains-in-code-if-and-code-while-1: https://doc.rust-lang.org/edition-guide/rust-2024/let-chains.html

.. |link-code-if-let-guards-in-code-match-expressions-2| replace:: :code:`if let` guards in :code:`match` expressions
.. _link-code-if-let-guards-in-code-match-expressions-2: https://rust-lang.github.io/rfcs/2294-if-let-guard.html

