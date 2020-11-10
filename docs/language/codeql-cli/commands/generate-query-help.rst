generate query-help
===================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql generate query-help --format=<format> [--output=<dir|file>] <options>... [--] <qhelp|query|dir|suite>...

Description
-----------

Generate end-user query help from .qhelp files.

Options
-------

.. program:: codeql generate query-help

.. option:: <qhelp|query|dir|suite>...

   [Mandatory] Query help files to render. Each argument is one of:

   * A .qhelp file to render.

   * A .ql file with a corresponding .qhelp file to render.

   * A directory that will be searched recursively for .ql files with
     corresponding .qhelp files.

   * A .qls file that defines a particular set of queries.

   * The basename of a "well-known" .qls file exported by one of the
     installed QL packs.

.. option:: --format=<format>

   [Mandatory] The format in which to render the documentation.

   Currently, must always have the value ``markdown``. Other options may
   be offered in the future.

.. option:: -o, --output=<dir|file>

   A path to write the rendered documentation to. Usually this is a
   directory into which the rendered output will be written.

   If only a single .qhelp or .ql file is provided, and no directory
   exists at the output path, the output will be written to a single file
   at that path.

   If no output path is provided, only a single .qhelp or .ql file will
   be accepted, and the output will be written to stdout.

   If an output directory is used, filenames *within* the output
   directory will be derived from the .qhelp file names.

.. option:: --warnings=<mode>

   How to handle warnings from the query help renderer. One of:

   ``hide``: Suppress warnings.

   ``show`` (default): Print warnings but continue with rendering.

   ``error``: Treat warnings as errors.

Options for finding QL packs (which may be necessary to resolve query suites)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which QL packs may be found. Each
   directory can either be a QL pack (or bundle of packs containing a
   ``.codeqlmanifest.json`` file at the root) or the immediate parent of
   one or more such directories.

   If the path contains more than directory, their order defines
   precedence between them: when a pack name that must be resolved is
   matched in more than one of the directory trees, the one given first
   wins.

   Pointing this at a checkout of the open-source CodeQL repository ought
   to work when querying one of the languages that live there.

   If you have have checked out the CodeQL reposity as a sibling of the
   unpacked CodeQL toolchain, you don't need to give this option; such
   sibling directories will always be searched for QL packs that cannot
   be found otherwise. (If this default does not work, it is strongly
   recommended to set up ``--search-path`` once and for all in a per-user
   configuration file).

   (Note: On Windows the path separator is ``;``).

.. option:: --additional-packs=<dir>[:<dir>...]

   If this list of directories is given, they will be searched for packs
   before the ones in ``--search-path``. The order between these doesn't
   matter; it is an error if a pack name is found in two different places
   through this list.

   This is useful if you're temporarily developing a new version of a
   pack that also appears in the default path. On the other hand it is
   *not recommended* to override this option in a config file; some
   internal actions will add this option on the fly, overriding any
   configured value.

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

