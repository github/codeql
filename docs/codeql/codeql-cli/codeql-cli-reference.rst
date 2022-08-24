.. _codeql-cli-reference:

CodeQL CLI reference
====================

Learn more about the files you can use when running CodeQL processes and the results format and exit codes that CodeQL generates.

.. toctree::
   :titlesonly:
   :hidden:

   about-codeql-packs
   query-reference-files
   sarif-output
   exit-codes
   extractor-options
   about-codeql-workspaces

- :doc:`About CodeQL packs <about-codeql-packs>`: CodeQL packs are created with the CodeQL CLI and are used to create, depend on, publish, and run CodeQL queries, libraries, and query suites.
- :doc:`Query reference files <query-reference-files>`: A query reference file is text file that defines the location of one query to test.
- :doc:`SARIF output <sarif-output>`: CodeQL supports SARIF as an output format for sharing static analysis results.
- :doc:`Exit codes <exit-codes>`: The CodeQL CLI reports the status of each command it runs as an exit code.
  This exit code provides information for subsequent commands or for other tools that rely on the CodeQL CLI.
- :doc:`Extractor options <extractor-options>`: You can customize the behavior of extractors by setting options through the CodeQL CLI.
- :doc:`About CodeQL workspaces <about-codeql-workspaces>`: CodeQL workspaces are used to group multiple CodeQL packs together.
