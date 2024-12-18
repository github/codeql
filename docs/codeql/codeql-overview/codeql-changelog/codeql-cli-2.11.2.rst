.. _codeql-cli-2.11.2:

==========================
CodeQL 2.11.2 (2022-10-25)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.2 runs a total of 357 security queries when configured with the Default suite (covering 150 CWE). The Extended suite enables an additional 111 queries (covering 31 more CWE). 5 security queries have been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   Bundling and publishing a CodeQL pack will no longer include nested CodeQL packs. If you want to include a nested pack in your published pack,
    then you must explicitly include it using the :code:`include` property in the top-level :code:`qlpack.yml` file.
    
    For example, if your package structure looks like this:

    ..  code-block:: text
    
        qlpack.yml
        nested-pack
           ∟ qlpack.yml
             query.ql
        
    then the contents of :code:`nested-pack` will not be included by default within the published package. To include :code:`nested-pack`, add an entry like this to the top level :code:`qlpack.yml` file:

    ..  code-block:: yaml
    
        include:
          - nested-pack/**

Bug Fixes
~~~~~~~~~

*   Using the :code:`--codescanning-config=<file>` option in
    :code:`codeql database init` will now correctly process the :code:`paths` and
    :code:`pathsIgnore` properties of the configuration file in a way that is identical to the behavior of the :code:`codeql-action`. Previously, :code:`paths` or :code:`pathsIgnore` entries that end in :code:`/**` or start with :code:`/`  were incorrectly rejected by the CLI.
    
*   Fixed a bug where the :code:`--compilation-cache` option to
    :code:`codeql pack publish` and :code:`codeql pack create` was being ignored when creating a query pack.  Now, the indicated cache is used when pre-compiling the queries in it.
    
*   Fixed a bug that would make the "Show DIL" command in the VSCode extension display nothing.

Miscellaneous
~~~~~~~~~~~~~

*   Emit a detailed warning if package resolution fails, the legacy
    :code:`--search-path` option is provided, *and* there is at least one referenced pack that does not use legacy package resolution.
    In this case, :code:`--additional-packs` should be used to extend the search to additional directories, instead of :code:`--search-path`.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed how :code:`flask.request` is modeled as a RemoteFlowSource, such that we show fewer duplicated alert messages for Code Scanning alerts. The import, such as :code:`from flask import request`, will now be shown as the first step in a path explanation.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Unterminated variadic call" (:code:`cpp/unterminated-variadic-call`) query has been tuned to produce fewer false positive results.
*   Fixed false positives from the "Unused static function" (:code:`cpp/unused-static-function`) query in files that had errors during compilation.

Golang
""""""

*   The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

JavaScript/TypeScript
"""""""""""""""""""""

*   Removed some false positives from the :code:`js/file-system-race` query by requiring that the file-check dominates the file-access.
*   Improved taint tracking through :code:`JSON.stringify` in cases where a tainted value is stored somewhere in the input object.

Python
""""""

*   Added model of :code:`cx_Oracle`, :code:`oracledb`, :code:`phonenixdb` and :code:`pyodbc` PyPI packages as a SQL interface following PEP249, resulting in additional sinks for :code:`py/sql-injection`.
*   Added model of :code:`executemany` calls on PEP-249 compliant database APIs, resulting in additional sinks for :code:`py/sql-injection`.
*   Added model of :code:`pymssql` PyPI package as a SQL interface following PEP249, resulting in additional sinks for :code:`py/sql-injection`.
*   The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

Ruby
""""

*   HTTP response header and body writes via :code:`ActionDispatch::Response` are now recognized.
*   The :code:`rb/path-injection` query now treats the :code:`file:` argument of the Rails :code:`render` method as a sink.
*   The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new medium-precision query, :code:`cpp/comma-before-misleading-indentation`, which detects instances of whitespace that have readability issues.

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/android/incomplete-provider-permissions`, to detect if an Android ContentProvider is not protected with a correct set of permissions.
*   A new query "Uncontrolled data used in content resolution" (:code:`java/androd/unsafe-content-uri-resolution`) has been added. This query finds paths from user-provided data to URI resolution operations in Android's :code:`ContentResolver` without previous validation or sanitization.

Ruby
""""

*   Added a new query, :code:`rb/non-constant-kernel-open`, to detect uses of Kernel.open and related methods with non-constant values.
*   Added a new query, :code:`rb/sensitive-get-query`, to detect cases where sensitive data is read from the query parameters of an HTTP :code:`GET` request.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added support for common patterns involving :code:`Stream.collect` and common collectors like :code:`Collectors.toList()`.
*   The class :code:`TypeVariable` now also extends :code:`Modifiable`.
*   Added data flow steps for tainted Android intents that are sent to services and receivers.
*   Improved the data flow step for tainted Android intents that are sent to activities so that more cases are covered.

Python
""""""

*   Fixed labels in the API graph pertaining to definitions of subscripts. Previously, these were found by :code:`getMember` rather than :code:`getASubscript`.
*   Added edges for indices of subscripts to the API graph. Now a subscripted API node will have an edge to the API node for the index expression. So if :code:`foo` is matched by API node :code:`A`, then :code:`"key"` in :code:`foo["key"]` will be matched by the API node :code:`A.getIndex()`. This can be used to track the origin of the index.
*   Added member predicate :code:`getSubscriptAt(API::Node index)` to :code:`API::Node`. Like :code:`getASubscript()`, this will return an API node that matches a subscript of the node, but here it will be restricted to subscripts where the index matches the :code:`index` parameter.
*   Added convenience predicate :code:`getSubscript("key")` to obtain a subscript at a specific index, when the index happens to be a statically known string.

Ruby
""""

*   The hashing algorithms from :code:`Digest` and :code:`OpenSSL::Digest` are now recognized and can be flagged by the :code:`rb/weak-cryptographic-algorithm` query.
*   More sources of remote input arising from methods on :code:`ActionDispatch::Request` are now recognized.
*   The response value returned by the :code:`Faraday#run_request` method is now also considered a source of remote input.
*   :code:`ActiveJob::Serializers.deserialize` is considered to be a code execution sink.
*   Calls to :code:`params` in :code:`ActionMailer` classes are now treated as sources of remote user input.
*   Taint flow through :code:`ActionController::Parameters` is tracked more accurately.

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Deprecated :code:`ContextStartActivityMethod`. Use :code:`StartActivityMethod` instead.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new predicate, :code:`hasIncompletePermissions`, in the :code:`AndroidProviderXmlElement` class. This predicate detects if a provider element does not provide both read and write permissions.
