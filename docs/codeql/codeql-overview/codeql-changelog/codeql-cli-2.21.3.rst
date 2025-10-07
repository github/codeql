.. _codeql-cli-2.21.3:

==========================
CodeQL 2.21.3 (2025-05-15)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.21.3 runs a total of 452 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 136 queries (covering 35 more CWE).

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   Windows binaries for the CodeQL CLI are now built with :code:`/guard:cf`, enabling `Control Flow Guard <https://learn.microsoft.com/en-us/windows/win32/secbp/control-flow-guard>`__.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Changed the precision of the :code:`cs/equality-on-floats` query from medium to high.

JavaScript/TypeScript
"""""""""""""""""""""

*   Type information is now propagated more precisely through :code:`Promise.all()` calls,
    leading to more resolved calls and more sources and sinks being detected.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The tag :code:`external/cwe/cwe-14` has been removed from :code:`cpp/memset-may-be-deleted` and the tag :code:`external/cwe/cwe-014` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cpp/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cpp/count-untrusted-data-external-api-ir` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cpp/untrusted-data-to-external-api-ir` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cpp/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cpp/late-check-of-function-argument` and the tag :code:`external/cwe/cwe-020` has been added.

C#
""

*   The tag :code:`external/cwe/cwe-13` has been removed from :code:`cs/password-in-configuration` and the tag :code:`external/cwe/cwe-013` has been added.
*   The tag :code:`external/cwe/cwe-11` has been removed from :code:`cs/web/debug-binary` and the tag :code:`external/cwe/cwe-011` has been added.
*   The tag :code:`external/cwe/cwe-16` has been removed from :code:`cs/web/large-max-request-length` and the tag :code:`external/cwe/cwe-016` has been added.
*   The tag :code:`external/cwe/cwe-16` has been removed from :code:`cs/web/request-validation-disabled` and the tag :code:`external/cwe/cwe-016` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cs/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cs/serialization-check-bypass` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`cs/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-12` has been removed from :code:`cs/web/missing-global-error-handler` and the tag :code:`external/cwe/cwe-012` has been added.

Golang
""""""

*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/incomplete-hostname-regexp` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/regex/missing-regexp-anchor` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/suspicious-character-in-regex` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`go/untrusted-data-to-unknown-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-90` has been removed from :code:`go/ldap-injection` and the tag :code:`external/cwe/cwe-090` has been added.
*   The tag :code:`external/cwe/cwe-74` has been removed from :code:`go/dsn-injection` and the tag :code:`external/cwe/cwe-074` has been added.
*   The tag :code:`external/cwe/cwe-74` has been removed from :code:`go/dsn-injection-local` and the tag :code:`external/cwe/cwe-074` has been added.
*   The tag :code:`external/cwe/cwe-79` has been removed from :code:`go/html-template-escaping-passthrough` and the tag :code:`external/cwe/cwe-079` has been added.

Java/Kotlin
"""""""""""

*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`java/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`java/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-93` has been removed from :code:`java/netty-http-request-or-response-splitting` and the tag :code:`external/cwe/cwe-093` has been added.

JavaScript/TypeScript
"""""""""""""""""""""

*   The tag :code:`external/cwe/cwe-79` has been removed from :code:`js/disabling-electron-websecurity` and the tag :code:`external/cwe/cwe-079` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`js/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`js/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`js/untrusted-data-to-external-api-more-sources` and the tag :code:`external/cwe/cwe-020` has been added.

Python
""""""

*   The tags :code:`security/cwe/cwe-94` and :code:`security/cwe/cwe-95` have been removed from :code:`py/use-of-input` and the tags :code:`external/cwe/cwe-094` and :code:`external/cwe/cwe-095` have been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`py/count-untrusted-data-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`py/untrusted-data-to-external-api` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`py/cookie-injection` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-20` has been removed from :code:`py/incomplete-url-substring-sanitization` and the tag :code:`external/cwe/cwe-020` has been added.
*   The tag :code:`external/cwe/cwe-94` has been removed from :code:`py/js2py-rce` and the tag :code:`external/cwe/cwe-094` has been added.

Ruby
""""

*   The precision of :code:`rb/useless-assignment-to-local` has been adjusted from :code:`medium` to :code:`high`.
*   The tag :code:`external/cwe/cwe-94` has been removed from :code:`rb/server-side-template-injection` and the tag :code:`external/cwe/cwe-094` has been added.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed an infinite loop in :code:`semmle.code.cpp.rangeanalysis.new.RangeAnalysis` when computing ranges in very large and complex function bodies.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Enhanced modeling of the `fastify <https://www.npmjs.com/package/fastify>`__ framework to support the :code:`all` route handler method.
*   Improved modeling of the |link-code-shelljs-1|_ and |link-code-async-shelljs-2|_ libraries by adding support for the :code:`which`, :code:`cmd`, :code:`asyncExec` and :code:`env`.
*   Added support for the :code:`fastify` :code:`addHook` method.

Python
""""""

*   Added modeling for the :code:`hdbcli` PyPI package as a database library implementing PEP 249.
*   Added header write model for :code:`send_header` in :code:`http.server`.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Kotlin versions up to 2.2.0\ *x* are now supported. Support for the Kotlin 1.5.x series is dropped (so the minimum Kotlin version is now 1.6.0).

Swift
"""""

*   Added AST nodes :code:`UnsafeCastExpr`, :code:`TypeValueExpr`, :code:`IntegerType`, and :code:`BuiltinFixedArrayType` that correspond to new nodes added by Swift 6.1.

.. |link-code-shelljs-1| replace:: :code:`shelljs`\ 
.. _link-code-shelljs-1: https://www.npmjs.com/package/shelljs

.. |link-code-async-shelljs-2| replace:: :code:`async-shelljs`\ 
.. _link-code-async-shelljs-2: https://www.npmjs.com/package/async-shelljs

