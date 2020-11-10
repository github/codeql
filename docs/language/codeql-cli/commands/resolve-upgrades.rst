resolve upgrades
================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql resolve upgrades --dbscheme=<file> <options>...

Description
-----------

[Deep plumbing] Determine upgrades to run for a raw dataset.

Determine which upgrades need to be performed on a particular raw QL
dataset to bring it up to the state of the configured QL libraries. This
computation is part of what happens during an ordinary database upgrade,
and is exposed as a separate plumbing command in order to (a) help with
troubleshooting, and (b) provide a starting point for modifying the path
in extraordinary cases where exact control is needed.


Options
-------

.. program:: codeql resolve upgrades

.. option:: --dbscheme=<file>

   [Mandatory] The *current* dbscheme of the dataset we want to upgrade.

.. option:: --format=<fmt>

   Select output format. Choices include:

   ``lines`` (default): print upgrade scripts on one line each.

   ``json``: print a JSON array of upgrade script paths.

.. option:: --just-check

   Don't print any output, but exit with code 0 if there are upgrades to
   do, and code 1 if there are none.

Options from the invoking command's command line
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --search-path=<dir>[:<dir>...]

   A list of directories under which QL packs containing upgrade recipes
   may be found. Each directory can either be a QL pack (or bundle of
   packs containing a ``.codeqlmanifest.json`` file at the root) or the
   immediate parent of one or more such directories.

   If the path contains directories trees, their order defines precedence
   between them: if a pack name that must be resolved is matched in more
   than one of the directory trees, the one given first wins.

   Pointing this at a checkout of the open-source CodeQL repository ought
   to work when querying one of the languages that live there.

   (Note: On Windows the path separator is ``;``).

.. option:: --additional-packs=<dir>[:<dir>...]

   [Advanced] If this list of directories is given, they will be searched
   for upgrades before the ones in ``--search-path``. The order between
   these doesn't matter; it is an error if a pack name is found in two
   different places through this list.

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

