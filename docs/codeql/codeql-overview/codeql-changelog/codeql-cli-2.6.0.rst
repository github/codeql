.. _codeql-cli-2.6.0:

=========================
CodeQL 2.6.0 (2021-08-24)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.6.0 runs a total of 275 security queries when configured with the Default suite (covering 119 CWE). The Extended suite enables an additional 78 queries (covering 27 more CWE). 6 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   The :code:`physicalLocation.artifactLocation.uri` fields in SARIF output are now properly encoded as specified by RFC 3986.
    
*   The :code:`--include-extension` option to the :code:`codeql database index-files` command no longer includes directories that are named with the provided extension. For example, if the option
    :code:`--include-extension=.rb` is provided, then a directory named
    :code:`foo.rb/` will be excluded from the indexing.

New Features
~~~~~~~~~~~~

*   A new :code:`codeql database unbundle` subcommand performs the reverse of
    :code:`codeql database bundle` and extracts a CodeQL database from an archive.
    
*   The CLI now understands per-codebase configuration files in `the format already supported by the CodeQL Action <https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#example-configuration-files>`__.  The configuration file must be given in a :code:`--codescanning-config` option to :code:`codeql database create` or :code:`codeql database init`. For some languages, this configuration can contain pathname filters that control which parts of the codebase is analysed; the configuration file is the only way this functionality is exposed. The configuration file can also control which queries are run, including custom queries from repositories that must first be downloaded. To actually use those queries, run :code:`codeql database analyze` without any query-selection arguments.
    
*   The CLI now supports the "sandwiched tracing" feature that has previously only been offered through the separate CodeQL Runner.
    This feature is intended for use with CI systems that cannot be configured to wrap build actions with :code:`codeql database trace-command`. Instead the CI system must be able to set custom environment variables for each build action; the required environment variables are output by :code:`codeql database init` when given a :code:`--begin-tracing` argument.
    
    On Windows, :code:`codeql database init --begin-tracing` will also inject build-tracing code into the calling process or an ancestor; there are additional options to control this.
    
*   This version contains *beta* support for a new packaging and publishing system for third-party QL queries and libraries. It comprises the following new commands:

    *   :code:`codeql pack init`\ : Creates an empty CodeQL pack from a template.
        
    *   :code:`codeql pack add`\ : Adds a dependency to a CodeQL pack.
        
    *   :code:`codeql pack install`\ : Installs all pack dependencies specified in the :code:`qlpack.yml` file.
        
    *   :code:`codeql pack download`\ : Downloads one or more pack dependencies into the global package cache.
        
    *   :code:`codeql pack publish`\ : Publishes a package to the GitHub Container Registry.
        
    *   (Plumbing) :code:`codeql pack bundle`\ : Builds a :code:`.zip` file for a CodeQL query or library pack from sources. Used by :code:`codeql pack publish`.
        
    *   (Plumbing) :code:`codeql pack create`\ : Creates a compiled CodeQL query or library pack from sources. Used by :code:`codeql pack bundle`.
        
    *   (Plumbing) :code:`codeql pack packlist`\ : Lists all files in a local CodeQL pack that will be included in the pack's bundle. Used by
        :code:`codeql pack create`.
        
    *   (Plumbing) :code:`codeql pack resolve-dependencies`\ : Resolves all transitive dependencies of a local CodeQL pack. Used by :code:`codeql pack install`.

