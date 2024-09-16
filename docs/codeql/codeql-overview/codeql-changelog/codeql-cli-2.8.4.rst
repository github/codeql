.. _codeql-cli-2.8.4:

=========================
CodeQL 2.8.4 (2022-03-29)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.8.4 runs a total of 315 security queries when configured with the Default suite (covering 140 CWE). The Extended suite enables an additional 99 queries (covering 29 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed an error where running out of memory during query evaluation would cause :code:`codeql` to exit with status 34 instead of the 99 that is documented for this condition.
    
*   Fixed a bug in our handling of Clang's header maps, which caused missing files for Xcode-based projects on macOS (e.g. WebKit).

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/overflow-destination`, :code:`cpp/unclear-array-index-validation`, and :code:`cpp/uncontrolled-allocation-size` queries have been modernized and converted to :code:`path-problem` queries and provide more true positive results.
*   The :code:`cpp/system-data-exposure` query has been increased from :code:`medium` to :code:`high` precision, following a number of improvements to the query logic.

Java/Kotlin
"""""""""""

*   Updated "Local information disclosure in a temporary directory" (:code:`java/local-temp-file-or-directory-information-disclosure`) to remove false-positives when OS is properly used as logical guard.

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed an issue that would sometimes prevent the data-flow analysis from finding flow paths through a function that stores its result on an object.
    This may lead to more results for the security queries.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query "Insertion of sensitive information into log files" (:code:`java/sensitive-logging`) has been promoted from experimental to the main query pack. This query was originally `submitted as an experimental query by @luchua-bc <https://github.com/github/codeql/pull/3090>`__.

Ruby
""""

*   Added a new query, :code:`rb/clear-text-storage-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are stored as cleartext.
*   Added a new query, :code:`rb/incomplete-hostname-regexp`. The query finds instances where a hostname is incompletely sanitized due to an unescaped character in a regular expression.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The flow state variants of :code:`isBarrier` and :code:`isAdditionalFlowStep` are no longer exposed in the taint tracking library. The :code:`isSanitizer` and :code:`isAdditionalTaintStep` predicates should be used instead.

C#
""

*   The flow state variants of :code:`isBarrier` and :code:`isAdditionalFlowStep` are no longer exposed in the taint tracking library. The :code:`isSanitizer` and :code:`isAdditionalTaintStep` predicates should be used instead.

Java/Kotlin
"""""""""""

*   The flow state variants of :code:`isBarrier` and :code:`isAdditionalFlowStep` are no longer exposed in the taint tracking library. The :code:`isSanitizer` and :code:`isAdditionalTaintStep` predicates should be used instead.

Python
""""""

*   The flow state variants of :code:`isBarrier` and :code:`isAdditionalFlowStep` are no longer exposed in the taint tracking library. The :code:`isSanitizer` and :code:`isAdditionalTaintStep` predicates should be used instead.

Ruby
""""

*   The flow state variants of :code:`isBarrier` and :code:`isAdditionalFlowStep` are no longer exposed in the taint tracking library. The :code:`isSanitizer` and :code:`isAdditionalTaintStep` predicates should be used instead.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   :code:`DefaultOptions::exits` now holds for C11 functions with the :code:`_Noreturn` or :code:`noreturn` specifier.
*   :code:`hasImplicitCopyConstructor` and :code:`hasImplicitCopyAssignmentOperator` now correctly handle implicitly-deleted operators in templates.
*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

C#
""

*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Java/Kotlin
"""""""""""

*   Added new guards :code:`IsWindowsGuard`, :code:`IsSpecificWindowsVariant`, :code:`IsUnixGuard`, and :code:`IsSpecificUnixVariant` to detect OS specific guards.
*   Added a new predicate :code:`getSystemProperty` that gets all expressions that retrieve system properties from a variety of sources (eg. alternative JDK API's, Google Guava, Apache Commons, Apache IO, etc.).
*   Added support for detection of SSRF via JDBC database URLs, including connections made using the standard library (:code:`java.sql`), Hikari Connection Pool, JDBI and Spring JDBC.
*   Re-removed support for :code:`CharacterLiteral` from :code:`CompileTimeConstantExpr.getStringValue()` to restore the convention that that predicate only applies to :code:`String`\ -typed constants.
*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

JavaScript/TypeScript
"""""""""""""""""""""

*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Python
""""""

*   All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

Ruby
""""

*   :code:`getConstantValue()` now returns the contents of strings and symbols after escape sequences have been interpreted. For example, for the Ruby string literal :code:`"\n"`, :code:`getConstantValue().getString()` previously returned a QL string with two characters, a backslash followed by :code:`n`\ ; now it returns the single-character string "\n" (U+000A, known as newline).
*   :code:`getConstantValue().getInt()` previously returned incorrect values for integers larger than 2\ :sup:`31`-1 (the largest value that can be represented by the QL :code:`int` type). It now returns no result in those cases.
*   Added :code:`OrmWriteAccess` concept to model data written to a database using an object-relational mapping (ORM) library.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

C#
""

*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Java/Kotlin
"""""""""""

*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

JavaScript/TypeScript
"""""""""""""""""""""

*   Some predicates from :code:`DefUse.qll`, :code:`DataFlow.qll`, :code:`TaintTracking.qll`, :code:`DOM.qll`, :code:`Definitions.qll` that weren't used by any query have been deprecated.
    The documentation for each predicate points to an alternative.
*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.
*   Some modules that started with a lowercase letter have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Python
""""""

*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.
*   Some modules that started with a lowercase letter have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

Ruby
""""

*   Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide.
    The old name still exists as a deprecated alias.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   The data flow and taint tracking libraries have been extended with versions of :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isBarrierGuard`, respectively :code:`isSanitizerIn`, :code:`isSanitizerOut`, and :code:`isSanitizerGuard`, that support flow states.

C#
""

*   The data flow and taint tracking libraries have been extended with versions of :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isBarrierGuard`, respectively :code:`isSanitizerIn`, :code:`isSanitizerOut`, and :code:`isSanitizerGuard`, that support flow states.

Java/Kotlin
"""""""""""

*   The data flow and taint tracking libraries have been extended with versions of :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isBarrierGuard`, respectively :code:`isSanitizerIn`, :code:`isSanitizerOut`, and :code:`isSanitizerGuard`, that support flow states.

Python
""""""

*   The data flow and taint tracking libraries have been extended with versions of :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isBarrierGuard`, respectively :code:`isSanitizerIn`, :code:`isSanitizerOut`, and :code:`isSanitizerGuard`, that support flow states.

Ruby
""""

*   The data flow and taint tracking libraries have been extended with versions of :code:`isBarrierIn`, :code:`isBarrierOut`, and :code:`isBarrierGuard`, respectively :code:`isSanitizerIn`, :code:`isSanitizerOut`, and :code:`isSanitizerGuard`, that support flow states.
