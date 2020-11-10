database init
=============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database init --language=<lang> --source-root=<dir> <options>... [--] <database>

Description
-----------

[Plumbing] Create an empty CodeQL database.

Create a skeleton structure for a CodeQL database that doesn't have a raw
QL dataset yet, but is ready for running extractor steps. After this
command completes, run one or more :doc:`codeql database trace-command
<database-trace-command>` commands followed by :doc:`codeql database
finalize <database-finalize>` to prepare the database for querying.

(Part of what this does is resolve the location of the appropriate
language pack and store it in the database metadata, such that it won't
need to be redone at each extraction command. It is not valid to switch
extractors in the middle of an extraction operation anyway.)


Options
-------

.. program:: codeql database init

.. option:: <database>

   [Mandatory] Path to the CodeQL database to create. This directory will
   be created, and *must not* already exist (but its parent must).

.. option:: -s, --source-root=<dir>

   [Mandatory]  The root source code directory. In many cases, this will
   be the checkout root. Files within it are considered to be the primary
   source files for this database. In some output formats, files will be
   referred to by their relative path from this directory.

.. option:: --[no-]allow-missing-source-root

   [Advanced] Proceed even if the specified source root does not exist.

Extractor selection options
~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

