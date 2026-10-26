:tocdepth: 1

.. _about-codeql:

.. meta::
   :description: Introduction to CodeQL, a language and toolchain for code analysis.
   :keywords: CodeQL, code analysis, CodeQL analysis, security vulnerabilities, variant analysis, resources, tutorials, interactive training, GitHub Security Lab, security researchers, CodeQL databases

About CodeQL
============

CodeQL is a language and toolchain for code analysis. It is designed to allow security researchers to scale their knowledge of a single vulnerability to identify variants of that vulnerability across a wide range of codebases. It is also designed to allow developers to automate security checks and integrate them into their development workflows.

Resources for learning CodeQL
-----------------------------

- **CodeQL docs site:** contains information on the CodeQL language and libraries, with tutorials and guides to help you learn how to write your own queries.

   - :doc:`CodeQL queries <../writing-codeql-queries/codeql-queries>`: A general, language-neutral overview of the key components of a query.

   - :doc:`QL tutorials <../writing-codeql-queries/ql-tutorials>`: Solve puzzles to learn the basics of QL before you analyze code with CodeQL. The tutorials teach you how to write queries and introduce you to key logic concepts along the way.

   - :doc:`CodeQL language guides <../codeql-language-guides/index>`: Guides to the CodeQL libraries for each language, including the classes and predicates that are available for use in queries, with worked examples.

- **GitHub Security Lab:** is GitHub's own security research team. They've created a range of resources to help you learn how to use CodeQL to find security vulnerabilities in real-world codebases.

   - `Secure code game <https://github.com/skills/secure-code-game>`__: A series of interactive sessions that guide you from finding insecure code patterns manually, through to using CodeQL to find insecure code patterns automatically.

   - `Security Lab CTF <https://securitylab.github.com/ctf/>`__: A series of Capture the Flag (CTF) challenges that are designed to help you learn how to use CodeQL to find security vulnerabilities in real-world codebases.

   - `Security Lab blog <https://github.blog/tag/github-security-lab/>`__: A series of blog posts that describe how CodeQL is used by security researchers to find security vulnerabilities in real-world codebases.

About variant analysis
----------------------

Variant analysis is the process of using a known security vulnerability as a
seed to find similar problems in your code. It's a technique that security
engineers use to identify potential vulnerabilities, and ensure these threats
are properly fixed across multiple codebases.

Querying code using CodeQL is the most efficient way to perform variant
analysis. You can use the standard CodeQL queries to identify seed
vulnerabilities, or find new vulnerabilities by writing your own custom CodeQL
queries. Then, develop or iterate over the query to automatically find logical
variants of the same bug that could be missed using traditional manual
techniques.

When you have a query that finds variants of a vulnerability, you can use multi-repository variant analysis to run that query across a large number of codebases, and identify all of the places where that vulnerability exists. For more information, see `Running CodeQL queries at scale with multi-repository variant analysis <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/running-codeql-queries-at-scale-with-multi-repository-variant-analysis>`__ in the GitHub docs.

CodeQL analysis
---------------

CodeQL analysis consists of three steps:

#. Preparing the code, by creating a CodeQL database
#. Running CodeQL queries against the database
#. Interpreting the query results

For information on the CodeQL toolchain and on running CodeQL to analyze a codebase, see the `CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli>`__, `CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code>`__, and `About code scanning with CodeQL <https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql>`__ in the GitHub docs.

Database creation
~~~~~~~~~~~~~~~~~

To create a database, CodeQL first extracts a single relational representation
of each source file in the codebase.

For compiled languages, extraction works by monitoring the normal build process.
Each time a compiler is invoked to process a source file, a copy of that file is
made, and all relevant information about the source code is collected. This includes
syntactic data about the abstract syntax tree and semantic data about name
binding and type information.

For interpreted languages, the extractor runs directly on the source code,
resolving dependencies to give an accurate representation of the codebase.

There is one :ref:`extractor <extractor>` for each language supported by CodeQL
to ensure that the extraction process is as accurate as possible. For
multi-language codebases, databases are generated one language at a time.

After extraction, all the data required for analysis (relational data, copied
source files, and a language-specific :ref:`database schema
<codeql-database-schema>`, which specifies the mutual relations in the data) is
imported into a single directory, known as a :ref:`CodeQL database
<codeql-database>`.

Query execution
~~~~~~~~~~~~~~~

After you've created a CodeQL database, one or more queries are executed
against it. CodeQL queries are written in a specially-designed object-oriented
query language called QL. You can run the queries checked out from the CodeQL
repo (or custom queries that you've written yourself) using the `CodeQL
for VS Code extension <https://docs.github.com/en/code-security/codeql-for-vs-code/>`__ or the `CodeQL CLI
<https://docs.github.com/en/code-security/codeql-cli>`__. For more information about queries, see ":ref:`About CodeQL queries <about-codeql-queries>`."

.. _interpret-query-results:

Query results
~~~~~~~~~~~~~

The final step converts results produced during query execution into a form that
is more meaningful in the context of the source code. That is, the results are
interpreted in a way that highlights the potential issue that the queries are
designed to find.

Queries contain metadata properties that indicate how the results should be
interpreted. For instance, some queries display a simple message at a single
location in the code. Others display a series of locations that represent steps
along a data-flow or control-flow path, along with a message explaining the
significance of the result. Queries that don't have metadata are not
interpreted---their results are output as a table and not displayed in the source
code.

Following interpretation, results are output for code review and triaging. In
CodeQL for Visual Studio Code, interpreted query results are automatically
displayed in the source code. Results generated by the CodeQL CLI can be output
into a number of different formats for use with different tools.


About CodeQL databases
----------------------

CodeQL databases contain queryable data extracted from a codebase, for a single
language at a particular point in time. The database contains a full,
hierarchical representation of the code, including a representation of the
abstract syntax tree, the data flow graph, and the control flow graph.

Each language has its own unique database schema that defines the relations used
to create a database. The schema provides an interface between the initial
lexical analysis during the extraction process, and the actual complex analysis
using CodeQL. The schema specifies, for instance, that there is a table for
every language construct.

For each language, the CodeQL libraries define classes to provide a layer of
abstraction over the database tables. This provides an object-oriented view of
the data which makes it easier to write queries.

For example, in a CodeQL database for a Java program, two key tables are:

-  The ``expressions`` table containing a row for every single expression in the
   source code that was analyzed during the build process.
-  The ``statements`` table containing a row for every single statement in the
   source code that was analyzed during the build process.

The CodeQL library defines classes to provide a layer of abstraction over each
of these tables (and the related auxiliary tables): ``Expr`` and ``Stmt``.
