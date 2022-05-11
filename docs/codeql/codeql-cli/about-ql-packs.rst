.. _about-ql-packs:

About QL packs
==============

QL packs are used to organize the files used in CodeQL analysis. They
contain queries, library files, query suites, and important metadata.

The `CodeQL repository <https://github.com/github/codeql>`__ contains QL packs for
C/C++, C#, Java, JavaScript, Python, and Ruby. The `CodeQL for Go
<https://github.com/github/codeql-go/>`__ repository contains a QL pack for Go
analysis. You can also make custom QL packs to contain your own queries and
libraries.

QL pack structure
-----------------

A QL pack must contain a file called ``qlpack.yml`` in its root directory. The other
files and directories within the pack should be logically organized. For example, typically:

- Queries are organized into directories for specific categories.
- Queries for specific products, libraries, and frameworks are organized into
  their own top-level directories.
- There is a top-level directory named ``<owner>/<language>`` for query library
  (``.qll``) files. Within this directory, ``.qll`` files should be organized into
  subdirectories for specific categories.

About ``qlpack.yml`` files
--------------------------

When executing commands, CodeQL scans siblings of the installation directory (and
their subdirectories) for ``qlpack.yml`` files. The metadata in the file tells
CodeQL how to compile queries, what libraries the pack depends on, and where to
find query suite definitions.

The content of the QL pack (queries and libraries used in CodeQL analysis) is
included in the same directory as ``qlpack.yml``, or its subdirectories.

The location of ``qlpack.yml`` defines the library path for the content
of the QL pack. That is, for all ``.ql`` and ``.qll`` files in the QL pack,
CodeQL will resolve all import statements relative to the ``qlpack.yml`` at the
pack's root.

For example, in a QL pack with the following contents, you can import ``CustomSinks.qll``
from any location in the pack by declaring ``import mycompany.java.CustomSinks``.

.. code-block:: none

   qlpack.yml
   mycompany/
     java/
       security/
         CustomSinks.qll
   Security/
   CustomQuery.ql

For more information, see ":ref:`Importing modules <importing-modules>`"
in the QL language reference.

.. _qlpack-yml-properties:

``qlpack.yml`` properties
~~~~~~~~~~~~~~~~~~~~~~~~~

The following properties are supported in ``qlpack.yml`` files.

.. list-table::
   :header-rows: 1
   :widths: auto

   * - Property
     - Example
     - Required
     - Purpose
   * - ``name``
     - ``org-queries``
     - All packs
     - The name of the QL pack defined using alphanumeric characters, hyphens, and periods. It must be unique as CodeQL cannot differentiate between QL packs with identical names. If you intend to    distribute the pack, prefix the name with your (or your organization's) name followed by a hyphen. Use the pack name to specify queries to run using ``database analyze`` and to define    dependencies between QL packs (see examples below).
   * - ``version``
     - ``0.0.0``
     - All packs
     - A version number for this QL pack. This must be a valid semantic version that meets the `SemVer v2.0.0 specification <https://semver.org/spec/v2.0.0.html>`__.
   * - ``libraryPathDependencies``
     - ``codeql/javascript-all``
     - Optional
     - The names of any QL packs that this QL pack depends on, as a sequence. This gives the pack access to any libraries, database schema, and query suites defined in the dependency.
   * - ``suites``
     - ``suites``
     - Optional
     - The path to a directory in the pack that contains the query suites you want to make known to the CLI, defined relative to the pack directory. QL pack users can run "well-known" suites stored in this directory by specifying the pack name, without providing their full path. For more information about query suites, see ":doc:`Creating CodeQL query suites <creating-codeql-query-suites>`."
   * - ``extractor``
     - ``javascript``
     - All test packs
     - The CodeQL language extractor to use when the CLI creates a database from test files in the pack. For more information about testing queries, see ":doc:`Testing custom queries <testing-custom-queries>`."
   * - ``tests``
     - ``.``
     - Optional for test packs
     - Supported from release 2.1.0 onwards. The path to a directory within the pack that contains tests, defined relative to the pack directory. Use ``.`` to specify the whole pack. Any queries in this directory are run as tests when ``test run`` is run with the ``--strict-test-discovery`` option. These queries are ignored by query suite definitions that use ``queries`` or ``qlpack``    instructions to ask for all queries in a particular pack.
   * - ``dbscheme``
     - ``semmlecode.python.dbscheme``
     - Core language pack only
     - The path to the :ref:`database schema <codeql-database-schema>` for all libraries and queries written for this CodeQL language (see example below).
   * - ``upgrades``
     - ``.``
     - Packs with upgrades
     - The path to a directory within the pack that contains upgrade scripts, defined relative to the pack directory. The ``database upgrade`` action uses these scripts to update databases that were created by an older version of an extractor so they're compatible with the current extractor (see `Upgrade scripts for a language <#upgrade-scripts-for-a-language>`__ below.)
   * - ``dependencies``
     - .. code-block:: yaml

          dependencies:
            codeql/cpp-all: ^0.0.2

     - Packs that define CodeQL package dependencies on other packs
     - A map from pack references to the semantic version range that is compatible with this pack. Supported from CLI version v2.6.0 and onwards.
   * - ``defaultSuiteFile``
     - ``defaultSuiteFile: cpp-code-scanning.qls``
     - Packs that export a set of default queries to run
     - The path to a query suite file containing all of the queries that are run by default when this pack is passed to the ``codeql database analyze`` command. Supported from CLI version v2.6.0 and onwards.

.. _custom-ql-packs:

Examples of custom QL packs
---------------------------

When you write custom queries or tests, you should save them in
custom QL packs. For simplicity, try to organize each pack logically. For more
information, see `QL pack structure <#ql-pack-structure>`__. Save files for queries
and tests in separate packs and, where possible, organize custom packs into specific
folders for each target language.

QL packs for custom queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~

A custom QL pack for queries must include a ``qlpack.yml`` file at
the pack root, containing ``name``, ``version``,
and ``libraryPathDependencies`` properties. If the pack contains query suites, you can
use the ``suites`` property to define their location. Query suites defined
here are called "well-known" suites, and can be used on the command line by referring to
their name only, rather than their full path.
For more information about query suites, see ":doc:`Creating CodeQL query suites <creating-codeql-query-suites>`."

For example, a ``qlpack.yml`` file for a QL pack featuring custom C++ queries
and libraries may contain:

.. code-block:: yaml

   name: my-custom-queries
   version: 0.0.0
   libraryPathDependencies: codeql/cpp-all
   suites: my-custom-suites

where ``codeql/cpp-all`` is the name of the QL pack for C/C++ analysis included in
the CodeQL repository.

.. pull-quote::

   Note

   When you create a custom QL pack, it's usually a good idea to add it to the search path in your CodeQL configuration.
   This will ensure that any libraries the pack contains are available to the CodeQL CLI.
   For more information, see ":ref:`Specifying command options in a CodeQL configuration file <specifying-command-options-in-a-codeql-configuration-file>`."

QL packs for custom test files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For custom QL packs containing test files, you also need to include an
``extractor`` property so that the ``test run`` command knows how to create test
databases. You may also wish to specify the ``tests`` property.

.. include:: ../reusables/test-qlpack.rst

For more information about running tests, see ":doc:`Testing custom queries
<testing-custom-queries>`."

.. _standard-ql-packs:

Examples of QL packs in the CodeQL repository
---------------------------------------------

Each of the languages in the CodeQL repository has four main QL packs:

- Core library pack for the language, with the :ref:`database schema <codeql-database-schema>`
  used by the language, and CodeQL libraries, and queries at ``ql/<language>/ql/lib``
- Core query pack for the language that includes the default queries for the language, along
  with their query suites at ``ql/<language>/ql/src``
- Tests for the core language libraries and queries at ``ql/<language>/ql/test``
- Upgrade scripts for the language at ``ql/<language>/upgrades``

Core library pack
~~~~~~~~~~~~~~~~~

The ``qlpack.yml`` file for a core library pack uses the following properties:
``name``, ``version``, ``dbscheme``.
The ``dbscheme`` property should only be defined in the core QL
pack for a language.

For example, the ``qlpack.yml`` file for `C/C++ analysis libraries
<https://github.com/github/codeql/blob/main/cpp/ql/lib/qlpack.yml>`__
contains:

.. code-block:: yaml

   name: codeql/cpp-all
   version: 0.0.0
   dbscheme: semmlecode.cpp.dbscheme
   upgrades: upgrades

Core query pack
~~~~~~~~~~~~~~~

The ``qlpack.yml`` file for a core query pack uses the following properties:
``name``, ``version``, ``suites``, ``defaultSuiteFile``, ``dependencies`` .

For example, the ``qlpack.yml`` file for `C/C++ analysis queries
<https://github.com/github/codeql/blob/main/cpp/ql/lib/qlpack.yml>`__
contains:

.. code-block:: yaml

   name: codeql/cpp-queries
   version: 0.0.0
   suites: codeql-suites
   defaultSuiteFile: codeql-suites/cpp-code-scanning.qls
   dependencies:
    codeql/cpp-all: "*"
    codeql/suite-helpers: "*"

Tests for the core QL pack
~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``qlpack.yml`` file for the tests for the core QL packs use the following
properties: ``name``, ``version``, and ``dependencies``.
The ``dependencies`` always specifies the core QL pack.

For example, the ``qlpack.yml`` file for `C/C++ analysis tests
<https://github.com/github/codeql/blob/main/cpp/ql/test/qlpack.yml>`__
contains:

.. code-block:: yaml

   name: codeql/cpp-tests
   version: 0.0.0
   dependencies:
    codeql/cpp-all: "*"
    codeql/cpp-queries: "*"


.. _upgrade-ql-packs:
