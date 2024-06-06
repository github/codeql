.. _codeql-cli-2.5.1:

=========================
CodeQL 2.5.1 (2021-04-19)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.1 runs a total of 239 security queries when configured with the Default suite (covering 108 CWE). The Extended suite enables an additional 79 queries (covering 26 more CWE).

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The QL compiler will now reject queries where the query metadata (if present) at the top of the :code:`.ql` file is inconsistent with the output format of the query.  This check can be disabled by giving the :code:`--no-metadata-verification` flag.  (The flag already existed but has not had any effect until now.)

Bug Fixes
~~~~~~~~~

*   Environment variables required for Java extraction are now propagated by the tracer. This may resolve issues with tracing and extraction in the context of certain build systems such as Bazel.
    
*   A number of :code:`--check-CONDITION` options to :code:`codeql database finalize` and :code:`codeql dataset import` designed to look for consistency errors in the intermediate "TRAP" output from extractors erroneously did nothing. They will now actually print warnings if errors are found.  The warnings become fatal errors if the new
    :code:`--fail-on-trap-errors` option is also given.

New Features
~~~~~~~~~~~~

*   :code:`codeql resolve qlref` is a new command that takes in a :code:`.qlref` file for a CodeQL test case and returns the path of the :code:`.ql` file it references.
    
*   :code:`codeql database analyze` and :code:`codeql database interpret-results` have a new :code:`--sarif-group-rules-by-pack` option which will place the SARIF rule object for each query underneath its corresponding query pack in :code:`runs[].tool.extensions`.
    
*   :code:`codeql database finalize` and :code:`codeql dataset import` have a new
    :code:`--fail-on-trap-errors` option that will make database creation fail if extractors produce ill-formatted "TRAP" data for inclusion into a database. This is not enabled by default because some of the existing extractors have minor output bugs that cause the check to fail.
    
*   :code:`codeql database finalize` and :code:`codeql dataset import` have a new
    :code:`--check-undefined-labels` option that enables stricter consistency checks on the "TRAP" output from extractors.

QL Language
~~~~~~~~~~~

*   :code:`super` may now be used unqualified, e.g. :code:`super.predicateName()`,
    when the declaring class has multiple super types, as long as the call itself is unambiguous.
