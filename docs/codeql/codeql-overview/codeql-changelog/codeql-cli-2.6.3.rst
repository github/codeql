.. _codeql-cli-2.6.3:

=========================
CodeQL 2.6.3 (2021-10-06)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.6.3 runs a total of 274 security queries when configured with the Default suite (covering 120 CWE). The Extended suite enables an additional 81 queries (covering 28 more CWE).

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The option :code:`--compiler-spec` accepted by some subcommands of :code:`codeql database` is deprecated.  It will be removed in a later version
    (earliest 2.7.0).  If you need this option, please file a public issue in https://github.com/github/codeql-cli-binaries, or open a private ticket with GitHub support and request an escalation to engineering.
    
*   By default, databases created using the CodeQL CLI will now have their underlying datasets finalized, meaning that no further data can be subsequently imported into them. This change should not affect most users.
    
*   The :code:`codeql resolve qlref` command will now throw an error when the target is ambiguous.  The qlref resolution rules are now as follows:

    #.  If the target of a qlref is in the same qlpack, then that target is always returned.
        
    #.  If multiple targets of the qlref are found in dependent packs,
        this is an error.

    Previously, the command would have arbitrarily chosen one of the targets and ignored any ambiguities.

Bug Fixes
~~~~~~~~~

*   Linux/MacOS: When tracing a build that involves an
    :code:`execvp`\ /\ :code:`execvpe` (Linux-only)/\ :code:`posix_spawnp` syscall where :code:`PATH` was not set in the environment, CodeQL sometimes would break the build.  Now, CodeQL uses the correct, platform-specific fallback for
    :code:`PATH` instead.
    
*   Linux/MacOS: When tracing a build that involves an :code:`execvpe` (Linux-only)/\ :code:`posix_spawnp` syscall, the :code:`PATH` lookup of the executable wrongly took place in the environment provided via
    :code:`envp`, instead of the environment of the process calling
    :code:`execvpe`\ /\ :code:`posix_spawnp`.  Now, the correct environment is used for the :code:`PATH` lookup.
    
*   A bug where query compilation would sometimes fail with a
    :code:`StackOverflowError` when compiling a query that uses :code:`instanceof` has now been fixed.

New Features
~~~~~~~~~~~~

*   The :code:`codeql query compile` command now accepts a :code:`--keep-going` or
    :code:`-k` option, which indicates that the compiler should continue compiling queries even if one of the queries has a compile error in it.
    
*   CLI commands now run default queries if none are specified. If no queries are specified, the :code:`codeql database analyze`, :code:`codeql database run-queries`, and :code:`codeql database interpret-results` commands will now run the default suite for the language being analyzed.
    
*   :code:`codeql pack publish` now copies the published package to the local package cache. In addition to publishing to a remote repository, the
    :code:`codeql pack publish` command will also copy the published package to the local package cache.
    
