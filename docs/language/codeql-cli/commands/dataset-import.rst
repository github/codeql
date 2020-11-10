dataset import
==============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql dataset import --dbscheme=<file> [--threads=<num>] <options>... [--] <dataset> <trap>...

Description
-----------

[Plumbing] Import a set of TRAP files to a raw dataset.

Create a dataset by populating it with TRAP files, or add data from TRAP
files to an existing dataset. Updating a dataset is only possible if it
has the correct dbscheme *and* its ID pool has been preserved from the
initial import.


Options
-------

.. program:: codeql dataset import

.. option:: <dataset>

   [Mandatory] Path to the raw QL dataset to create or update. The
   directory will be created if it doesn't already exist.

.. option:: <trap>...

   Paths to .trap(.gz) files to import, or to directories that will be
   recursively scanned for .trap(.gz) files. If no files are given, an
   empty dataset will be created.

.. option:: -S, --dbscheme=<file>

   [Mandatory] The dbscheme definition that describes the TRAP files you
   want to import.

.. option:: -j, --threads=<num>

   Use this many threads for the import operation.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: --[no-]check-unused-labels

   [Advanced] Report errors for unused labels.

.. option:: --[no-]check-repeated-labels

   [Advanced] Report errors for repeated labels.

.. option:: --[no-]check-redefined-labels

   [Advanced] Report errors for redefined labels.

.. option:: --[no-]check-use-before-definition

   [Advanced] Report errors for labels used before they're defined.

.. option:: --[no-]include-location-in-star

   [Advanced] Construct entity IDs that encode the location in the TRAP
   file they came from. Can be useful for debugging of TRAP generators,
   but takes up a lot of space in the dataset.

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

