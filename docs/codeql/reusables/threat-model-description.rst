.. include:: ../reusables/beta-note-threat-models.rst

A threat model is a named class of dataflow sources that can be enabled or disabled independently. Threat models allow you to control the set of dataflow sources that you want to consider unsafe. For example, one codebase may only consider remote HTTP requests to be tainted, whereas another may also consider data from local files to be unsafe. You can use threat models to ensure that the relevant taint sources are used in a CodeQL analysis.

The ``kind`` property of the ``sourceModel`` determines which threat model a source is associated with. There are two main categories:

- ``remote`` which represents requests and responses from the network.
- ``local`` which represents data from local files (``file``), command-line arguments (``commandargs``), database reads (``database``), environment variables(``environment``), standard input (``stdin``) and Windows registry values ("windows-registry"). Currently, Windows registry values are used by C# only.

Note that subcategories can be turned included or excluded separately, so you can specify ``local`` without ``database``, or just ``commandargs`` and ``environment`` without the rest of ``local``.

The less commonly used categories are:

- ``android`` which represents reads from external files in Android (``android-external-storage-dir``) and parameter of an entry-point method declared in a ``ContentProvider`` class (``contentprovider``). Currently only used by Java/Kotlin.
- ``database-access-result`` which represents a database access. Currently only used by JavaScript.
- ``file-write`` which represents opening a file in write mode. Currently only used in C#.
- ``reverse-dns`` which represents reverse DNS lookups. Currently only used in Java.
- ``view-component-input`` which represents inputs to a React, Vue, or Angular component (also known as "props"). Currently only used by JavaScript/TypeScript.

When running a CodeQL analysis, the ``remote`` threat model is included by default. You can optionally include other threat models as appropriate when using the CodeQL CLI and in GitHub code scanning. For more information, see `Analyzing your code with CodeQL queries <https://docs.github.com/code-security/codeql-cli/getting-started-with-the-codeql-cli/analyzing-your-code-with-codeql-queries#including-model-packs-to-add-potential-sources-of-tainted-data>`__ and `Customizing your advanced setup for code scanning <https://docs.github.com/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__.
