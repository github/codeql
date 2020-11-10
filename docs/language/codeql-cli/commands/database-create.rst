database create
===============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database create --language=<lang> [--source-root=<dir>] [--threads=<num>] [--command=<command>] [--mode=<mode>] <options>... [--] <database>

Description
-----------

Create a CodeQL database for a source tree that can be analyzed using one
of the CodeQL products.


Options
-------

.. program:: codeql database create

.. option:: <database>

   [Mandatory] Path to the CodeQL database to create. This directory will
   be created, and *must not* already exist (but its parent must).

.. option:: -l, --language=<lang>

   [Mandatory] The language that the new database will be used to
   analyze.

   Use :doc:`codeql resolve languages <resolve-languages>` to get a list
   of the pluggable language extractors found on the search path.

.. option:: -s, --source-root=<dir>

   [Default: .] The root source code directory. In many cases, this will
   be the checkout root. Files within it are considered to be the primary
   source files for this database. In some output formats, files will be
   referred to by their relative path from this directory.

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

.. option:: -j, --threads=<num>

   Use this many threads for the import operation, and pass it as a hint
   to any invoked build commands.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: -c, --command=<command>

   For compiled languages, build commands that will cause the compiler to
   be invoked on the source code to analyze. These commands will be
   executed under an instrumentation environment that allows analysis of
   generated code and (in some cases) standard libraries.

   If no build command is specified, the command attempts to figure out
   automatically how to build the source tree, based on heuristics from
   the selected language pack.

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

Build command customization options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --working-dir=<dir>

   [Advanced] The directory in which the specified command should be
   executed. If this argument is not provided, the command is executed in
   the value of ``--source-root`` passed to :doc:`codeql database create
   <database-create>`, if one exists. If no ``--source-root`` argument is
   provided, the command is executed in the current working directory.

.. option:: --no-tracing

   [Advanced] Do not trace the specified command, instead relying on it
   to produce all necessary data directly.

.. option:: --compiler-spec=<spec-file>

   [Advanced] The path to a compiler specification file. It may be used
   to pick out compiler processes that run as part of the build command,
   and trigger the execution of other tools. The extractors will provide
   default compiler specifications that should work in most situations.

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

