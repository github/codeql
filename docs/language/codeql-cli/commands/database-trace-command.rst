database trace-command
======================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database trace-command <options>... [--] <database> <command>...

Description
-----------

[Plumbing] Run a single command as part of a traced build.

This runs a single given command line under a tracer, thus possibly
performing some extraction, but does not finalize the resulting CodeQL
database.


Options
-------

.. program:: codeql database trace-command

.. option:: <database>

   [Mandatory] Path to the CodeQL database under construction. This must
   have been prepared for extraction with :doc:`codeql database init
   <database-init>`.

.. option:: <command>...

   [Mandatory] The command to run. This may consist of one or more
   arguments, which are used to create the process. It is recommended to
   pass the '--' argument before listing the command's arguments, in
   order to avoid confusion between its arguments and ours.

   The command is expected to exit with a status code of 0. Any other
   exit code is interpreted as a failure.

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

