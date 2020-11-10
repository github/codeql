resolve extractor
=================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve extractor --language=<lang> <options>...

Description
-----------

[Deep plumbing] Determine the extractor pack to use for a given language.


Options
-------

.. program:: codeql resolve extractor

.. option:: -l, --language=<lang>

   [Mandatory] The language that the new database will be used to
   analyze.

   Use :doc:`codeql resolve languages <resolve-languages>` to get a list
   of the pluggable language extractors found on the search path.

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which extractor packs may be found. The
   directories can either be the extractor packs themselves or
   directories that contain extractors as immediate subdirectories.

   If the path contains multiple directory trees, their order defines
   precedence between them: if the target language is matched in more
   than one of the directory trees, the one given first wins.

   The extractors bundled with the CodeQL toolchain itself will always be
   found, but if you need to use separately distributed extractors you
   need to give this option (or, better yet, set up ``--search-path`` in
   a per-user configuration file).

   (Note: On Windows the path separator is ``;``).

.. option:: --just-check

   Don't print any output, but exit with code 0 if the extractor is
   found, and code 1 otherwise.

.. option:: --format=<fmt>

   Select output format. Choices include:

   ``text`` (default): print the path to the found extractor pack to
   standard output.

   ``json``: print it as a JSON string.

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

