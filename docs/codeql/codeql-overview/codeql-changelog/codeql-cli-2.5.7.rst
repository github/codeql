.. _codeql-cli-2.5.7:

=========================
CodeQL 2.5.7 (2021-07-02)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.7 runs a total of 268 security queries when configured with the Default suite (covering 114 CWE). The Extended suite enables an additional 56 queries (covering 28 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   :code:`codeql database create` and :code:`codeql database init` can now automatically recognise the languages present in checkouts of GitHub repositories by making an API call to the GitHub server. This requires a PAT token to either be set in the :code:`GITHUB_TOKEN` environment variable, or passed by stdin with the
    :code:`--github-auth-stdin` argument.
    
*   Operations that make outgoing HTTP calls (that is, :code:`codeql github upload-results` and the language-detection feature described above)
    now support the use of HTTP proxies. To use a proxy, specify an
    :code:`$https_proxy` environment variable for HTTPS requests or a
    :code:`$http_proxy` environment variable for HTTP requests. If the
    :code:`$no_proxy` variable is also set, these variables will be ignored and requests will be made without a proxy.

QL Language
~~~~~~~~~~~

*   The QL language now has a new method :code:`toUnicode` on the :code:`int` type. This method converts Unicode codepoint to a one-character string.  For example, :code:`65.toUnicode() = "A"`, :code:`128512.toUnicode()` results in a smiley, and :code:`any(int i | i.toUnicode() = "A") = 65`.
