bqrs info
=========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql bqrs info <options>... [--] <file>

Description
-----------

Display metadata for a BQRS file.

This command displays an overview of the data contained in the compact
binary BQRS file that is the result of executing a query. It shows the
names and sizes of each result set (table) in the BQRS file, and the
column types of each result set.

It can also optionally precompute offsets for using the pagination
options of :doc:`codeql bqrs decode <bqrs-decode>`. This is mainly useful
for IDE plugins.


Options
-------

.. program:: codeql bqrs info

.. option:: <file>

   [Mandatory] BQRS file to show information about.

.. option:: --format=<fmt>

   Select ouput format, either ``text`` (default) or ``json``.

Supporting pagination in :doc:`codeql bqrs decode <bqrs-decode>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --paginate-rows=<num>

   [Advanced] When given together with ``--format=json``, compute a table
   of byte offsets that can later be given to the ``--start-at`` option
   of :doc:`codeql bqrs decode <bqrs-decode>`, to start streaming results
   at positions 0, *<num>*, 2\*\ *<num>*, and so forth.

.. option:: --paginate-result-set=<name>

   [Advanced] Only process ``--paginate-rows`` for result sets with this
   name. (If the name does not match any result set, ``--paginate-rows``
   is a no-op).

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

