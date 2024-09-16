.. _codeql-cli-2.9.1:

=========================
CodeQL 2.9.1 (2022-05-05)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.9.1 runs a total of 327 security queries when configured with the Default suite (covering 140 CWE). The Extended suite enables an additional 103 queries (covering 29 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Query :code:`java/insecure-cookie` no longer produces a false positive if :code:`cookie.setSecure(...)` is called passing a constant that always equals :code:`true`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The call graph now deals more precisely with calls to accessors (getters and setters).
    Previously, calls to static accessors were not resolved, and some method calls were incorrectly seen as calls to an accessor. Both issues have been fixed.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   An new query :code:`cpp/external-entity-expansion` has been added. The query detects XML objects that are vulnerable to external entity expansion (XXE) attacks.

Ruby
""""

*   Added a new query, :code:`rb/insecure-download`. The query finds cases where executables and other sensitive files are downloaded over an insecure connection, which may allow for man-in-the-middle attacks.
*   Added a new query, :code:`rb/regex/missing-regexp-anchor`, which finds regular expressions which are improperly anchored. Validations using such expressions are at risk of being bypassed.
*   Added a new query, :code:`rb/incomplete-sanitization`. The query finds string transformations that do not replace or escape all occurrences of a meta-character.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   The QL class :code:`JumpStmt` has been made the superclass of :code:`BreakStmt`, :code:`ContinueStmt` and :code:`YieldStmt`. This allows directly using its inherited predicates without having to explicitly cast to :code:`JumpStmt` first.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

C#
""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

Java/Kotlin
"""""""""""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

Python
""""""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

Ruby
""""

*   The signature of :code:`allowImplicitRead` on :code:`DataFlow::Configuration` and :code:`TaintTracking::Configuration` has changed from :code:`allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to :code:`allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   More Windows pool allocation functions are now detected as :code:`AllocationFunction`\ s.
*   The :code:`semmle.code.cpp.commons.Buffer` library has been enhanced to handle array members of classes that do not specify a size.

Java/Kotlin
"""""""""""

*   Improved the data flow support for the Android class :code:`SharedPreferences$Editor`. Specifically, the fluent logic of some of its methods is now taken into account when calculating data flow.

    *   Added flow sources and steps for JMS versions 1 and 2.
    *   Added flow sources and steps for RabbitMQ.
    *   Added flow steps for :code:`java.io.DataInput` and :code:`java.io.ObjectInput` implementations.
    
*   Added data-flow models for the Spring Framework component :code:`spring-beans`.
