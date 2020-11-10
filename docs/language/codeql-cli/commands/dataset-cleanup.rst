dataset cleanup
===============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql dataset cleanup [--mode=<mode>] <options>... [--] <dataset>

Description
-----------

[Plumbing] Clean up temporary files from a dataset.

Options
-------

.. program:: codeql dataset cleanup

.. option:: <dataset>

   [Mandatory] Path to the raw QL dataset to clean up.

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

