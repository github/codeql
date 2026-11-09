.. _codeql-cli-2.27.4:

==========================
CodeQL 2.27.4 (2026-11-02)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.4 runs a total of 498 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   The CodeQL CLI now writes messages from the Java virtual machine, such as warnings and initialization errors, to standard error instead of standard output. Previously, these messages could corrupt the output of commands that print JSON or other machine-readable output.

Security Updates
~~~~~~~~~~~~~~~~

*   :code:`codeql pack bundle` and :code:`codeql pack publish` now check that each file added to the pack archive is still inside the pack root after symbolic links are resolved. Files that resolve to a location outside the pack root are omitted from the archive with a warning.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/suspicious-pointer-scaling` query no longer reports false positives for intentional pointer arithmetic from :code:`std::byte*` buffers.
*   The :code:`cpp/unused-local-variable` and :code:`cpp/unused-static-variable` queries no longer report variables marked with the C++17 :code:`[[maybe_unused]]` attribute.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/invalid-prototype-value` query no longer reports computed :code:`__proto__` properties in object literals.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added a new :code:`cpp-code-quality` query suite containing queries that identify maintainability and reliability issues in C and C++ code.

C#
""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`cs/redos` and :code:`cs/regex-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

Java/Kotlin
"""""""""""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`java/redos`, :code:`java/polynomial-redos` and :code:`java/regex-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`js/redos`, :code:`js/polynomial-redos`, :code:`js/regex-injection`, :code:`js/regex-injection-more-sources`, :code:`js/server-crash` and :code:`js/loop-bound-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

Python
""""""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`py/redos`, :code:`py/polynomial-redos` and :code:`py/regex-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

Ruby
""""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`rb/redos`, :code:`rb/polynomial-redos` and :code:`rb/regexp-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

Swift
"""""

*   The :code:`external/cwe/cwe-730` tag has been removed from :code:`swift/redos` and :code:`swift/regex-injection`, because MITRE has marked CWE-730 as prohibited for vulnerability mapping. The queries retain their other CWE tags.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   The Go extractor no longer modifies the global Git configuration when private :code:`git_source` registries are configured. The registry proxy certificate is now passed to Git through the :code:`GIT_SSL_CAINFO` environment variable instead, which only affects the Git processes spawned by :code:`go`.

Breaking Changes
~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`SEMMLE_TYPESCRIPT_HOME` environment variable is no longer supported. The JavaScript/TypeScript extractor now ignores the environment variable and always uses its bundled TypeScript compiler.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Rolled back the change that set proxy and certificate environment variables for the subprocess that invokes the NuGet CLI because the environment variables were only partially respected by the target process in some cases.

Java/Kotlin
"""""""""""

*   The :code:`java/log-injection` query now recognizes additional sanitizers and sanitizer guards from the JDK, Apache Commons Lang and Text, Guava, OWASP Java Encoder, and Spring Framework.
*   Queries that use path-injection sanitizers now recognize additional substring guards and string replacement and removal operations from Apache Commons Lang and Guava.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added taint steps for :code:`String.prototype.trimStart`, :code:`trimEnd`, and :code:`normalize`.
*   Fixed the flow summary for :code:`Array.prototype.flatMap`. The :code:`thisArg` argument now flows to the callback's :code:`this` instead of its index parameter.

Rust
""""

*   The early return taken by the :code:`?` operator no longer makes the unwrapped value of :code:`x?` flow out of the enclosing function. This fixes false positive results from queries such as :code:`rust/cleartext-logging`, where a sensitive value read with :code:`?` was reported as part of an unrelated return value.
*   Added neutral models to inhibit spurious generated sink models for :code:`actix_web::HttpRequest::connection_info` and the methods built on it, such as :code:`full_url` and :code:`url_for`. This fixes some false positive results from queries such as :code:`rust/uncontrolled-allocation-size` and :code:`rust/log-injection`.
*   Added neutral models to inhibit spurious generated sink models for :code:`Vec` and :code:`VecDeque` methods such as :code:`insert`, :code:`remove` and :code:`push_back`. This fixes some false positive results from queries such as :code:`rust/cleartext-logging`.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   :code:`ControlFlow::ConditionGuardNode` is now deprecated. Use the API from :code:`semmle.go.controlflow.Guards` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added support for the :code:`__builtin_lt_synthesizes_from_spaceship`, :code:`__builtin_gt_synthesizes_from_spaceship`, :code:`__builtin_le_synthesizes_from_spaceship`, :code:`__builtin_ge_synthesizes_from_spaceship`, :code:`__builtin_is_implicit_lifetime`, :code:`__builtin_is_structural`, and :code:`__builtin_is_virtual_base_of` builtin operations.
*   Added a new predicate :code:`getBitWidth` to the :code:`Type` class, which yields the bit-width of the type.

Golang
""""""

*   The Go language library now instantiates the shared library :code:`semmle.go.controlflow.Guards`, including the :code:`Guard` and :code:`GuardValue` classes and the :code:`guardEnsures`, :code:`guardEnsuresEq`, :code:`guardEnsuresNeq`, and :code:`guardEnsuresLeq` predicates.
