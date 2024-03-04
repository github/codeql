.. _codeql-cli-2.7.1:

=========================
CodeQL 2.7.1 (2021-11-15)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.7.1 runs a total of 276 security queries when configured with the Default suite (covering 120 CWE). The Extended suite enables an additional 82 queries (covering 31 more CWE). 10 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   Previously, :code:`codeql test run` would fall back to looking for an accompanying :code:`queries.xml` file if it found a :code:`qlpack.yml` that did not declare an extractor to use when extracting a test database.
    This has been removed because the internal use case that neccessitated the fallback are now removed. If you suddenly encounter errors that complain of missing extractor declarations,
    check whether you had a :code:`queries.xml` you were inadvertently relying on.
    
*   When queries are specified by naming a directory to scan for :code:`*.ql` files, subdirectories named :code:`.codeql` will now be ignored.  The new QL packaging support uses subdirectories with this name of various scratch and caching purposes, so they may contain :code:`*.ql` files that are not intended to be directly user-visible.
    
*   When copying dependencies for CodeQL packages into a query pack bundle, :code:`*.ql` files in these dependencies will now be included inside of the query pack's :code:`.codeql` directory.
    
*   The tables printed by :code:`codeql database analyze` to summarize the results of diagnostic and metric queries that were part of the analysis have a new format and contains less (but hopefully more pertinent) information. We recommend against attempting to parse this human-readable output programmatically. Instead, use the
    :code:`runs[].tool.driver.invocations[].toolExecutionNotifications` property in the SARIF output.
    
*   The experimental plumbing command :code:`codeql pack packlist` has a new format for its JSON results. Previously, the results were a list of paths. Now, the results are an object with a single property :code:`paths` that contains the list of paths.
    
*   The internal :code:`qlpacks` directory of the CodeQL bundle available on the
    \ `CodeQL Action releases page <https://github.com/github/codeql-action/releases/>`__ has a new structure. This directory is internal to the CLI and can change without notice in future releases.
    
    The currently-shipped :code:`qlpacks` directory mirrors the structure of `CodeQL package <https://github.blog/changelog/2021-07-28-introducing-the-codeql-package-manager-public-beta/>`__ caches and looks like this:

    ..  code-block:: text
    
        qlpacks
          - codeql
            - {lang}-all
              - {version}
                - qlpack contents
            - {lang}-examples
              - {version}
                - qlpack contents
            - {lang}-queries
              - {version}
                - qlpack contents
            - {lang}-upgrades
              - {version}
                - qlpack contents
            - ... and so on for all languages

Bug Fixes
~~~~~~~~~

*   Fixed a bug where the :code:`paths` and :code:`paths-ignore` properties of a Code Scanning config file specified using :code:`--codescanning-config` were being interpreted the wrong way around.
    
*   Fixed a bug where queries specified using the
    :code:`--codescanning-config` option could not be run after an explicit call to :code:`codeql database finalize`.
    
*   Fixed a bug where :code:`-J` options would erroneously be recognized even after :code:`--` on the command line.
    
*   When running :code:`codeql database analyze` and :code:`codeql database interpret-results` without the :code:`--sarif-group-rules-by-pack` flag,
    the SARIF output did not include baseline lines-of-code counts. This is now fixed.
    
*   Fixed a bug where expansion of query suites would sometimes fail if a query suite in a compiled query pack referenced that pack itself explicitly.

Deprecations
~~~~~~~~~~~~

*   The output formats SARIF v1.0.0 and SARIF v2.0.0 (Committee Specification Draft 1) have been deprecated.  They will be removed in a later version (earliest 2.8.0).  If you need this functionality, please file a public issue against https://github.com/github/codeql-cli-binaries, or open a private ticket with GitHub Support and request an escalation to engineering.
    
*   The :code:`qlpack:` instruction in query suite definitions has been deprecated due to uncertainty about whether it is intended to include *all* the :code:`*.ql` files in the named pack, or only the pack's
    "default query suite".  The behavior of the instruction is determined by whether the named pack declares any default query suite, but this means that a pack *starting* to declare such a suite may break the behavior of existing query suites that reference the pack from outside.
    
    We recommend replacing :code:`qlpack:` by one of

    ..  code-block:: yaml
    
        - queries: '.' # import all *.ql files
          from: some/pack-name
          version: 1.2.3 # optional
        
    or

    ..  code-block:: yaml
    
        - import: path/to/actual/suite.ql # just that suite
          from: some/pack-name
          version: 1.2.3 # optional
        
    A warning will now be printed when a :code:`qlpack:` instruction resolves to a default suite, because that is the case where the effect may not be what the query suite author intended.

New Features
~~~~~~~~~~~~

*   Beta support for database creation on Apple Silicon has been added.
    It depends on the following requirements:

    *   \ `Rosetta 2 <https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment>`__ needs to be installed
        
    *   Developer tools need to be installed. CodeQL requires the :code:`lipo`,
        :code:`codesign`, and :code:`install_name_tool` tools to be present.
        
    *   Build systems invoking :code:`csh` may experience `intermittent crashes <https://openradar.appspot.com/radar?id=4936797431791616>`__.

*   :code:`codeql database analyze` can now include query-specific help texts for alerts in the SARIF output (for SARIF v2.1.0 or later). The help text must be located in an :code:`.md` file next to (and with the same basename as) the :code:`.ql` file for each query. Since this can significantly increase SARIF file size, the feature is not enabled by default; give a :code:`--sarif-add-query-help` option to enable it.
    
*   The query metadata validator now knows about queries that produce alert scores, so these queries no longer need to be run with a
    :code:`--no-metadata-verification` flag.
    
*   :code:`codeql database create` and :code:`codeql-finalize` have a new flag
    :code:`--skip-empty` that will cause a language with no extracted source code to be ignored with a warning instead of treated like a fatal error. This can be useful with :code:`--db-cluster` where not all of the languages may exist in the source tree.  It will not be possible to run queries against the skipped database.
    
*   :code:`codeql resolve extractor` and :code:`codeql resolve languages` now support an extended output format :code:`--format=betterjson` wich includes information about each extractor's language-specific options.
    
*   This release introduces rudimentary support for parallelizing database creation by importing unfinished databases (or database clusters) into another unfinished database (or cluster) under creation. This is implemented by the new flag :code:`--additional-dbs` for
    :code:`codeql database finalize`, or the new plumbing command :code:`codeql database import`.
    
*   :code:`codeql database create`, :code:`codeql database index-files`, and :code:`codeql database trace-command` support a `unified syntax for passing language-specific options <https://codeql.github.com/docs/codeql-cli/extractor-options>`__ to the extractor with the new
    :code:`--extractor-option` and :code:`--extractor-options-file` options.
    (The extractors do not make use of this yet, though).

QL Language
~~~~~~~~~~~

*   \ `Set literal expressions <https://codeql.github.com/docs/ql-language-reference/expressions/#set-literal-expressions>`__ can now optionally contain a trailing comma after the last element.
    
