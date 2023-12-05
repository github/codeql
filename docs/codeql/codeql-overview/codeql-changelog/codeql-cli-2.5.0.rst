.. _codeql-cli-2.5.0:

=========================
CodeQL 2.5.0 (2021-03-26)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.0 runs a total of 239 security queries when configured with the Default suite (covering 108 CWE). The Extended suite enables an additional 79 queries (covering 26 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   By default, :code:`codeql test` now performs additional compiler checks when extracting test code written in Java.
    Existing Java tests that previously passed may therefore fail due to this change, if they do not compile using the :code:`javac` compiler.
    To allow time to migrate existing tests, the new behavior can be disabled by setting the environment variable
    :code:`CODEQL_EXTRACTOR_JAVA_FLOW_CHECKS=false`.

New Features
~~~~~~~~~~~~

*   Log files that contain output from build processes will now prefix it with :code:`[build-stdout]` and :code:`[build-stderr]` instead of :code:`[build]` and :code:`[build-err]`.  In particular the latter sometimes caused confusion.

QL Language
~~~~~~~~~~~

*   The QL language now recognizes new :code:`pragma[only_bind_into](...)` and
    :code:`pragma[only_bind_out](...)` annotations on expressions. Advanced users may use these annotations to provide hints to the compiler to influence binding behavior and thus indirectly performance.
