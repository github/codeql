.. _codeql-cli-2.11.1:

==========================
CodeQL 2.11.1 (2022-10-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.11.1 runs a total of 354 security queries when configured with the Default suite (covering 148 CWE). The Extended suite enables an additional 109 queries (covering 30 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   Pack installation using the CodeQL Packaging beta will now fail if a compatible version cannot be found. This replaces the previous behavior where :code:`codeql pack download` and related commands would instead install the latest version of the pack in this situation.

Bug Fixes
~~~~~~~~~

*   It is no longer an error to call :code:`codeql pack create <path>` with a :code:`<path>` option pointing to a file name. The CLI will walk up the directory tree and run the command in the first directory containing the :code:`qlpack.yml` or :code:`codeql-pack.yml` file.
*   Fixed a concurrency error observed when using :code:`codeql database import` or
    :code:`codeql database finalize` with multiple threads and multiple additional databases on a C++ codebase.

Deprecations
~~~~~~~~~~~~

*   The :code:`--[no-]count-lines` option to :code:`codeql database create` and related commands is now deprecated and will be removed in a future release of the CodeQL CLI (earliest 2.12.0). It is replaced by
    :code:`--[no-]calculate-baseline` to reflect the additional baseline information that is now captured as of this release.

New Features
~~~~~~~~~~~~

*   Subcommands that compile QL accept a new :code:`--no-release-compatibility` option. It does nothing for now, but in the future it will be used to control a trade-off between query performance and compatibility with older/newer releases of the QL evaluator.
*   :code:`codeql database analyze` and related commands now support absolute paths containing the :code:`@` or :code:`:` characters when specifying which queries to run. To reference a query file, directory, or suite whose path contains a literal :code:`@` or :code:`:`, prefix the query specifier with :code:`path:`, for example:

    ..  code-block:: shell
    
            codeql database analyze --format=sarif-latest --output=results <db> path:C:/Users/ci/workspace@2/security/query.ql

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

C#
""

*   The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

Java/Kotlin
"""""""""""

*   The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.
*   :code:`PathSanitizer.qll` has been promoted from experimental to the main query pack. This sanitizer was originally `submitted as part of an experimental query by @luchua-bc <https://github.com/github/codeql/pull/7286>`__.
*   The queries :code:`java/path-injection`, :code:`java/path-injection-local` and :code:`java/zipslip` now use the sanitizers provided by :code:`PathSanitizer.qll`.

Ruby
""""

*   The :code:`rb/xxe` query has been updated to add the following sinks for XML external entity expansion:

    #.  Calls to parse XML using :code:`LibXML` when its :code:`default_substitute_entities` option is enabled.
    #.  Uses of the Rails methods :code:`ActiveSupport::XmlMini.parse`, :code:`Hash.from_xml`, and :code:`Hash.from_trusted_xml` when :code:`ActiveSupport::XmlMini` is configured to use :code:`LibXML` as its backend, and its :code:`default_substitute_entities` option is enabled.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Added a new query, :code:`java/android/webview-debugging-enabled`, to detect instances of WebView debugging being enabled in production builds.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   :code:`DateTime` expressions are now considered simple type sanitizers. This affects a wide range of security queries.
*   ASP.NET Core controller definition has been made more precise. The amount of introduced taint sources or eliminated false positives should be low though, since the most common pattern is to derive all user defined ASP.NET Core controllers from the standard Controller class, which is not affected.

Golang
""""""

*   Added support for :code:`BeegoInput.RequestBody` as a source of untrusted data.

Java/Kotlin
"""""""""""

*   Added external flow sources for the intents received in exported Android services.

JavaScript/TypeScript
"""""""""""""""""""""

*   Several of the SQL and NoSQL library models have improved, leading to more results for the :code:`js/sql-injection` query,
    and in some cases the :code:`js/missing-rate-limiting` query.

Python
""""""

*   Added the ability to refer to subscript operations in the API graph. It is now possible to write :code:`response().getMember("cookies").getASubscript()` to find code like :code:`resp.cookies["key"]` (assuming :code:`response` returns an API node for response objects).
*   Added modeling of creating Flask responses with :code:`flask.jsonify`.

Ruby
""""

*   The following classes have been moved from :code:`codeql.ruby.frameworks.ActionController` to :code:`codeql.ruby.frameworks.Rails`\ :

    *   :code:`ParamsCall`, now accessed as :code:`Rails::ParamsCall`.
    *   :code:`CookieCall`, now accessed as :code:`Rails::CookieCall`.
    
*   The following classes have been moved from :code:`codeql.ruby.frameworks.ActionView` to :code:`codeql.ruby.frameworks.Rails`\ :

    *   :code:`HtmlSafeCall`, now accessed as :code:`Rails::HtmlSafeCall`.
    *   :code:`HtmlEscapeCall`, now accessed as :code:`Rails::HtmlEscapeCall`.
    *   :code:`RenderCall`, now accessed as :code:`Rails::RenderCall`.
    *   :code:`RenderToCall`, now accessed as :code:`Rails::RenderToCall`.
    
*   Subclasses of :code:`ActionController::Metal` are now recognised as controllers.
*   :code:`ActionController::DataStreaming::send_file` is now recognized as a
    :code:`FileSystemAccess`.
*   Various XSS sinks in the ActionView library are now recognized.
*   Calls to :code:`ActiveRecord::Base.create` are now recognized as model instantiations.
*   Various code executions, command executions and HTTP requests in the ActiveStorage library are now recognized.
*   :code:`MethodBase` now has two new predicates related to visibility: :code:`isPublic` and
    :code:`isProtected`. These hold, respectively, if the method is public or protected.
