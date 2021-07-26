.. _about-codeql-packs:

About CodeQL packs
==================

.. pull-quote::

   Note

   CodeQL packs are currently in beta and subject to change.

CodeQL packs are used to create, share, depend on, and run CodeQL queries and libraries. You can publish your own CodeQL packs and download packs created by others. CodeQL packs contain queries, library files, query suites, and  metadata.

There are two types of CodeQL packs: query packs and library packs.

* Query packs are designed to be run. They are bundled with all transitive dependencies. Also included in the tarball is a compilation cache which is used to ensure the packs' efficient execution.
* Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled and there is no compilation cache included in the final pack.

You can use the CodeQL package manger in the CodeQL CLI to create CodeQL packs, add dependencies to packs, and install or update dependencies. For more information, see ":ref:`Creating and working with CodeQL packs <creating-and-working-with-codeql-packs>`." You can also publish and download CodeQL packs using the CodeQL package manager. For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."

CodeQL pack structure
---------------------

A CodeQL pack must contain a file called ``qlpack.yml`` in its root directory. In the ``qlpack.yml`` file, the ``name:`` field must have a value that follows the format of ``<scope>/<pack>``, where ``<scope>`` is the GitHub organization that the pack is published to and ``<pack>`` is the name of the pack. The other
files and directories within the pack should be logically organized. For example, typically:

- Queries are organized into directories for specific categories.
- Queries for specific products, libraries, and frameworks are organized into
  their own top-level directories.

About ``qlpack.yml`` files
--------------------------

When executing query-related commands, CodeQL first looks in the package cache for CodeQL packs which have already been downloaded. If a suitable pack cannot be found, then CodeQL scans siblings of the installation directory (and their subdirectories) for ``qlpack.yml`` files. The metadata in the file tells
CodeQL how to compile queries, what libraries the pack depends on, and where to
find query suite definitions.

The content of the CodeQL pack (queries and libraries used in CodeQL analysis) is
included in the same directory as ``qlpack.yml``, or its subdirectories.

The location of ``qlpack.yml`` defines the library path for the content
of the CodeQL pack. That is, for all ``.ql`` and ``.qll`` files in the pack,
CodeQL will resolve all import statements relative to the ``qlpack.yml`` at the
pack's root.

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
     - ``codeql/queries``
     - All packs
     - The scope, where the CodeQL pack is published, and the name of the pack defined using alphanumeric characters, hyphens, and periods. It must be unique as CodeQL cannot differentiate between CodeQL packs with identical names. Use the pack name to specify queries to run using ``database analyze`` and to define    dependencies between QL packs (see examples below).
   * - ``version``
     - ``0.0.0``
     - All packs
     - A version number for this CodeQL pack. This must be a valid semantic version that meets the `SemVer v2.0.0 specification <https://semver.org/spec/v2.0.0.html>`__.
   * - ``dependencies``
     - ``github/codeql-javascript:1.2.3``
     - Optional
     - The names of any CodeQL packs that this pack depends on, as a sequence. This gives the pack access to any libraries, database schema, and query suites defined in the dependency.
   * - ``default-suite-file``
     - ``default-queries.qls``
     - Optional
     - The path to a directory that contains the "well-known" query suites in the pack, defined relative to the pack directory. You can run "well-known" suites stored in this directory by specifying the pack name, without providing their full path. For more information about query suites, see ":doc:`Creating CodeQL query suites <creating-codeql-query-suites>`."
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
   * - ``collaborators``
     - ``example@github.com``
     - Metadata that will be displayed on the packaging search page in the packages section of the organization that a CodeQL pack is published to.
   * - ``bugs``
     - ``https://github.com/my-org/my-repo/issues/X``
     - Metadata that will be displayed on the packaging search page in the packages section of the organization that a CodeQL pack is published to.
