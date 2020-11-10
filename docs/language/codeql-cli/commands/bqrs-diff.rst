bqrs diff
=========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql bqrs diff <options>... [--] <file1> <file2>

Description
-----------

Compute the difference between two result sets.


Options
-------

.. program:: codeql bqrs diff

.. option:: <file1>

   [Mandatory] First BQRS file to compare.

.. option:: <file2>

   [Mandatory] Second BQRS file to compare.

.. option:: --left=<file>

   Write rows only present in ``file1`` to this file.

.. option:: --right=<file>

   Write rows only present in ``file2`` to this file.

.. option:: --both=<file>

   Write rows present in both ``file1`` and ``file2`` to this file.

.. option:: --retain-result-sets=<result-set>[,<result-set>...]

   Comma-separated list of result set names to copy directly to the
   corresponding output instead of comparing. If --both is given, that
   output is taken from ``file1``. Defaults to 'nodes,edges' to simplify
   handling of path-problem results.

.. option:: --[no-]compare-internal-ids

   [Advanced] Include internal entity IDs in the comparison. Entity IDs
   are not comparable across databases, but for result sets that
   originate from the same database this can help distinguish entities
   with the same location and label.

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

