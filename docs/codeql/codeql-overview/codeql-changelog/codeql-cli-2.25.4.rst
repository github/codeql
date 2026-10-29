.. _codeql-cli-2.25.4:

==========================
CodeQL 2.25.4 (2026-05-05)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.4 runs a total of 496 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C#
""

*   The C# control flow graph (CFG) implementation has been completely rewritten. The CFG now includes additional nodes to more accurately represent certain constructs. This also means that any existing code that implicitly relies on very specific details about the CFG may need to be updated.
    The CFG no longer uses splitting, which means that AST nodes now have a unique CFG node representation.
    Additionally, the following breaking changes have been made:

    *   :code:`ControlFlow::Node` has been renamed to :code:`ControlFlowNode`.
    *   :code:`ControlFlow::Nodes` has been renamed to :code:`ControlFlowNodes`.
    *   :code:`BasicBlock.getCallable` has been renamed to :code:`BasicBlock.getEnclosingCallable`.
    *   :code:`BasicBlocks.qll` has been deleted.
    *   :code:`ControlFlowNode.getAstNode` has changed its meaning. The AST-to-CFG mapping remains one-to-many, but now for a different reason. It used to be because of splitting, but now it's because of additional "helper" CFG nodes. To get the (now canonical) CFG node for a given AST node, use
        :code:`ControlFlowNode.asExpr()` or :code:`ControlFlowNode.asStmt()` or
        :code:`ControlFlowElement.getControlFlowNode()` instead.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   When resolving dependencies in :code:`build-mode: none`, :code:`dotnet restore` now explicitly receives reachable NuGet feeds configured in :code:`nuget.config` when feed responsiveness checking is enabled (the default), and any private registries directly, improving reliability when default feeds are unavailable or restricted.

Swift
"""""

*   Upgraded to allow analysis of Swift 6.3.1.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added taint flow models for the :code:`Strsafe.h` header from the Windows SDK.

C#
""

*   Expanded ASP and ASP.NET remote source modeling to cover additional sources, including fields of tainted parameters as well as properties and fields that become tainted transitively.
*   C# 14: Added support for user-defined compound assignment operators.

Java/Kotlin
"""""""""""

*   Added :code:`sql-injection` sink models for the Hibernate :code:`org.hibernate.query.QueryProducer` methods :code:`createNativeMutationQuery`, :code:`createMutationQuery`, and :code:`createSelectionQuery`.
*   The :code:`java/partial-path-traversal` and :code:`java/partial-path-traversal-from-remote` queries now correctly recognize file separator appends using :code:`+=`.
*   The :code:`java/path-injection` and :code:`java/zipslip` queries now recognize :code:`Path.toRealPath()` as a path normalization sanitizer, consistent with the existing treatment of :code:`Path.normalize()` and :code:`File.getCanonicalPath()`. This reduces false positives for code that uses the NIO.2 API for path canonicalization.
*   The :code:`java/sensitive-log` query now excludes additional common variable naming patterns that do not hold sensitive data, reducing false positives. This includes pagination/iteration tokens (:code:`nextToken`, :code:`pageToken`, :code:`continuationToken`), token metadata (:code:`tokenType`, :code:`tokenEndpoint`, :code:`tokenCount`), and secret metadata (:code:`secretName`, :code:`secretId`, :code:`secretVersion`).
*   The :code:`java/sensitive-log` query now treats method calls whose names contain "encrypt", "hash", or "digest" as sanitizers, consistent with the existing treatment in :code:`java/cleartext-storage-in-log`. This reduces false positives when sensitive data is hashed or encrypted before logging.
*   The :code:`java/trust-boundary-violation` query now recognizes regular expression checks (including :code:`String.matches()` guards and :code:`@javax.validation.constraints.Pattern` annotations) as sanitizers, consistent with the existing treatment of ESAPI validators. This reduces false positives when input is validated against a pattern before being stored in a session.

Python
""""""

*   The Python extractor now supports unpacking in comprehensions, e.g. :code:`[*x for x in nested]` (as defined in `PEP-798 <https://peps.python.org/pep-0798/>`__) that will be part of Python 3.15.

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   The QL classes in the C# SSA library have been renamed to improve consistency between languages. Any custom QL code that makes use of SSA needs to be updated. The old classes have been deprecated and include more detailed migration instructions in their qldoc.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A new predicate :code:`getSwitchCase` was added to the :code:`SwitchStmt` class, which yields the :code:`n`\ th :code:`case` statement from a :code:`switch` statement.
*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for C and C++ <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-cpp/>`__.

C#
""

*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for C# <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-csharp/>`__.

Golang
""""""

*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for Go <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-go/>`__.

Java/Kotlin
"""""""""""

*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for Java and Kotlin <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-java-and-kotlin/>`__.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for |link-code-vercel-node-1|_ Vercel serverless functions. Handlers are recognized via the :code:`VercelRequest`\ /\ :code:`VercelResponse` TypeScript parameter types, and standard security queries (:code:`js/reflected-xss`, :code:`js/request-forgery`, :code:`js/sql-injection`, :code:`js/command-line-injection`, etc.) now detect vulnerabilities in Vercel API route files.
*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for JavaScript <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/>`__.

Python
""""""

*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for Python <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-python/>`__.

Ruby
""""

*   Data flow barriers and barrier guards can now be added using data extensions. For more information see `Customizing library models for Ruby <https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-ruby/>`__.

Swift
"""""

*   The :code:`BuiltinFixedArrayType` class now defines the predicates :code:`getSize` and :code:`getElementType`, which yield the size of the array and the type of elements stored in the array, respectively.

Rust
""""

*   Data flow barriers and barrier guards can now be added using data extensions.

.. |link-code-vercel-node-1| replace:: :code:`@vercel/node`\ 
.. _link-code-vercel-node-1: https://www.npmjs.com/package/@vercel/node

