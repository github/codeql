.. _codeql-cli-2.7.2:

=========================
CodeQL 2.7.2 (2021-11-22)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.7.2 runs a total of 278 security queries when configured with the Default suite (covering 124 CWE). The Extended suite enables an additional 85 queries (covering 31 more CWE). 5 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The Java extractor now defaults to extracting all XML documents under 10MB in size, a change from the previous default of only extracting documents with particular well-known names (e.g. :code:`pom.xml`). However,
    if the source tree contains more than 50MB of XML in total, it prints a warning and falls back to the old default behaviour.
    Set the environment variable :code:`LGTM_INDEX_XML_MODE` to :code:`byname` to get the old default behaviour, or :code:`all` to extract all documents under 10MB regardless of total size.
    
*   The experimental command-line option :code:`--native-library-path` that was introduced to support internal experiments has been removed.
    
*   The beta :code:`codeql pack publish` command will now prevent accidental publishing of packages with pre-release version qualifiers. Prerelease versions are those that include a :code:`-` after the major, minor, and patch versions such as :code:`1.2.3-dev`. To avoid this change, use the
    :code:`--allow-prerelease` option.

Bug Fixes
~~~~~~~~~

*   Fixed an issue when using the :code:`--evaluator-log` option where a
    :code:`NullPointerException` could sometimes occur non-deterministically.
    
*   Fixed bugs observed when using indirect build tracing using a CodeQL distribution unpacked to a path containing spaces or on Arch Linux.

New Features
~~~~~~~~~~~~

*   CodeQL databases now contain metadata about how and when they were created. This can be found in the :code:`creationMetadata` field of the
    :code:`codeql-database.yml` file within the CodeQL database directory. More information may be added to this field in future releases.
