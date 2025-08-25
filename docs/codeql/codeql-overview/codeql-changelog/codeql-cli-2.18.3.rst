.. _codeql-cli-2.18.3:

==========================
CodeQL 2.18.3 (2024-08-28)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.18.3 runs a total of 425 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/uncontrolled-allocation-size` ("Uncontrolled allocation size") query now considers arithmetic operations that might reduce the size of user input as a barrier. The query therefore produces fewer false positive results.

C#
""

*   Attributes in the :code:`System.Runtime.CompilerServices` namespace are ignored when checking if a declaration requires documentation comments.
*   C# build-mode :code:`none` analyses now report a warning on the CodeQL status page when there are significant analysis problems -- defined as 5% of expressions lacking a type, or 5% of call targets being unknown. Other messages reported on the status page are downgraded from warnings to notes and so are less prominent, but are still available for review.

JavaScript/TypeScript
"""""""""""""""""""""

*   Message events in the browser are now properly classified as client-side taint sources. Previously they were incorrectly classified as server-side taint sources, which resulted in some alerts being reported by the wrong query, such as server-side URL redirection instead of client-side URL redirection.

Swift
"""""

*   False positive results from the :code:`swift/cleartext-transmission` ("Cleartext transmission of sensitive information") query involving :code:`tel:`, :code:`mailto:` and similar URLs have been fixed.

New Queries
~~~~~~~~~~~

Python
""""""

*   The :code:`py/cookie-injection` query, originally contributed to the experimental query pack by @jorgectf, has been promoted to the main query pack. This query finds instances of cookies being set without the :code:`Secure`, :code:`HttpOnly`, or :code:`SameSite` attributes set to secure values.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   Fixed an issue where :code:`io/ioutil.WriteFile`\ 's non-path arguments incorrectly generated :code:`go/path-injection` alerts when untrusted data was written to a file, or controlled the file's mode.

Java/Kotlin
"""""""""""

*   Fixed an issue where analysis in :code:`build-mode: none` may very occasionally throw a :code:`CoderMalfunctionError` while resolving dependencies provided by a build system (Maven or Gradle), which could cause some dependency resolution and consequently alerts to vary unpredictably from one run to another.
*   Fixed an issue where Java analysis in :code:`build-mode: none` would fail to resolve dependencies using the :code:`executable-war` Maven artifact type.
*   Fixed an issue where analysis in :code:`build-mode: none` may fail to resolve dependencies of Gradle projects where the dependency uses a non-empty artifact classifier -- for example, :code:`someproject-1.2.3-tests.jar`, which has the classifier :code:`tests`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added support for data flow through side-effects on static fields. For example, when a static field containing an array is updated.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added some new :code:`local` source models. Most prominently :code:`System.IO.Path.GetTempPath` and :code:`System.Environment.GetFolderPath`. This might produce more alerts, if the :code:`local` threat model is enabled.
*   The extractor has been changed to not skip source files that have already been seen. This has an impact on source files that are compiled multiple times in the build process. Source files with conditional compilation preprocessor directives (such as :code:`#if`) are now extracted for each set of preprocessor symbols that are used during the build process.

Java/Kotlin
"""""""""""

*   Threat-model for :code:`System.in` changed from :code:`commandargs` to newly created :code:`stdin` (both subgroups of :code:`local`).

Shared Libraries
----------------

Deprecated APIs
~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The source/sink grouping feature of the data flow library has been removed. It was introduced primarily for debugging, but has not proven useful.
