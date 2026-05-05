.. _codeql-cli-2.25.3:

==========================
CodeQL 2.25.3 (2026-05-01)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.3 runs a total of 496 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   The :code:`codeql database finalize` command now accepts the :code:`--working-dir` flag. When specified, any extractor pre-finalize scripts will be run in that directory. If the flag is not used, the scripts will run in the source root directory (maintaining existing behavior). The flag will also be automatically passed through when running the higher-level
    :code:`codeql database create` command.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Fixed alert messages in :code:`actions/artifact-poisoning/critical` and :code:`actions/artifact-poisoning/medium` as they previously included a redundant placeholder in the alert message that would on occasion contain a long block of yml that makes the alert difficult to understand. Also improved the wording to make it clearer that it is not the artifact that is being poisoned, but instead a potentially untrusted artifact that is consumed. Finally, changed the alert location to be the source, to align more with other queries reporting an artifact (e.g. zipslip) which is more useful.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added :code:`AllocationFunction` models for :code:`aligned_alloc`, :code:`std::aligned_alloc`, and :code:`bsl::aligned_alloc`.
*   The "Comparison of narrow type with wide type in loop condition" (:code:`cpp/comparison-with-wider-type`) query has been upgraded to :code:`high` precision. This query will now run in the default code scanning suite.
*   The "Multiplication result converted to larger type" (:code:`cpp/integer-multiplication-cast-to-long`) query has been upgraded to :code:`high` precision. This query will now run in the default code scanning suite.
*   The "Suspicious add with sizeof" (:code:`cpp/suspicious-add-sizeof`) query has been upgraded to :code:`high` precision. This query will now run in the default code scanning suite.
*   The "Wrong type of arguments to formatting function" (:code:`cpp/wrong-type-format-argument`) query has been upgraded to :code:`high` precision. This query will now run in the default code scanning suite.
*   The "Implicit function declaration" (:code:`cpp/implicit-function-declaration`) query has been upgraded to :code:`high` precision. However, for :code:`build mode: none` databases, it no longer produces any results. The results in this mode were found to be very noisy and fundamentally imprecise.

C#
""

*   The query :code:`cs/useless-tostring-call` has been updated to avoid false positive results in calls to :code:`StringBuilder.AppendLine` and calls of the form :code:`base.ToString()`. Moreover, the alert message has been made more precise.

JavaScript/TypeScript
"""""""""""""""""""""

*   The query :code:`js/missing-rate-limiting` now takes Fastify per-route rate limiting into account.

Python
""""""

*   The :code:`py/bind-socket-all-network-interfaces` query now uses the global data-flow library, leading to better precision and more results. Also, wrappers of :code:`socket.socket` in the :code:`eventlet` and :code:`gevent` libraries are now also recognized as socket binding operations.

GitHub Actions
""""""""""""""

*   The query :code:`actions/missing-workflow-permissions` no longer produces false positive results on reusable workflows where all callers set permissions.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The deprecated :code:`NonThrowingFunction` class has been removed, use :code:`NonCppThrowingFunction` instead.
*   The deprecated :code:`ThrowingFunction` class has been removed, use :code:`AlwaysSehThrowingFunction` instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.3.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The queries "Resolving XML external entity in user-controlled data" (:code:`java/xxe`) and "Resolving XML external entity in user-controlled data from local source" (:code:`java/xxe-local`) now recognize sinks in the Woodstox StAX library when :code:`com.ctc.wstx.stax.WstxInputFactory` or :code:`org.codehaus.stax2.XMLInputFactory2` are used directly.

Python
""""""

*   The Python extractor now supports the new :code:`lazy import ...` and :code:`lazy from ... import ...` (as defined in `PEP-810 <https://peps.python.org/pep-0810/>`__) that will be part of Python 3.15.

GitHub Actions
""""""""""""""

*   Removed false positive injection sink models for the :code:`context` input of :code:`docker/build-push-action` and the :code:`allowed-endpoints` input of :code:`step-security/harden-runner`.

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   The predicates :code:`get[L|R]Value` in the class :code:`Assignment` have been deprecated. Use :code:`get[Left|Right]Operand` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a subclass :code:`AutoconfConfigureTestFile` of :code:`ConfigurationTestFile` that represents files created by GNU autoconf configure scripts to test the build configuration.
