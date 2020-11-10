database upgrade
================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database upgrade [--threads=<num>] [--ram=<MB>] <options>... [--] <database>

Description
-----------

Upgrade a database so it is usable by the current tools.

This rewrites a CodeQL database to be compatible with the QL libraries
that are found on the QL pack search path, if necessary.

If an upgrade is necessary, it is irreversible. The database will
subsequently be unusable with the libraries that were current when it was
created.


Options
-------

.. program:: codeql database upgrade

.. option:: <database>

   [Mandatory] Path to the CodeQL database to upgrade.

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which QL packs containing upgrade recipes
   may be found. Each directory can either be a QL pack (or bundle of
   packs containing a ``.codeqlmanifest.json`` file at the root) or the
   immediate parent of one or more such directories.

   If the path contains directories trees, their order defines precedence
   between them: if a pack name that must be resolved is matched in more
   than one of the directory trees, the one given first wins.

   Pointing this at a checkout of the open-source CodeQL repository ought
   to work when querying one of the languages that live there.

   (Note: On Windows the path separator is ``;``).

.. option:: --additional-packs=<dir>[:<dir>...]

   [Advanced] If this list of directories is given, they will be searched
   for upgrades before the ones in ``--search-path``. The order between
   these doesn't matter; it is an error if a pack name is found in two
   different places through this list.

   This is useful if you're temporarily developing a new version of a
   pack that also appears in the default path. On the other hand it is
   *not recommended* to override this option in a config file; some
   internal actions will add this option on the fly, overriding any
   configured value.

   (Note: On Windows the path separator is ``;``).

Options to control evaluation of upgrade queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --[no-]tuple-counting

   [Advanced] Include tuple counts for each evaluation step in the query
   evaluator logs. (This can be useful for performance optimization of
   complex QL code).

.. option:: --timeout=<seconds>

   [Advanced] Set the timeout length for query evaluation, in seconds.

   The timeout feature is intended to catch cases where a complex query
   would take "forever" to evaluate. It is not an effective way to limit
   the total amount of time the query evaluation can take. The evaluation
   will be allowed to continue as long as each separately timed part of
   the computation completes within the timeout. Currently these
   separately timed parts are "RA stages" of the optimized query, but
   that might change in the future.

   If no timeout is specified, or is given as 0, no timeout will be set
   (except for :doc:`codeql test run <test-run>` where the default
   timeout is 5 minutes).

.. option:: -j, --threads=<num>

   Use this many threads to evaluate queries.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: --[no-]save-cache

   [Advanced] Aggressively write intermediate results to the disk cache.
   This takes more time and uses (much) more disk space, but may speed up
   the subsequent execution of similar queries.

.. option:: --[no-]keep-full-cache

   [Advanced] Don't clean up the disk cache after evaluation completes.
   This may save time if you're going to do :doc:`codeql dataset cleanup
   <dataset-cleanup>` or :doc:`codeql database cleanup
   <database-cleanup>` afterwards anyway.

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

.. option:: --external=<pred>=<file.csv>

   A CSV file that contains rows for external predicate *<pred>*.
   Multiple ``--external`` options can be supplied.

Options to control RAM usage of the upgrade process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: -M, --ram=<MB>

   Set total amount of RAM the query evaluator should be allowed to use.

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

