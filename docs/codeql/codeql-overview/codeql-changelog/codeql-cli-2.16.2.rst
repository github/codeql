.. _codeql-cli-2.16.2:

==========================
CodeQL 2.16.2 (2024-02-12)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.16.2 runs a total of 406 security queries when configured with the Default suite (covering 160 CWE). The Extended suite enables an additional 131 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Corrected 2 false positive with :code:`cpp/incorrect-string-type-conversion`\ : conversion of byte arrays to wchar and new array allocations converted to wchar.
*   The "Incorrect return-value check for a 'scanf'-like function" query (:code:`cpp/incorrectly-checked-scanf`) no longer reports an alert when an explicit check for EOF is added.
*   The "Incorrect return-value check for a 'scanf'-like function" query (:code:`cpp/incorrectly-checked-scanf`) now recognizes more EOF checks.
*   The "Potentially uninitialized local variable" query (:code:`cpp/uninitialized-local`) no longer reports an alert when the local variable is used as a qualifier to a static member function call.
*   The diagnostic query :code:`cpp/diagnostics/successfully-extracted-files` now considers any C/C++ file seen during extraction, even one with some errors, to be extracted / scanned. This affects the Code Scanning UI measure of scanned C/C++ files.

C#
""

*   Added string interpolation expressions and :code:`string.Format` as possible sanitizers for the :code:`cs/web/unvalidated-url-redirection` query.

Ruby
""""

*   Added new unsafe deserialization sinks for the ox gem.
*   Added an additional unsafe deserialization sink for the oj gem.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query :code:`java/android/sensitive-text` to detect instances of sensitive data being exposed through text fields without being properly masked.
*   Added a new query :code:`java/android/sensitive-notification` to detect instances of sensitive data being exposed through Android notifications.

Ruby
""""

*   Added a new experimental query, :code:`rb/insecure-randomness`, to detect when application uses random values that are not cryptographically secure.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed the :code:`a` (ASCII) inline flag not being recognized by the regular expression library.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added a new database relation to store compiler arguments specified inside :code:`@[...].rsp` file arguments. The arguments are returned by :code:`Compilation::getExpandedArgument/1` and :code:`Compilation::getExpandedArguments/0`.
*   C# 12: Added extractor, QL library and data flow support for collection expressions like :code:`[1, y, 4, .. x]`.
*   The C# extractor now accepts an extractor option :code:`logging.verbosity` that specifies the verbosity of the logs. The option is added via :code:`codeql database create --language=csharp -Ologging.verbosity=debug ...` or by setting the corresponding environment variable :code:`CODEQL_EXTRACTOR_CSHARP_OPTION_LOGGING_VERBOSITY`.

Java/Kotlin
"""""""""""

*   Added models for the following packages:

    *   com.fasterxml.jackson.databind
    *   javax.servlet
    
*   Added the :code:`java.util.Date` and :code:`java.util.UUID` classes to the list of types in the :code:`SimpleTypeSanitizer` class in :code:`semmle.code.java.security.Sanitizers`.

Python
""""""

*   Added :code:`html.escape` as a sanitizer for HTML.

Ruby
""""

*   Flow is now tracked through Rails :code:`render` calls, when the argument is a :code:`ViewComponent`. In this case, data flow is tracked into the accompanying :code:`.html.erb` file.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added the :code:`PreprocBlock.qll` library to this repository.  This library offers a view of :code:`#if`, :code:`#elif`, :code:`#else` and similar directives as a tree with navigable parent-child relationships.
*   Added a new :code:`ThrowingFunction` abstract class that can be used to model an external function that may throw an exception.
