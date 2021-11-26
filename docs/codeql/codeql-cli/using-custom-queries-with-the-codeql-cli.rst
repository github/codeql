.. _using-custom-queries-with-the-codeql-cli:

Using custom queries with the CodeQL CLI
=========================================

You can customize your CodeQL analyses by writing your own queries to highlight
specific vulnerabilities or errors.

This topic is specifically about writing
queries to use with the `database analyze <../manual/database-analyze>`__
command to produce :ref:`interpreted results <interpret-query-results>`.

.. include:: ../reusables/advanced-query-execution.rst

Writing a valid query
---------------------

Before running a custom analysis you need to write a valid query, and save it in
a file with a ``.ql`` extension. There is extensive documentation available to
help you write queries. For more information, see ":ref:`CodeQL queries
<codeql-queries>`."

.. _including-query-metadata:

Including query metadata
------------------------

Query metadata is included at the top of each query file. It provides users with information about
the query, and tells the CodeQL CLI how to process the query results.

When running queries with the ``database analyze`` command, you must include the
following two properties to ensure that the results are interpreted correctly:

- Query identifier (``@id``): a sequence of words composed of lowercase letters or
  digits, delimited by ``/`` or ``-``, identifying and classifying the query.
- Query type (``@kind``): identifies the query as a simple alert (``@kind problem``),
  an alert documented by a sequence of code locations (``@kind path-problem``),
  for extractor troubleshooting (``@kind diagnostic``), or a summary metric
  (``@kind metric`` and ``@tags summary``).

For more information about these metadata properties, see ":ref:`Metadata for CodeQL queries
<metadata-for-codeql-queries>`" and the `Query metadata style guide
<https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md>`__.

.. pull-quote:: Note

   Metadata requirements may differ if you want to use your query with other
   applications. For more information, see ":ref:`Metadata for CodeQL queries
   <metadata-for-codeql-queries>`
   ."

Packaging custom QL queries
---------------------------

.. include:: ../reusables/beta-note-package-management.rst

When you write your own queries, you should save them in a custom QL pack
directory. When you are ready to share your queries with other users, you can publish the pack as a CodeQL pack to GitHub Packages - the GitHub Container registry.

QL packs organize the files used in CodeQL analysis and can store queries,
library files, query suites, and important metadata. Their root directory must
contain a file named ``qlpack.yml``. Your custom queries should be saved in the
QL pack root, or its subdirectories.

For each QL pack, the ``qlpack.yml`` file includes information that tells CodeQL
how to compile the queries, which other CodeQL packs and libraries the pack
depends on, and where to find query suite definitions. For more information
about what to include in this file, see ":ref:`About QL packs <about-ql-packs>`."

CodeQL packages are used to create, share, depend on, and run CodeQL queries and
libraries. You can publish your own CodeQL packages and download ones created by
others via the the Container registry. For further information see
":ref:`About CodeQL packs <about-codeql-packs>`."

Contributing to the CodeQL repository
-------------------------------------

If you would like to share your query with other CodeQL users, you can open a
pull request in the `CodeQL repository <https://github.com/github/codeql>`__. For
further information, see `Contributing to CodeQL
<https://github.com/github/codeql/blob/main/CONTRIBUTING.md>`__.

Further reading
---------------

- ":ref:`CodeQL queries
  <codeql-queries>`"
