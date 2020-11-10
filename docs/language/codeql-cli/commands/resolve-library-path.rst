resolve library-path
====================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve library-path (--query=<qlfile> | --root-pack=<pkgname>) <options>...

Description
-----------

[Deep plumbing] Determine QL library path and dbscheme for a query.

Determine which QL library path a particular query should be compiled
against. This computation is implicit in several subcommands that may
need to compile queries. It is exposed as a separate plumbing command in
order to (a) help with troubleshooting, and (b) provide a starting point
for modifying the path in extraordinary cases where exact control is
needed.

The command will also detect a language and dbscheme to compile a query
against, as these may also depend on autodetecting the language of a QL
query.

**The command is deeply internal and its behavior or existence may change
without much notice as the QL language ecosystem evolves.**


Options
-------

.. program:: codeql resolve library-path

.. option:: --[no-]find-extractors

   [Advanced] Include in the output a summary of ``extractor`` fields
   from the QL packs that the query depends on. This is used only for a
   few rare internal cases, and may require more work to compute, so is
   not turned on by default.

.. option:: --format=<fmt>

   Select output format. Choices include:

   ``lines`` (default): print command line arguments on one line each.

   ``json``: print a JSON object with all the data.

   ``path``: print just the computed library path.

   ``dbscheme``: print just the detected dbscheme.

   ``cache``: print the default compilation cache location, or nothing if
   none.

Options from the invoking command's command line
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Options for specifying what we're about to compile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Exactly one of these options must be given.

.. option:: --query=<qlfile>

   The path to the QL file we want to compile.

   Its directory and parent directories will be searched for qlpack.yml
   or legacy queries.xml files to determine necessary packs.

.. option:: --root-pack=<pkgname>

   [Advanced] The declared name of a pack to use as root for dependency
   resolution.

   This is used when the pack can be found by name somewhere in the
   search path. If you know the *disk location* of your desired root
   package, pretend it contains a .ql file and use ``--query`` instead.

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

