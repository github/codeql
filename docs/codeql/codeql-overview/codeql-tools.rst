:tocdepth: 1

.. _codeql-tools:

CodeQL tools
============

GitHub provides the CodeQL command-line interface and CodeQL for Visual Studio Code for performing CodeQL analysis on open source codebases. For information on the use cases for each tool, see ":ref:`Running CodeQL queries <running-codeql-queries>`."

CodeQL command-line interface
-----------------------------

The CodeQL command-line interface (CLI) is primarily used to create databases for
security research. You can also query CodeQL databases directly from the command line
or using the Visual Studio Code extension.
The CodeQL CLI can be downloaded from "`GitHub releases <https://github.com/github/codeql-cli-binaries/releases>`__."
For more information, see "`CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli>`__" and the ":ref:`Change log <codeql-changes>`."

CodeQL packs
-----------------------------

The standard CodeQL query and library packs
(`source <https://github.com/github/codeql/tree/codeql-cli/latest>`__)
maintained by GitHub are:

- ``codeql/cpp-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/cpp/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/cpp/ql/src>`__)
- ``codeql/cpp-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/cpp/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/cpp/ql/lib>`__)
- ``codeql/csharp-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/csharp/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/csharp/ql/src>`__)
- ``codeql/csharp-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/csharp/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/csharp/ql/lib>`__)
- ``codeql/go-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/go/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/go/ql/src>`__)
- ``codeql/go-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/go/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/go/ql/lib>`__)
- ``codeql/java-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/java/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/java/ql/src>`__)
- ``codeql/java-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/java/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/java/ql/lib>`__)
- ``codeql/javascript-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/javascript/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/javascript/ql/src>`__)
- ``codeql/javascript-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/javascript/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/javascript/ql/lib>`__)
- ``codeql/python-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/python/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/python/ql/src>`__)
- ``codeql/python-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/python/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/python/ql/lib>`__)
- ``codeql/ruby-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/ruby/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/ruby/ql/src>`__)
- ``codeql/ruby-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/ruby/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/ruby/ql/lib>`__)
- ``codeql/swift-queries`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/swift/ql/src/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/swift/ql/src>`__)
- ``codeql/swift-all`` (`changelog <https://github.com/github/codeql/tree/codeql-cli/latest/swift/ql/lib/CHANGELOG.md>`__, `source <https://github.com/github/codeql/tree/codeql-cli/latest/swift/ql/lib>`__)

For more information, see "`About CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/about-codeql-packs>`__."

CodeQL bundle
-----------------------------

The CodeQL bundle consists of the CodeQL CLI together with the standard CodeQL query and library packs maintained by GitHub. The bundle is used by the CodeQL action in GitHub to generate code scanning results. If you use an external CI system, you can download the bundle from `GitHub releases <https://github.com/github/codeql-action/releases>`__, generate code scanning results, and upload them to GitHub.

CodeQL for Visual Studio Code
-----------------------------

You can analyze CodeQL databases in Visual Studio Code using the CodeQL
extension, which provides an enhanced environment for writing and running custom
queries and viewing the results. For more information, see "`CodeQL
for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/>`__."
