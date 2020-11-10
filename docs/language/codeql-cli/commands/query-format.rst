query format
============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql query format [--output=<file>] [--in-place] [--backup=<ext>] <options>... [--] <file>...

Description
-----------

Autoformat QL source code.


Options
-------

.. program:: codeql query format

.. option:: <file>...

   One or more ``.ql`` or ``.qll`` source files to autoformat. A dash can
   be speficied to read from standard input.

.. option:: -o, --output=<file>

   Write the formatted QL code to this file instead of the standard
   output stream. Must not be given if there is more than one input.

.. option:: -i, --[no-]in-place

   Overwrite each input file with a formatted version of its content.

.. option:: --[no-]check-only

   Instead of writing output, exit with status 1 if any input file
   *differs* from its correct formatting. A message telling which file it
   was will be printed to standard error unless you also give ``-qq``.

.. option:: -b, --backup=<ext>

   When writing a file that already exists, rename the existing file to a
   backup by appending this extension to its name. If the backup file
   already exists, it will be silently deleted.

.. option:: --no-syntax-errors

   If an input file is not syntactically correct QL, pretend that it is
   already correctly formatted. (Usually such a file causes the command
   to terminate with an error message).

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

