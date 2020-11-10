test extract
============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql test extract <options>... [--] <testDir>

Description
-----------

[Plumbing] Build a dataset for a test directory.

Build a database for a specified test directory, without actually running
any test queries. Outputs the path to the raw QL dataset to execute test
queries against.


Options
-------

.. program:: codeql test extract

.. option:: <testDir>

   [Mandatory] The path to the test directory.

.. option:: --database=<dir>

   Override the location of the database being created. By default it
   will be a subdirectory whose name is derived from the name of the test
   directory itself with '.testproj' appended.

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which extractor packs may be found. The
   directories can either be the extractor packs themselves or
   directories that contain extractors as immediate subdirectories.

   If the path contains multiple directory trees, their order defines
   precedence between them: if the target language is matched in more
   than one of the directory trees, the one given first wins.

   The extractors bundled with the CodeQL toolchain itself will always be
   found, but if you need to use separately distributed extractors you
   need to give this option (or, better yet, set up ``--search-path`` in
   a per-user configuration file).

   (Note: On Windows the path separator is ``;``).

.. option:: --cleanup

   Remove the test database instead of creating it.

.. option:: --[no-]check-unused-labels

   [Advanced] Report errors for unused labels.

.. option:: --[no-]check-repeated-labels

   [Advanced] Report errors for repeated labels.

.. option:: --[no-]check-redefined-labels

   [Advanced] Report errors for redefined labels.

.. option:: --[no-]check-use-before-definition

   [Advanced] Report errors for labels used before they're defined.

.. option:: --[no-]include-location-in-star

   [Advanced] Construct entity IDs that encode the location in the TRAP
   file they came from. Can be useful for debugging of TRAP generators,
   but takes up a lot of space in the dataset.

.. option:: --format=<fmt>

   Select output format. Choices include ``text`` (default) and ``json``.

Options for checking imported TRAP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --[no-]show-extractor-output

   [Advanced] Show the output from extractor scripts that create test
   databases. This is mostly useful for debugging extractor failures.
   Beware that it can cause duplicated or malformed output if you use
   this with multiple threads!

Common options
~~~~~~~~~~~~~~

.. option:: -h, --help

   Show this help text.

.. option:: -J=<opt>

   [Advanced] Give option to the JVM running the command.

   (Beware that options containing spaces will not be handled correctly.)

.. option:: -v, --verbose

   Incrementally increase the number of progress messages printed.

.. option:: -q, --quiet

   Incrementally decrease the number of progress messages printed.

.. option:: --verbosity=<level>

   [Advanced] Explicitly set the verbosity level to one of errors,
   warnings, progress, progress+, progress++, progress+++. Overrides
   ``-v`` and ``-q``.

.. option:: --logdir=<dir>

   [Advanced] Write detailed logs to one or more files in the given
   directory, with generated names that include timestamps and the name
   of the running subcommand.

   (To write a log file with a name you have full control over, instead
   give ``--log-to-stderr`` and redirect stderr as desired.)

