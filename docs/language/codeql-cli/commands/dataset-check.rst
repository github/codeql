dataset check
=============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql dataset check <options>... [--] <dataset>

Description
-----------

[Plumbing] Check a particular dataset for internal consistency.

This command is most commonly useful to developers of CodeQL extractors,
as it validates the data produced by the extractor. It may also be useful
if queries against a database are giving inconsistent results, to rule
out issues in the underlying data as the cause.

Options
-------

.. program:: codeql dataset check

.. option:: <dataset>

   [Mandatory] Path to the raw QL dataset to check.

.. option:: --failing-exitcode=<code>

   [Advanced] Set the exit code to produce if any failures are
   encountered. Usually 1, but tooling that parses the output may find it
   useful to set it to 0.

.. option:: --format=<fmt>

   Select output format. Possible choices:

   * ``text`` for a human-readable textual rendering (default),

   * ``json`` for a streamed JSON array of objects, and

   * ``jsonz`` for a stream of zero-terminated JSON objects.

.. option:: --[no-]precise-locations

   [Advanced] Expend extra effort to compute precise locations for
   inconsistencies. This will take more time, but may make it easier to
   debug extractor behaviour.

.. option:: --max-resolve-depth=<n>

   [Advanced] The maximum depth to which IDs should be resolved to
   explain inconsistencies. (Default: 3)

.. option:: --max-errors-per-checker=<n>

   The maximum number of inconsistency errors of each kind that should be
   reported explicitly. (Default: 5)

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

