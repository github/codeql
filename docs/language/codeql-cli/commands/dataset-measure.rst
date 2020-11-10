dataset measure
===============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql dataset measure --output=<file> [--threads=<num>] <options>... [--] <dataset>

Description
-----------

[Plumbing] Collect statistics about the relations in a particular
dataset.

This command is typically only used when developing a CodeQL extractor,
after a change that affects the database schema and which therefore needs
to have an accompanying change to the statistics used by the query
optimizer.

Options
-------

.. program:: codeql dataset measure

.. option:: <dataset>

   [Mandatory] Path to the raw QL dataset to measure.

.. option:: -o, --output=<file>

   [Mandatory] The output file to which statistics should be written,
   typically with a '.dbscheme.stats' extension.

.. option:: -j, --threads=<num>

   The number of concurrent threads to use.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

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

