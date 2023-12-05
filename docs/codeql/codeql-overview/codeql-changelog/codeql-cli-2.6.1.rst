.. _codeql-cli-2.6.1:

=========================
CodeQL 2.6.1 (2021-09-07)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.6.1 runs a total of 274 security queries when configured with the Default suite (covering 119 CWE). The Extended suite enables an additional 80 queries (covering 27 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The :code:`codeql resolve qlref` command will now throw an error when the target is ambiguous.
    
    The qlref resolution rules are now as follows:

    #.  If the target of a qlref is in the same qlpack, then that target is always returned.
        
    #.  If multiple targets of the qlref are found in dependent packs, this is an error.

    Previously, the command would have arbitrarily chosen one of the targets and ignored any ambiguities.
    
*   The :code:`qlpack` directive in query suites has its semantics changed.
    Previously, this directive would return all queries in the qlpack. Now, the directive returns only those queries matched by the
    :code:`defaultSuite` directive in the query pack. Here is an example:
    
    Consider a :code:`qlpack.yml` like the following:

    ..  code-block:: yaml
    
        name: codeql/my-qlpack
        version: 0.0.1
        defaultSuite:
          queries: standard
        
    And the directory structure is the following:

    ..  code-block:: text
    
        qlpack.yml
        standard/
          a.ql
        experimental/
          b.ql
        
    A query suite :code:`suite.qls` like this:

    ..  code-block:: yaml
    
        - qlpack: codeql/my-qlpack
        
    Previously, would return all the queries in all subdirectories (i.e,
    :code:`standard/a.ql` and :code:`experimental/b.ql`). Now, it only returns
    :code:`standard/a.ql`, since that is the only query matched by its default suite.
    
    If you want to have the same behavior as before, you must update your query suites to use the :code:`queries` directive with a :code:`from` attribute,
    like this:

    ..  code-block:: yaml
    
        - queries: .
          from: codeql/my-qlpack

New Features
~~~~~~~~~~~~

*   Commands that evaluate CodeQL queries now support an additional option :code:`--evaluator-log=path/to/log.json` that will result in the evaluator producing a structured log (in JSON format) of events that occurred during evaluation in order to aid debugging of query performance. The format of these logs will be subject to change with no notice as we make modifications to the evaluator.
    
    There is also a new CLI command :code:`codeql generate log-summary` that will produce a summary of the predicates that were evaluated from these event logs. We will aim to keep this summary format more stable, although it is also subject to change. Unless you have a good reason to use the event logs directly, it is strongly recommended you use this command to produce summary logs and use these instead.
    
    For further information on these new logs and additional options to configure their format and verbosity, please refer to the CLI documentation.

QL Language
~~~~~~~~~~~

*   QL classes can now be non-extending subtypes via the :code:`instanceof` keyword, allowing for a form of private subtyping that is not visible externally. Methods of the supertype are accessible from within a non-extending subtype class through extended semantics of the :code:`super` keyword.

    ..  code-block:: text
    
        class Foo instanceof int {
          Foo() { this in [1 .. 10] }
          string toString() { result = "foo" + super.toString() }
        }
        
