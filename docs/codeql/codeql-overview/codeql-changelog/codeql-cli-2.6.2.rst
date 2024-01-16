.. _codeql-cli-2.6.2:

=========================
CodeQL 2.6.2 (2021-09-21)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.6.2 runs a total of 274 security queries when configured with the Default suite (covering 120 CWE). The Extended suite enables an additional 81 queries (covering 28 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   A bug where :code:`codeql generate log-summary` would sometimes crash with a :code:`JsonMappingException` has been fixed.

Documentation
~~~~~~~~~~~~~

*   Documentation has been added detailing how to use the "indirect build tracing" feature, which is enabled by using the
    :code:`--begin-tracing` flag provided by :code:`codeql database init`. The new documentation can be found `here <https://aka.ms/codeql-docs/indirect-tracing>`__. This feature was temporarily described as "sandwiched tracing" in the 2.6.0 release notes.

New Features
~~~~~~~~~~~~

*   The CodeQL CLI now counts the lines of code found under
    :code:`--source-root` when :code:`codeql database init` or :code:`codeql database create` is called. This information can be viewed later by either the new :code:`codeql database print-baseline` command or the new
    :code:`--print-baseline-loc` argument to :code:`codeql database interpret-results`.
    
*   :code:`qlpack.yml` files now support an additional field :code:`include` in which glob patterns of additional files that should be included (or excluded) when creating a given CodeQL pack can be specified.
    
*   QL packs created by the experimental :code:`codeql pack create` command will now include some information about the build in a new
    :code:`buildMetadata` field of their :code:`qlpack.yml` file.
    
*   :code:`codeql database create` now supports the same flags as :code:`codeql database init` for automatically recognizing the languages present in checkouts of GitHub repositories:

    *   :code:`--github-url` accepts the URL of a custom GitHub instance
        (previously only :code:`github.com` was supported).
        
    *   :code:`--github-auth-stdin` allows a personal access token to be provided through standard input (previously only the
        :code:`GITHUB_TOKEN` environment variable was supported).

