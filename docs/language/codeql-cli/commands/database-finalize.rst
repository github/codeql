database finalize
=================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database finalize [--dbscheme=<file>] [--threads=<num>] [--mode=<mode>] <options>... [--] <database>

Description
-----------

[Plumbing] Final steps in database creation.

Finalize a database that was created with :doc:`codeql database init
<database-init>` and subsequently seeded with analysis data using
:doc:`codeql database trace-command <database-trace-command>`. This needs
to happen before the new database can be queried.


Options
-------

.. program:: codeql database finalize

.. option:: <database>

   [Mandatory] Path to the CodeQL database under construction to
   finalize.

.. option:: -S, --dbscheme=<file>

   [Advanced] Override the auto-detected dbscheme definition that the
   TRAP files are assumed to adhere to. Normally, this is taken from the
   database's extractor.

.. option:: -j, --threads=<num>

   Use this many threads for the import operation.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: --no-cleanup

   [Advanced] Suppress all database cleanup after finalization. Useful
   for debugging purposes.

.. option:: --no-pre-finalize

   [Advanced] Skip any pre-finalize script specified by the active CodeQL
   extractor.

Low-level dataset cleanup options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --max-disk-cache=<MB>

   Set the maximum amount of space the disk cache for intermediate query
   results can use.

   If this size is not configured explicitly, the evaluator will try to
   use a "reasonable" amount of cache space, based on the size of the
   dataset and the complexity of the queries. Explicitly setting a higher
   limit than this default usage will enable additional caching which can
   speed up later queries.

.. option:: --min-disk-free=<MB>

   [Advanced] Set target amount of free space on file system.

   If ``--max-disk-cache`` is not given, the evaluator will try hard to
   curtail disk cache usage if the free space on the file system drops
   below this value.

.. option:: --min-disk-free-pct=<pct>

   [Advanced] Set target fraction of free space on file system.

   If ``--max-disk-cache`` is not given, the evaluator will try hard to
   curtail disk cache usage if the free space on the file system drops
   below this percentage.

.. option:: -m, --mode=<mode>

   Select how aggressively to trim the cache. Choices include:

   ``brutal``: Remove the entire cache, trimming down to the state of a
   freshly extracted dataset

   ``normal`` (default): Trim everything except explicitly "cached"
   predicates.

   ``light``: Simply make sure the defined size limits for the disk cache
   are observed, deleting as many intermediates as necessary.

.. option:: --cleanup-upgrade-backups

   Delete any backup directories resulting from database upgrades.

.. option:: --[no-]finalize-dataset

   Finalize this dataset, making further attempts to import data into it
   fail. Passing this option allows some additional on-disk state to be
   deleted, but at the cost of sacrificing the ability to extend the
   dataset later.

Options for checking imported TRAP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

