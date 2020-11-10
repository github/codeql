query compile
=============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql query compile [--check-only] [--threads=<num>] [--ram=<MB>] <options>... [--] <file>...

Description
-----------

Compile or check QL code.

Compile one or more queries. Usually the main outcome of this command is
that the compiled version of the query is written to a *compilation
cache* where it will be found when the query is later executed. Other
output options are mostly for debugging.


Options
-------

.. program:: codeql query compile

.. option:: <file>...

   [Mandatory] Queries to compile. Each argument is one of:

   * A .ql file to compile.

   * A directory which will be searched recursively for .ql files.

   * A .qls file that defines a particular set of queries.

   * The basename of a "well-known" .qls file exported by one of the
     installed QL packs.

.. option:: -n, --check-only

   Just check that the QL is valid and print any errors; do not actually
   optimize and store a query plan. This can be much faster than a full
   compilation.

.. option:: --[no-]dump-dil

   [Advanced] Print the optimized DIL intermediate representation to
   standard output while compiling.

   When JSON output is selected, the DIL will be represented as an array
   of single-line strings, with some wrapping to identify which query is
   being compiled.

.. option:: --[no-]dump-ra

   [Advanced] Print the optimized RA query plan to standard output while
   compiling.

   When JSON output is selected, the RA will be represented as an array
   of single-line strings, with some wrapping to identify which query is
   being compiled.

.. option:: --format=<fmt>

   Select output format, either ``text`` (the default) or ``json``.

.. option:: -j, --threads=<num>

   Use this many threads to compile queries.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: -M, --ram=<MB>

   Set total amount of RAM the compiler should be allowed to use.

QL variant and compiler control options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --warnings=<mode>

   How to handle warnings from the QL compiler. One of:

   ``hide``: Suppress warnings.

   ``show`` (default): Print warnings but continue with compilation.

   ``error``: Treat warnings as errors.

.. option:: --[no-]fast-compilation

   [Advanced] Omit particularly slow optimization steps.

.. option:: --[no-]local-checking

   Only perform initial checks on the part of the QL source that is used.

.. option:: --no-metadata-verification

   Don't check embedded query metadata in QLDoc comments for validity.

.. option:: --compilation-cache-size=<MB>

   [Advanced] Override the default maximum size for a compilation cache
   directory.

Options to set up compilation environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

.. option:: --library-path=<dir>[:<dir>...]

   [Advanced] An optional list of directories that will be added to the
   raw import search path for QL libraries. This should only be used if
   you're using QL libraries that have not been packaged as QL packs.

   (Note: On Windows the path separator is ``;``).

.. option:: --dbscheme=<file>

   [Advanced] Explicitly define which dbscheme queries should be compiled
   against. This should only be given by callers that are extremely sure
   what they're doing.

.. option:: --compilation-cache=<dir>

   [Advanced] Specify an additional directory to use as a compilation
   cache.

.. option:: --no-default-compilation-cache

   [Advanced] Don't use compilation caches in standard locations such as
   in the QL pack containing the query or in the CodeQL toolchain
   directory.

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

