:tocdepth: 1

.. _codeql-glossary:

CodeQL glossary
===============

An overview of the technical terms and concepts in CodeQL.

.. _bqrs-file:

``.bqrs`` file
--------------

A binary query result set (BQRS) file. BQRS is the binary representation of the raw
result of a query, with the extension ``.bqrs``. A BQRS file can be
interpreted into meaningful results and related to your source code. For
example, alert query results are interpreted to display a string at the
location in the source code where the alert occurs, as specified in the query.
Similarly, path query results are interpreted as pairs of locations
(sources and sinks) between which information can flow. These results can be
exported as a variety of different formats, including SARIF.

.. _codeql-database:

CodeQL database
---------------

A database (or CodeQL database) is a directory containing:

- queryable data, extracted from the code.
- a source reference, for displaying query results directly in the code.
- query results.
- log files generated during database creation, query
  execution, and other operations.

.. _codeql-packs:

CodeQL packs
------------

CodeQL packs are used to create, share, depend on, and run CodeQL queries, libraries, and models. You can publish your own CodeQL packs and download packs created by others. CodeQL query packs may contain queries, library files, query suites, and metadata. CodeQL library packs include one or more CodeQL libraries. CodeQL model packs include one or more data extension files that extend the core libraries by modeling additional libraries and frameworks (dependencies of your code base).

.. _data-extensions:

Data extensions
---------------
When you want to model the sources and sinks of a custom dependency, you can create a CodeQL library (``.qll`` file) and write queries that use it, but it's usually much simpler to create a data extension file. If you model the sources and sinks in data extension, you can use this information to expand the standard queries to cover your custom dependencies. You don't need to write any new queries.

.. _dil:

DIL
---

DIL stands for Datalog Intermediary Language. It is an intermediate
representation between QL and relation algebra (RA) that is generated
during query compilation. DIL is useful for advanced users as an aid
for debugging query performance.
The DIL format may change without warning between CLI releases.

When you specify the ``--dump-dil`` option for ``codeql query compile``, CodeQL
prints DIL to standard output for the queries it compiles. You can also
view results in DIL format when you run queries in VS Code.
For more information, see `Running CodeQL queries <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/running-codeql-queries#understanding-your-query-results>`__ in the GitHub documentation.

.. _extractor:

Extractor
---------

An extractor is a tool that produces the relational data and source
reference for each input file, from which a CodeQL database can be built.

.. _codeql-database-schema:

QL database schema
------------------

A QL database schema is a file describing the column types and
extensional relations that make up a raw QL dataset. It is a text file
with the ``.dbscheme`` extension.

The extractor and core CodeQL pack for a language each declare the database
schema that they use. This defines the database layout they create or
expect. When you create a CodeQL database, the extractor copies
its schema into the database. The CLI uses this to check whether the
CodeQL database is compatible with a particular CodeQL library.
If they aren't compatible you can use ``database upgrade`` to upgrade
the schema for the CodeQL database.

There is currently no public-facing specification for the syntax of schemas.

.. _qlo:

``.qlo`` files
--------------

``.qlo`` files are optionally generated during query compilation.
If you specify the ``--dump-qlo`` option for ``codeql query compile``,
CodeQL writes ``.qlo`` files for the queries it compiles. They can be used
as an aid for debugging and performance tuning for advanced users.

``.qlo`` is a binary format that represents a compiled
and optimized query in terms of relational algebra (RA) or the
intermediate :ref:`DIL <dil>` format. ``.qlo`` files can be expanded to
readable text using ``codeql query decompile``.

The exact details of the ``.qlo`` format may change without warning between CLI releases.

.. _sarif-file:

SARIF file
----------

Static analysis results interchange format (SARIF) is an output format used for
sharing static analysis results. For more information, see "`SARIF <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output>`__."

.. _source-reference:

Source reference
----------------

A source reference is a mechanism that allows the retrieval of the
contents of a source file, given an absolute filename at which that file
resided during extraction. Specific examples include:

- A source archive directory, within which the requested absolute
  filename maps to a UTF8-encoded file.
- A source archive, typically in ZIP format, which contains the UTF8-encoded
  content of all source files.
- A source archive repository, typically in ``git`` format, typically bare,
  which contains the UTF8-encoded content of all source files.

Source references are typically included in CodeQL databases.

.. _trap-file:

TRAP file
---------

A TRAP file is a UTF-8 encoded file generated by a CodeQL extractor
with the extension ``.trap``. To save space, they are usually archived. They
contain the information that, when interpreted relative to a QL database
schema, is used to create a QL dataset.
