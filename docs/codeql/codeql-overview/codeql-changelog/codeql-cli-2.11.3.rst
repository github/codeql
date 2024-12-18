.. _codeql-cli-2.11.3:

==========================
CodeQL 2.11.3 (2022-11-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.3 runs a total of 358 security queries when configured with the Default suite (covering 150 CWE). The Extended suite enables an additional 111 queries (covering 31 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The :code:`codeql pack ls --format json` deep plumbing command now returns only the :code:`name` and :code:`version` properties for each found pack.

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   :code:`codeql pack download`, :code:`codeql pack install`, and :code:`codeql pack add` will ignore CodeQL packs with pre-release versions, unless the
    :code:`--allow-prerelease` option is passed to the command. This brings these commands into alignment with :code:`codeql pack publish` that will avoid publishing CodeQL packs with pre-release versions unless the
    :code:`--allow-prerelease` option is specified. Pre-release versions have the following format: :code:`X.Y.Z-qualifier` where :code:`X`, :code:`Y`, and :code:`Z` are respectively the major, minor, and patch number. :code:`qualifier` is the pre-release version. For more information about pre-releases, see the
    \ `Semantic Versioning specification <https://semver.org/#spec-item-9>`__.

Deprecations
~~~~~~~~~~~~

*   The :code:`--[no-]fast-compilation` option to :code:`codeql query compile` is now deprecated.

New Features
~~~~~~~~~~~~

*   :code:`codeql resolve files` and :code:`codeql database index-files` have a new
    :code:`--find-any` option, which finds at most one match.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Apache Commons Text that is bundled with the CodeQL CLI has been updated to version 1.10.0. While previous releases shipped with version 1.6 of the library, no part of the CodeQL CLI references the :code:`StringSubstitutor` class that the recently disclosed
    \ `CVE-2022-42889 <https://github.com/advisories/GHSA-599f-7c49-w659>`__ vulnerability applies to. We therefore do not believe that running previous releases of CodeQL exposes users to this vulnerability.
*   The build of Eclipse Temurin OpenJDK that is bundled with the CodeQL CLI has been updated to version 17.0.5.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fixed a bug in :code:`cpp/jsf/av-rule-76` that caused the query to miss results when an implicitly-defined copy constructor or copy assignment operator was generated.

Golang
""""""

*   Query :code:`go/clear-text-logging` now excludes :code:`GetX` methods of protobuf :code:`Message` structs, except where taint is specifically known to belong to the right field. This is to avoid FPs where taint is written to one field and then spuriously read from another.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added sources for user defined path and query parameters in :code:`Next.js`.
*   The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

Ruby
""""

*   The :code:`rb/weak-cryptographic-algorithm` has been updated to no longer report uses of hash functions such as :code:`MD5` and :code:`SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice.

New Queries
~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added a new query, :code:`js/second-order-command-line-injection`, to detect shell commands that may execute arbitrary code when the user has control over
    the arguments to a command-line program.
    This currently flags up unsafe invocations of git and hg.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fixed bugs in the :code:`FormatLiteral` class that were causing :code:`getMaxConvertedLength` and related predicates to return no results when the format literal was :code:`%e`, :code:`%f` or :code:`%g` and an explicit precision was specified.

Ruby
""""

*   There was a bug in :code:`TaintTracking::localTaint` and :code:`TaintTracking::localTaintStep` such that they only tracked non-value-preserving flow steps. They have been fixed and now also include value-preserving steps.
*   Instantiations using :code:`Faraday::Connection.new` are now recognized as part of :code:`FaradayHttpRequest`\ s, meaning they will be considered as sinks for queries such as :code:`rb/request-forgery`.
*   Taint flow is now tracked through extension methods on :code:`Hash`, :code:`String` and
    :code:`Object` provided by :code:`ActiveSupport`.
