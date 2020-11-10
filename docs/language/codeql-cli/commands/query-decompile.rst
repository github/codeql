query decompile
===============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql query decompile [--output=<file>] <options>... [--] <file>

Description
-----------

[Plumbing] Read an intermediate representation of a compiled query from a
.qlo file.

The code will be written to standard output, unless the ``--output``
option is specified.


Options
-------

.. program:: codeql query decompile

.. option:: <file>

   [Mandatory] QLO file to read from.

.. option:: -o, --output=<file>

   The file to write the desired output to.

.. option:: --kind=<kind>

   The kind of the intermediate representation to read. The options are:

   ``dil``: A Datalog intermediate representation.

   ``ra``: A relational algebra intermediate representation. This is used
   by the query evaluation phase.

   ``bytecode``: Show the raw (uncompressed) bytecode from the .qlo file.
   Mostly useful for debugging the compiler/evaluator.

   The default is\ ``dil`` if the query was compiled with
   ``--include-dil-in-qlo`` and ``ra`` otherwise

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

