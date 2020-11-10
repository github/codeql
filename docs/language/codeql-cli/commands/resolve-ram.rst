resolve ram
===========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve ram [--ram=<MB>] <options>...

Description
-----------

[Deep plumbing] Prepare RAM options.

This deep plumbing command prepares appropriate command-line options to
start a subcommand that will execute a QL query evaluator. It knows
appropriate heuristics for deciding whether to keep some of the
configured memory outside the Java heap.

In particular, this should be used to find appropriate ``-J-Xmx`` and
``--off-heap-ram`` options before staring a query server based on a
desired *total* RAM amount.


Options
-------

.. program:: codeql resolve ram

.. option:: --format=<fmt>

   Select output format. Choices include:

   ``lines`` (default): print commmand-line arguments on one line each.

   ``json``: print them as a JSON array.

Options from the invoking command's command line
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

