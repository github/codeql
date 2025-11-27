.. _codeql-cli-2.23.3:

==========================
CodeQL 2.23.3 (2025-10-17)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.3 runs a total of 480 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The :code:`--permissive` command line option has been removed from the C/C++ extractor,
    and passing the option will make the extractor fail. The option was introduced to make the extractor accept the following invalid code, which is accepted by gcc with the :code:`-fpermissive` flag:

    ..  code-block:: cpp
    
        void f(char*);
        void g() {
          const char* str = "string";
          f(str);
        }
        
    The :code:`--permissive` option was removed, as under some circumstances it would break the extractor's ability to parse valid C++ code. When calling the extractor directly,
    :code:`--permissive` should no longer be passed. The above code will fail to parse, and we recommend the code being made :code:`const`\ -correct.

Bug Fixes
~~~~~~~~~

*   Fixed a bug that made many :code:`codeql` subcommands fail with the message :code:`not in while, until, select, or repeat loop` on Linux or macOS systems where :code:`/bin/sh` is :code:`zsh`.

Query Packs
-----------

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/insecure-cookie`, to detect cookies created without the 'Secure' attribute.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   The Python extractor no longer crashes with an :code:`ImportError` when run using Python 3.14.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Guards" libraries (:code:`semmle.code.cpp.controlflow.Guards` and :code:`semmle.code.cpp.controlflow.IRGuards`) have been totally rewritten to recognize many more guards. The API remains unchanged, but the :code:`GuardCondition` class now extends :code:`Element` instead of :code:`Expr`.

Golang
""""""

*   The member predicate :code:`writesField` on :code:`DataFlow::Write` now uses the post-update node for :code:`base` when that is the node being updated, which is in all cases except initializing a struct literal. A new member predicate :code:`writesFieldPreUpdate` has been added for cases where this behaviour is not desired.
*   The member predicate :code:`writesElement` on :code:`DataFlow::Write` now uses the post-update node for :code:`base` when that is the node being updated, which is in all cases except initializing an array/slice/map literal. A new member predicate :code:`writesElementPreUpdate` has been added for cases where this behaviour is not desired.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The shape of the Go data-flow graph has changed. Previously for code like :code:`x := def(); use1(x); use2(x)`, there would be edges from the definition of :code:`x` to each use. Now there is an edge from the definition to the first use, then another from the first use to the second, and so on. This means that data-flow barriers work differently - flow will not reach any uses after the barrier node. Where this is not desired it may be necessary to add an additional flow step to propagate the flow forward. Additionally, when a variable may be subject to a side-effect, such as updating an array, passing a pointer to a function that might write through it or writing to a field of a struct, there is now a dedicated post-update node representing the variable after this side-effect has taken place. Previously post-update nodes were aliases for either a variable's definition, or were equal to the pre-update node. This led to backwards steps in the data-flow graph, which could cause false positives. For example, in the previous code there would be an edge from :code:`x` in :code:`use2(x)` back to the definition of :code:`x`. If we define our sources as any argument of :code:`use2` and our sinks as any argument of :code:`use1` then this would lead to a false positive path. Now there are distinct post-update nodes and no backwards edge to the definition, so we will not find this false positive path.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The extraction of location information for parameters, fields, constructors, destructors and user operators has been optimized. Previously, location information was extracted multiple times for each bound generic. Now, only the location of the unbound generic declaration is extracted during the extraction phase, and the QL library explicitly reuses this location for all bound instances of the same generic.
*   The extraction of location information for type parameters and tuples types has been optimized. Previously, location information was extracted multiple times for each type when it was declared across multiple files. Now, the extraction context is respected during the extraction phase, ensuring locations are only extracted within the appropriate context. This change should be transparent to end-users but may improve extraction performance in some cases.
*   The extraction of location information for named types (classes, structs, etc.) has been optimized. Previously, location information was extracted multiple times for each type when it was declared across multiple files. Now, the extraction context is respected during the extraction phase, ensuring locations are only extracted within the appropriate context. This change should be transparent to end-users but may improve extraction performance in some cases.
*   The extraction of the location for bound generic entities (methods, accessors, indexers, properties, and events) has been optimized. Previously, location information was extracted multiple times for each bound generic. Now, only the location of the unbound generic declaration is extracted during the extraction phase, and the QL library explicitly reuses this location for all bound instances of the same generic.

Golang
""""""

*   The query :code:`go/request-forgery` will no longer report alerts when the user input is of a simple type, like a number or a boolean.
*   For the query :code:`go/unvalidated-url-redirection`, when untrusted data is assigned to the :code:`Host` field of a :code:`url.URL` struct, we consider the whole struct untrusted. We now also include the case when this happens during struct initialization, for example :code:`&url.URL{Host: untrustedData}`.
*   :code:`go/unvalidated-url-redirection` and :code:`go/request-forgery` have a shared notion of a safe URL, which is known to not be malicious. Some URLs which were incorrectly considered safe are now correctly considered unsafe. This may lead to more alerts for those two queries.

Java/Kotlin
"""""""""""

*   Fields of certain objects are considered tainted if the object is tainted. This holds, for example, for objects that occur directly as sources in the active threat model (for instance, a remote flow source). This has now been amended to also include array types, such that if an array like :code:`MyPojo[]` is a source, then fields of a tainted :code:`MyPojo` are now also considered tainted.

Rust
""""

*   Improve data flow through functions being passed as function pointers.

Deprecated APIs
~~~~~~~~~~~~~~~

Golang
""""""

*   The class :code:`SqlInjection::NumericOrBooleanSanitizer` has been deprecated. Use :code:`SimpleTypeSanitizer` from :code:`semmle.go.security.Sanitizers` instead.
*   The member predicate :code:`writesComponent` on :code:`DataFlow::Write` has been deprecated. Instead, use :code:`writesFieldPreUpdate` and :code:`writesElementPreUpdate`, or their new versions :code:`writesField` and :code:`writesElement`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   C/C++ :code:`build-mode: none` support is now generally available.

Rust
""""

*   Rust analysis is now Generally Available (GA).
