database index-files
====================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database index-files --language=<lang> <options>... [--] <database>

Description
-----------

[Plumbing] Index standalone files with a given CodeQL extractor.

This command selects a set of files under its working directory, and
applies the given extractor to them. By default, all files are selected.
Typical invocations will specify options to restrict the set of included
files.

The ``--include``, ``--exclude``, and ``--prune`` options all take glob
patterns, which can use the following wildcard characters:

* A single "?" matches any character other than a forward/backward slash;
* A single "\*" matches any number of characters other than a
  forward/backward slash;
* The pattern "\*\*" matches zero or more complete directory components.


Options
-------

.. program:: codeql database index-files

.. option:: <database>

   [Mandatory] Path to the CodeQL database under construction. This must
   have been prepared for extraction with :doc:`codeql database init
   <database-init>`.

.. option:: -l, --language=<lang>

   [Mandatory] The extractor that should be used to index matching files.

.. option:: --working-dir=<dir>

   [Advanced] The directory in which the specified command should be
   executed. If this argument is not provided, the command is executed in
   the value of ``--source-root`` passed to :doc:`codeql database create
   <database-create>`, if one exists. If no ``--source-root`` argument is
   provided, the command is executed in the current working directory.

Options for limiting the set of indexed files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --include-extension=<.ext>

   If one or more extensions are explicitly included, only files whose
   names end in one of those extensions will be reported. Typically, you
   should include the dot before the extension. For example, passing
   ``--include-extension .xml`` will collect only files with the ".xml"
   extension.

.. option:: --include=<glob>

   If one or more ``--include`` options are specified, then files will
   only be reported if their paths relative to the search directory match
   at least one of the provided globs.

.. option:: --exclude=<glob>

   If one or more ``--exclude`` options are specified, then files will be
   excluded when their paths relative to the search directory match any
   of the provided globs, even if they would be otherwise included.

.. option:: --prune=<glob>

   If one or more ``--prune`` options are specified, then directories
   will be excluded from consideration if they match any of the provided
   globs. The directory traversal will not enter such directories at all,
   and so files nested within them are ignored, even if they would
   otherwise be included.

.. option:: --size-limit=<bytes>

   If a size limit is specified, then files whose size on disk is greater
   than the limit will not be reported. The size is given in bytes,
   though suffixes of "k", "m" or "g" can be used to select kilobytes,
   megabytes, or gigabytes respectively.

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

