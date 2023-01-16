.. _about-codeql-packs:

About CodeQL packs
==================

.. include:: ../reusables/beta-note-package-management.rst

CodeQL packs are used to create, share, depend on, and run CodeQL queries and libraries. You can publish your own CodeQL packs and download packs created by others. CodeQL packs contain queries, library files, query suites, and metadata.

There are two types of CodeQL packs: query packs and library packs.

* Query packs are designed to be run. When a query pack is published, the bundle includes all the transitive dependencies and pre-compiled representations of each query, in addition to the query sources. This ensures consistent and efficient execution of the queries in the pack.
* Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled separately.

You can use the package management commands in the CodeQL CLI to create CodeQL packs, add dependencies to packs, and install or update dependencies. For more information, see ":ref:`Creating and working with CodeQL packs <creating-and-working-with-codeql-packs>`." You can also publish and download CodeQL packs using the CodeQL CLI. For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."


The standard CodeQL packages for all supported languages are published in the `GitHub Container registry <https://github.com/orgs/codeql/packages>`__.
The `CodeQL repository <https://github.com/github/codeql>`__ contains source files for the standard CodeQL packs for all supported languages.

.. _codeql-pack-structure:

CodeQL pack structure
---------------------

A CodeQL pack must contain a file called ``qlpack.yml`` in its root directory. In the ``qlpack.yml`` file, the ``name:`` field must have a value that follows the format of ``<scope>/<pack>``, where ``<scope>`` is the GitHub organization or user account that the pack will be published to and ``<pack>`` is the name of the pack. Additionally, query packs and library packs with CodeQL tests contain a ``codeql-pack.lock.yml`` file that contains the resolved dependencies of the pack. This file is generated during a call to the ``codeql pack install`` command, is not meant to be edited by hand, and should be added to your version control system.

The other files and directories within the pack should be logically organized. For example, typically:

- Queries are organized into directories for specific categories.
- Queries for specific products, libraries, and frameworks are organized into
  their own top-level directories.

About published packs
~~~~~~~~~~~~~~~~~~~~~~~~~

When a pack is published for use in analyses, the ``codeql pack create`` or ``codeql pack publish`` command verifies that the content is complete and also adds some additional pieces of content to it:

* For query packs, a copy of each of the library packs it depends on, in the precise versions it has been developed with. Users of the query pack won't need to download these library packs separately.
* For query packs, precompiled representations of each of the queries. These are faster to execute than it would be to compile the QL source for the query at each analysis.

Most of this data is located in a directory named ``.codeql`` in the published pack, but precompiled queries are in files with a ``.qlx`` suffix next to the ``.ql`` source for each query. When analyzing a database with a query from a published pack, CodeQL will load these files instead of the ``.ql`` source. If you need to modify the content of a *published* pack, be sure to remove all of the ``.qlx`` files, since they may prevent modifications in the ``.ql`` files from taking effect.

About ``qlpack.yml`` files
--------------------------

When executing query-related commands, CodeQL first looks in siblings of the installation directory (and their subdirectories) for ``qlpack.yml`` files.
Then it checks the package cache for CodeQL packs which have been downloaded. This means that when you are developing queries locally, the local packages
in the installation directory override packages of the same name in the package cache, so that you can test your local changes.

The metadata in each ``qlpack.yml`` file tells
CodeQL how to compile any queries in the pack, what libraries the pack depends on, and where to
find query suite definitions.

The contents of the CodeQL pack (queries or libraries used in CodeQL analysis) is included in the same directory as ``qlpack.yml``, or its subdirectories.

The directory containing the ``qlpack.yml`` file serves as the root directory for the content of the CodeQL pack. That is, for all ``.ql`` and ``.qll`` files in the pack, CodeQL will resolve all import statements relative to the directory containing the ``qlpack.yml`` file at the pack's root.

.. _codeqlpack-yml-properties:

``qlpack.yml`` properties
~~~~~~~~~~~~~~~~~~~~~~~~~

The following properties are supported in ``qlpack.yml`` files.

.. list-table::
   :header-rows: 1
   :widths: auto

   * - Property
     - When to use
     - Explanation
   * - ``name``
     - Required by all packs
     - The scope, where the CodeQL pack is published, and the name of the pack defined using alphanumeric characters and hyphens. It must be unique as CodeQL cannot differentiate between CodeQL packs with identical names. Use the pack name to specify queries to run using ``database analyze`` and to define dependencies between CodeQL packs (see examples below).

       Example:

       .. code-block:: yaml

        name: octo-org/security-queries

   * - ``version``
     - Required by all packs that are published
     - A semantic version for this CodeQL pack that must adhere to the `SemVer v2.0.0 specification <https://semver.org/spec/v2.0.0.html>`__.

       Example:

       .. code-block:: yaml

        version: 0.0.0

   * - ``dependencies``
     - Required by packs that define CodeQL package dependencies on other packs.
     - A map from pack references to the semantic version range that is compatible with this pack. Supported for CLI versions v2.6.0 and later.

       Example:

       .. code-block:: yaml

        dependencies:
          codeql/cpp-all: ^0.0.2

   * - ``defaultSuiteFile``
     - Required by packs that export a set of default queries to run
     - The path to a query suite file relative to the package root, containing all of the queries that are run by default when this pack is passed to the ``codeql database analyze`` command. Supported from CLI version v2.6.0 and onwards. Only one of ``defaultSuiteFile`` or ``defaultSuite`` can be defined.

       Example:

       .. code-block:: yaml

        defaultSuiteFile: cpp-code-scanning.qls

   * - ``defaultSuite``
     - Required by packs that export a set of default queries to run.
     - An inlined query suite containing all of the queries that are run by default when this pack is passed to the ``codeql database analyze`` command. Supported from CLI version v2.6.0 and onwards. Only one of ``defaultSuiteFile`` or ``defaultSuite`` can be defined.

       Example:

       .. code-block:: yaml

        defaultSuite:
          queries: .
          exclude:
            precision: medium

   * - ``library``
     - Required by library packs
     - A boolean value that indicates whether this pack is a library pack. Library packs do not contain queries and are not compiled. Query packs can ignore this field or explicitly set it to ``false``.

       Example:

       .. code-block:: yaml

        library: true

   * - ``suites``
     - Optional for packs that define query suites
     - The path to a directory in the pack that contains the query suites you want to make known to the CLI, defined relative to the pack directory. CodeQL pack users can run "well-known" suites stored in this directory by specifying the pack name, without providing their full path. This is not supported for CodeQL packs downloaded from the Container registry. For more information about query suites, see ":doc:`Creating CodeQL query suites <creating-codeql-query-suites>`."

       Example:

       .. code-block:: yaml

        suites: octo-org-query-suites

   * - ``tests``
     - Optional for packs containing CodeQL tests. Ignored for packs without tests.
     - The path to a directory within the pack that contains tests, defined relative to the pack directory. Use ``.`` to specify the whole pack. Any queries in this directory are run as tests when ``test run`` is run with the ``--strict-test-discovery`` option. These queries are ignored by query suite definitions that use ``queries`` or ``qlpack`` instructions to ask for all queries in a particular pack. If this property is missing, then ``.`` is assumed.

       Example:

       .. code-block:: yaml

        tests: .

   * - ``extractor``
     - All packs containing CodeQL tests
     - The CodeQL language extractor to use when running the CodeQL tests in the pack. For more information about testing queries, see ":doc:`Testing custom queries <testing-custom-queries>`."

       Example:

       .. code-block:: yaml

        extractor: javascript

   * - ``authors``
     - Optional
     - Metadata that will be displayed on the packaging search page in the packages section of the account that the CodeQL pack is published to.

       Example:

       .. code-block:: yaml

        authors: author1@github.com,author2@github.com

   * - ``license``
     - Optional
     - Metadata that will be displayed on the packaging search page in the packages section of the account that the CodeQL pack is published to. For a list of allowed licenses, see `SPDX License List <https://spdx.org/licenses/>`__ in the SPDX Specification.

       Example:

       .. code-block:: yaml

        license: MIT

   * - ``description``
     - Optional
     - Metadata that will be displayed on the packaging search page in the packages section of the account that the CodeQL pack is published to.

       Example:

       .. code-block:: yaml

        description: Human-readable description of the contents of the CodeQL pack.

   * - ``libraryPathDependencies``
     - Optional, deprecated
     - Use the ``dependencies`` property instead. The names of any CodeQL packs that this CodeQL pack depends on, as an array. This gives the pack access to any libraries, database schema, and query suites defined in the dependency.

       Example:

       .. code-block:: yaml

        libraryPathDependencies: codeql/javascript-all

   * - ``dbscheme``
     - Required by core language packs only
     - The path to the :ref:`database schema <codeql-database-schema>` for all libraries and queries written for this CodeQL language (see example below).

       Example:

       .. code-block:: yaml

        dbscheme: semmlecode.python.dbscheme

   * - ``upgrades``
     - Required by core language packs only
     - The path to a directory within the pack that contains database upgrade scripts, defined relative to the pack directory. Database upgrades are used internally to ensure that a database created with a different version of the CodeQL CLI is compatible with the current version of the CLI.

       Example:

       .. code-block:: yaml

        upgrades: .

.. _about-codeql-pack-lock:

About ``codeql-pack.lock.yml`` files
------------------------------------

``codeql-pack.lock.yml`` files store the versions of the resolved transitive dependencies of a CodeQL pack. This file is created by the ``codeql pack install`` command if it does not already exist and should be added to your version control system. The ``dependencies`` section of the ``qlpack.yml`` file contains version ranges that are compatible with the pack. The ``codeql-pack.lock.yml`` file locks the versions to precise dependencies. This ensures that running ``codeql pack install`` on this the pack will always retrieve the same versions of dependencies even if newer compatible versions exist.

For example, if a ``qlpack.yml`` file contains the following dependencies:

.. code-block:: yaml

   dependencies:
     codeql/cpp-all: ^0.1.2
     my-user/my-lib: ^0.2.3
     other-dependency/from-source: "*"

The ``codeql-pack.lock.yml`` file will contain something like the following:

.. code-block:: yaml

   dependencies:
     codeql/cpp-all:
       version: 0.1.4
     my-user/my-lib:
       version: 0.2.4
     my-user/transitive-dependency:
       version: 1.2.4

The ``codeql/cpp-all`` dependency is locked to version 0.1.4. The ``my-user/my-lib`` dependency is locked to version 0.2.4. The ``my-user/transitive-dependency``, which is a transitive dependency and is not specified in the ``qlpack.yml`` file, is locked to version 1.2.4. The ``other-dependency/from-source`` is absent from the lock file since it is resolved from source. This dependency must be available in the same CodeQL workspace as the pack. For more information about CodeQL workspaces and resolving dependencies from source, see ":doc:`About CodeQL Workspaces <about-codeql-workspaces>`."

In most cases, the ``codeql-pack.lock.yml`` file is only relevant for query packs since library packs are non-executable and usually do not need their transitive dependencies to be fixed. The exception to this is for library packs that contain tests. In this case, the ``codeql-pack.lock.yml`` file is used to ensure that the tests are always run with the same versions of dependencies to avoid spurious failures when there are mismatched dependencies.

.. _custom-codeql-packs:

Examples of custom CodeQL packs
-------------------------------

When you write custom queries or tests, you should save them in custom CodeQL packs. For simplicity, try to organize each pack logically. For more information, see "`CodeQL pack structure <#codeql-pack-structure>`__." Save files for queries and tests in separate packs and, where possible, organize custom packs into specific folders for each target language. This is particuarly useful if you intend to publish your CodeQL packs so they can be shared with others or used in GitHub `Code scanning <https://docs.github.com/en/code-security/secure-coding/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning>`__.

CodeQL packs for custom libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A custom CodeQL pack containing custom C++ libraries, with no queries or tests, may have a ``qlpack.yml`` file containing:

.. code-block:: yaml

   name: my-github-user/my-custom-libraries
   version: 1.2.3
   library: true
   dependencies:
     codeql/cpp-all: ^0.1.2

where ``codeql/cpp-all`` is the name of the CodeQL pack for C/C++ analysis included in the CodeQL repository. The version range ``^0.1.2`` indicates that this pack is compatible with all versions of ``codeql/cpp-all`` that are greater than or equal to ``0.1.2`` and less than ``0.2.0``. Any CodeQL library file (a file with a ``.qll`` extension) defined in this pack will be available to queries defined in any query pack that includes this pack in its dependencies block.

The ``library`` property indicates that this pack is a library pack and does not contain any queries.

CodeQL packs for custom queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A custom CodeQL pack containing custom C++ queries and libraries may have a ``qlpack.yml`` file containing:

.. code-block:: yaml

   name: my-github-user/my-custom-queries
   version: 1.2.3
   dependencies:
     codeql/cpp-all: ^0.1.2
     my-github-user/my-custom-libraries: ^1.2.3
   suites: my-custom-suites

where ``codeql/cpp-all`` is the name of the CodeQL pack for C/C++ analysis included in the CodeQL repository. The version range ``^0.1.2`` indicates that this pack is compatible with all versions of ``codeql/cpp-all`` that are greater than or equal to ``0.1.2`` and less than ``0.2.0``. ``my-github-user/my-custom-libraries`` is the name of a CodeQL pack containing custom CodeQL libraries for C++. Any CodeQL library file (a file with a ``.qll`` extension) defined in this pack will be available to queries in the ``my-github-user/my-custom-queries`` pack.

The ``suites`` property indicates a directory where "well-known" query suites can be found. These suites can be used on the command line by referring to their name only, rather than their full path. For more information about query suites, see ":doc:`Creating CodeQL query suites <creating-codeql-query-suites>`."

CodeQL packs for custom tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For custom CodeQL packs containing test files, you also need to include an
``extractor`` property so that the ``test run`` command knows how to create test
databases. You may also wish to specify the ``tests`` property.

.. include:: ../reusables/test-qlpack.rst

For more information about running tests, see ":doc:`Testing custom queries
<testing-custom-queries>`."

.. _standard-codeql-packs:

Examples of CodeQL packs in the CodeQL repository
-------------------------------------------------

Each of the languages in the CodeQL repository has four main CodeQL packs:

- Core library pack for the language, with the :ref:`database schema <codeql-database-schema>`
  used by the language, and CodeQL libraries, and queries at ``<language>/ql/lib``
- Core query pack for the language that includes the default queries for the language, along
  with their query suites at ``<language>/ql/src``
- Tests for the core language libraries and queries at ``<language>/ql/test``
- Example queries for the language at ``<language>/ql/examples``

Core library pack
~~~~~~~~~~~~~~~~~

Here is an example ``qlpack.yml`` file for the `C/C++ analysis libraries
<https://github.com/github/codeql/blob/main/cpp/ql/lib/qlpack.yml>`__
core language pack:

.. code-block:: yaml

   name: codeql/cpp-all
   version: x.y.z-dev
   dbscheme: semmlecode.cpp.dbscheme
   library: true
   upgrades: upgrades

Some extra notes on the following properties:

- ``library``: Indicates that this is a library pack with no executable queries. It is only meant to be used as a dependency for other packs.
- ``dbscheme`` and ``upgrades``: These properties are internal to the CodeQL CLI and should only be defined in the core QL pack for a language.

.. _standard-codeql-query-packs:

Core query pack
~~~~~~~~~~~~~~~

Here is an example ``qlpack.yml`` file for `C/C++ analysis queries
<https://github.com/github/codeql/blob/main/cpp/ql/src/qlpack.yml>`__
core query pack:

.. code-block:: yaml

   name: codeql/cpp-queries
   version: x.y.z-dev
   dependencies:
       codeql/cpp-all: "*"
       codeql/suite-helpers: "*"
   suites: codeql-suites
   defaultSuiteFile: codeql-suites/cpp-code-scanning.qls

Some extra notes on the following properties:

- ``dependencies``: This query pack depends on ``codeql/cpp-all`` and ``codeql/suite-helpers``. Since these dependencies are resolved from source, it does not matter what version of the CodeQL pack they are compatible with. For more information about resolving dependencies from source, see ":ref:`Source Dependencies <source-dependencies>`."
- ``suites``: Indicates the directory containing "well-known" query suites.
- ``defaultSuiteFile``: The name of the default query suite file that is used when no query suite is specified.

Tests for the core CodeQL pack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here is an example ``qlpack.yml`` file for `C/C++ analysis tests
<https://github.com/github/codeql/blob/main/cpp/ql/src/qlpack.yml>`__
core test pack:

.. code-block:: yaml

   name: codeql/cpp-tests
   dependencies:
     codeql/cpp-all: "*"
     codeql/cpp-queries: "*"
   extractor: cpp
   tests: .

Some extra notes on the following properties:

- ``dependencies``: This pack depends on the core CodeQL query and library packs for C++.
- ``extractor``: This specifies that all the tests will use the same C++ extractor to create the database for the tests.
- ``tests``: This specifies the location of the tests. In this case, the tests are in the root folder (and all sub-folders) of the pack.
- ``version``: There is no ``version`` property for the tests pack. This prevents test packs from accidentally being published.
