.. _codeql-cli-2.8.3:

=========================
CodeQL 2.8.3 (2022-03-14)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.8.3 runs a total of 312 security queries when configured with the Default suite (covering 140 CWE). The Extended suite enables an additional 99 queries (covering 29 more CWE). 4 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Executable binaries for Windows are now digitally signed by a GitHub certificate.

Miscellaneous
~~~~~~~~~~~~~

*   The evaluator logs produced by :code:`--evaluator-log` now default to the maximum verbosity level and will therefore contain more information
    (and, accordingly, grow larger). The verbosity level can still be configured with :code:`--evaluator-log-level`. In particular,
    :code:`--evaluator-log-level=1` will restore the previous default behavior.

Query Packs
-----------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The deprecated queries :code:`cpp/duplicate-block`, :code:`cpp/duplicate-function`, :code:`cpp/duplicate-class`, :code:`cpp/duplicate-file`, :code:`cpp/mostly-duplicate-function`,:code:`cpp/similar-file`, :code:`cpp/duplicated-lines-in-files` have been removed.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Failure to use HTTPS URLs" (:code:`cpp/non-https-url`) has been improved reducing false positive results, and its precision has been increased to 'high'.
*   The :code:`cpp/system-data-exposure` query has been modernized and has converted to a :code:`path-problem` query. There are now fewer false positive results.

C#
""

*   Casts to :code:`dynamic` are excluded from the useless upcasts check (:code:`cs/useless-upcast`).
*   The C# extractor now accepts an extractor option :code:`buildless`, which is used to decide what type of extraction that should be performed. If :code:`true` then buildless (standalone) extraction will be performed. Otherwise tracing extraction will be performed (default).
    The option is added via :code:`codeql database create --language=csharp -Obuildless=true ...`.
*   The C# extractor now accepts an extractor option :code:`trap.compression`, which is used to decide the compression format for TRAP files. The legal values are :code:`brotli` (default), :code:`gzip` or :code:`none`.
    The option is added via :code:`codeql database create --language=csharp -Otrap.compression=value ...`.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   A new query titled "Use of expired stack-address" (:code:`cpp/using-expired-stack-address`) has been added.
    This query finds accesses to expired stack-allocated memory that escaped via a global variable.
*   A new :code:`cpp/insufficient-key-size` query has been added to the default query suite for C/C++. The query finds uses of certain cryptographic algorithms where the key size is too small to provide adequate encryption strength.

Python
""""""

*   The query "XPath query built from user-controlled sources" (:code:`py/xpath-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @porcupineyhairs <https://github.com/github/codeql/pull/6331>`__.

Deprecated Predicates and Classes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The predicates and classes in the :code:`CodeDuplication` library have been deprecated.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C#
""

*   The C# extractor no longer supports the following legacy environment variables:

    ..  code-block:: text
    
        ODASA_BUILD_ERROR_DIR
        ODASA_CSHARP_LAYOUT
        ODASA_SNAPSHOT
        SEMMLE_DIST
        SEMMLE_EXTRACTOR_OPTIONS
        SEMMLE_PLATFORM_TOOLS
        SEMMLE_PRESERVE_SYMLINKS
        SOURCE_ARCHIVE
        TRAP_FOLDER

*   :code:`codeql test run` now extracts source code recursively from sub folders. This may break existing tests that have other tests in nested sub folders, as those will now get the nested test code included.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 4.6.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Many queries now support structured bindings, as structured bindings are now handled in the IR translation.

Java/Kotlin
"""""""""""

*   Add support for :code:`CharacterLiteral` in :code:`CompileTimeConstantExpr.getStringValue()`

JavaScript/TypeScript
"""""""""""""""""""""

*   Added sources from the |link-code-jszip-1|_ library to the :code:`js/zipslip` query.

Python
""""""

*   Added new SSRF sinks for :code:`httpx`, :code:`pycurl`, :code:`urllib`, :code:`urllib2`, :code:`urllib3`, and :code:`libtaxii`. This improvement was `submitted by @haby0 <https://github.com/github/codeql/pull/8275>`__.
*   The regular expression parser now groups sequences of normal characters. This reduces the number of instances of :code:`RegExpNormalChar`.
*   Fixed taint propagation for attribute assignment. In the assignment :code:`x.foo = tainted` we no longer treat the entire object :code:`x` as tainted, just because the attribute :code:`foo` contains tainted data. This leads to slightly fewer false positives.
*   Improved analysis of attributes for data-flow and taint tracking queries, so :code:`getattr`\ /\ :code:`setattr` are supported, and a write to an attribute properly stops flow for the old value in that attribute.
*   Added post-update nodes (:code:`DataFlow::PostUpdateNode`) for arguments in calls that can't be resolved.

Ruby
""""

*   The :code:`Regex` class is now an abstract class that extends :code:`StringlikeLiteral` with implementations for :code:`RegExpLiteral` and string literals that 'flow' into functions that are known to interpret string arguments as regular expressions such as :code:`Regex.new` and :code:`String.match`.
*   The regular expression parser now groups sequences of normal characters. This reduces the number of instances of :code:`RegExpNormalChar`.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added :code:`hasDescendant(RefType anc, Type sub)`
*   Added :code:`RefType.getADescendant()`
*   Added :code:`RefType.getAStrictAncestor()`

.. |link-code-jszip-1| replace:: :code:`jszip`\ 
.. _link-code-jszip-1: https://www.npmjs.com/package/jszip

