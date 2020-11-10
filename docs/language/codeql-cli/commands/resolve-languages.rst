resolve languages
=================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve languages <options>...

Description
-----------

List installed CodeQL extractor packs.

When run with JSON output selected, this command can report multiple
locations for each extractor pack name. When that happens, it means that
the pack has conflicting locations within a single search element, so it
cannot actually be resolved. The caller may use the actual locations to
format an appropriate error message.


Options
-------

.. program:: codeql resolve languages

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

.. option:: --format=<fmt>

   Select output format. Choices include ``text`` (default) and ``json``.

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

