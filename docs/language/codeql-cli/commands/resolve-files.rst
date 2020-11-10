resolve files
=============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve files <options>... [--] <dir>

Description
-----------

[Deep plumbing] Expand a set of file inclusion/exclusion globs.

This plumbing command is responsible for expanding the command-line
parameters of subcommands that operate on multiple files, identified by
their paths. By default, all files are included, and so running this
command without any filter arguments will collect all files in a
directory.

The ``--include``, ``--exclude``, and ``--prune`` options all take glob
patterns, which can use the following wildcard characters:

* A single "?" matches any character other than a forward/backward slash;
* A single "\*" matches any number of characters other than a
  forward/backward slash;
* The pattern "\*\*" matches zero or more complete directory components.


Options
-------

.. program:: codeql resolve files

.. option:: <dir>

   The directory to be searched.

.. option:: --format=<fmt>

   Select output format. Choices include ``text`` (default) and ``json``.

Options for limiting the set of collected files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

