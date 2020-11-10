query run
=========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql query run (--database=<database> | --dataset=<dataset>) [--output=<file.bqrs>] [--threads=<num>] [--ram=<MB>] <options>... [--] <file.ql>

Description
-----------

Run a single query.

This command runs single query against a CodeQL database or raw QL
dataset.

By default the result of the query will be displayed on the terminal in a
human-friendly rendering. If you want to do further processing of the
results, we strongly recommend using the ``--output`` option to write the
results to a file in an intermediate binary format, which can then be
unpacked into various more machine-friendly representations by
:doc:`codeql bqrs decode <bqrs-decode>`.

If your query produces results in a form that can be interpreted as
source-code alerts, you may find :doc:`codeql database analyze
<database-analyze>` a more convenient way to run it. In particular,
:doc:`codeql database analyze <database-analyze>` can produce output in
the SARIF format, which can be used with an variety of alert viewers.

To run multiple queries in parallel, see :doc:`codeql database
run-queries <database-run-queries>`.


Options
-------

.. program:: codeql query run

.. option:: <file.ql>

   [Mandatory] QL source of the query to execute.

.. option:: -o, --output=<file.bqrs>

   A file where to output from the query will be written in BQRS format.

Options to select what to query
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Exactly one of these options must be given.

.. option:: -d, --database=<database>

   Path to a CodeQL database to query.

.. option:: --dataset=<dataset>

   [Advanced] Path to a raw QL dataset to query.

Options to control the query evaluator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Options to control RAM usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: -M, --ram=<MB>

   Set total amount of RAM the query evaluator should be allowed to use.

Options to control QL compilation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --warnings=<mode>

   How to handle warnings from the QL compiler. One of:

   ``hide``: Suppress warnings.

   ``show`` (default): Print warnings but continue with compilation.

   ``error``: Treat warnings as errors.

.. option:: --[no-]fast-compilation

   [Advanced] Omit particularly slow optimization steps.

.. option:: --[no-]local-checking

   Only perform initial checks on the part of the QL source that is used.

.. option:: --no-metadata-verification

   Don't check embedded query metadata in QLDoc comments for validity.

.. option:: --compilation-cache-size=<MB>

   [Advanced] Override the default maximum size for a compilation cache
   directory.

Options to set up compilation environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which QL packs may be found. Each
   directory can either be a QL pack (or bundle of packs containing a
   ``.codeqlmanifest.json`` file at the root) or the immediate parent of
   one or more such directories.

   If the path contains more than directory, their order defines
   precedence between them: when a pack name that must be resolved is
   matched in more than one of the directory trees, the one given first
   wins.

   Pointing this at a checkout of the open-source CodeQL repository ought
   to work when querying one of the languages that live there.

   If you have have checked out the CodeQL reposity as a sibling of the
   unpacked CodeQL toolchain, you don't need to give this option; such
   sibling directories will always be searched for QL packs that cannot
   be found otherwise. (If this default does not work, it is strongly
   recommended to set up ``--search-path`` once and for all in a per-user
   configuration file).

   (Note: On Windows the path separator is ``;``).

.. option:: --additional-packs=<dir>[:<dir>...]

   If this list of directories is given, they will be searched for packs
   before the ones in ``--search-path``. The order between these doesn't
   matter; it is an error if a pack name is found in two different places
   through this list.

   This is useful if you're temporarily developing a new version of a
   pack that also appears in the default path. On the other hand it is
   *not recommended* to override this option in a config file; some
   internal actions will add this option on the fly, overriding any
   configured value.

   (Note: On Windows the path separator is ``;``).

.. option:: --library-path=<dir>[:<dir>...]

   [Advanced] An optional list of directories that will be added to the
   raw import search path for QL libraries. This should only be used if
   you're using QL libraries that have not been packaged as QL packs.

   (Note: On Windows the path separator is ``;``).

.. option:: --dbscheme=<file>

   [Advanced] Explicitly define which dbscheme queries should be compiled
   against. This should only be given by callers that are extremely sure
   what they're doing.

.. option:: --compilation-cache=<dir>

   [Advanced] Specify an additional directory to use as a compilation
   cache.

.. option:: --no-default-compilation-cache

   [Advanced] Don't use compilation caches in standard locations such as
   in the QL pack containing the query or in the CodeQL toolchain
   directory.

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

