.. _codeql-cli-2.12.4:

==========================
CodeQL 2.12.4 (2023-03-09)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.12.4 runs a total of 385 security queries when configured with the Default suite (covering 154 CWE). The Extended suite enables an additional 122 queries (covering 31 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The default value of the :code:`--mode` switch to :code:`codeql pack install` has changed. The default is now :code:`--mode minimal-update`.
    Previously, it was :code:`use-lock`.

Deprecations
~~~~~~~~~~~~

*   The :code:`--freeze` switch for :code:`codeql pack create`, :code:`codeql pack bundle`, and :code:`codeql pack publish` is now deprecated and ignored, as there is no longer a cache within a pack.
*   The :code:`--mode update` switch to :code:`codeql pack resolve-dependencies` is now deprecated. Instead, use the new :code:`--mode upgrade` switch, which has identical behavior.
*   The :code:`--mode` switch to :code:`codeql pack install` is now deprecated.

    *   Instead of :code:`--mode update`, use :code:`codeql pack upgrade`.
    *   Instead of :code:`--mode verify`, use :code:`codeql pack ci`.

New Features
~~~~~~~~~~~~

*   The per-pack compilation cache has been replaced with a global compilation cache found within :code:`~/.codeql`.
*   :code:`codeql pack install` now uses a new algorithm to determine which versions of the pack's dependencies to use, based on the `PubGrub <https://nex3.medium.com/pubgrub-2fb6470504f>`__ algorithm. The new algorithm is able to find a solution for many cases that the previous algorithm would fail to solve. When the new algorithm is unable to find a valid solution, it generates a detailed error message explaining why there is no valid solution.
*   Added a new command, :code:`codeql pack upgrade`. This command is similar to :code:`codeql pack install`,
    except that it ignores any existing lock file, installs the latest compatible version of each dependency, and writes a new lock file. This is equivalent to :code:`codeql pack install --mode update`.
    Note that the :code:`--mode` switch to :code:`codeql pack install` is now deprecated.
*   Added a new command, :code:`codeql pack ci`. This command is similar to :code:`codeql pack install`,
    except if the existing lock file is missing, or if it conflicts with the version constraints in the :code:`qlpack.yml` file, the command generates an error. This is equivalent to
    :code:`codeql pack install --mode verify`. Note that the :code:`--mode` switch to :code:`codeql pack install` is now deprecated.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The query :code:`go/incorrect-integer-conversion` now correctly recognizes guards of the form :code:`if val <= x` to protect a conversion :code:`uintX(val)` when :code:`x` is in the range :code:`(math.MaxIntX, math.MaxUintX]`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/regex-injection` query now recognizes environment variables and command-line arguments as sources.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`CryptographicOperation` concept has been changed to use a range pattern. This is a breaking change and existing implementations of :code:`CryptographicOperation` will need to be updated in order to compile. These implementations can be updated by:

    #.  Extending :code:`CryptographicOperation::Range` rather than :code:`CryptographicOperation`
    #.  Renaming the :code:`getInput()` member predicate as :code:`getAnInput()`
    #.  Implementing the :code:`BlockMode getBlockMode()` member predicate. The implementation for this can be :code:`none()` if the operation is a hashing operation or an encryption operation using a stream cipher.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   We use a new analysis for the call-graph (determining which function is called). This can lead to changed results. In most cases this is much more accurate than the old call-graph that was based on points-to, but we do lose a few valid edges in the call-graph, especially around methods that are not defined inside its class.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The query :code:`cs/static-field-written-by-instance` is updated to handle properties.
*   C# 11: Support for explicit interface member implementation of operators.
*   The extraction of member modifiers has been generalized, which could lead to the extraction of more modifiers.
*   C# 11: Added extractor and library support for :code:`file` scoped types.
*   C# 11: Added extractor support for :code:`required` fields and properties.
*   C# 11: Added library support for :code:`checked` operators.

Java/Kotlin
"""""""""""

*   Added new sinks for :code:`java/hardcoded-credential-api-call` to identify the use of hardcoded secrets in the creation and verification of JWT tokens using :code:`com.auth0.jwt`. These sinks are from `an experimental query submitted by @luchua <https://github.com/github/codeql/pull/9036>`__.
*   The Java extractor now supports builds against JDK 20.
*   The query :code:`java/hardcoded-credential-api-call` now recognizes methods that accept user and password from the SQLServerDataSource class of the Microsoft JDBC Driver for SQL Server.

Python
""""""

*   Fixed module resolution so we properly recognize definitions made within if-then-else statements.
*   Added modeling of cryptographic operations in the :code:`hmac` library.

Ruby
""""

*   Flow is now tracked between ActionController :code:`before_filter` and :code:`after_filter` callbacks and their associated action methods.
*   Calls to :code:`ApplicationController#render` and :code:`ApplicationController::Renderer#render` are recognized as Rails rendering calls.
*   Support for `Twirp framework <https://twitchtv.github.io/twirp/docs/intro.html>`__.
