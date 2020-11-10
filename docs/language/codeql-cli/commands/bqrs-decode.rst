bqrs decode
===========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql bqrs decode [--output=<file>] [--result-set=<name>] [--sort-key=<col>[,<col>...]] <options>... [--] <file>

Description
-----------

Convert result data from BQRS into other forms.

The decoded output will be written to standard output, unless the
``--output`` option is specified.


Options
-------

.. program:: codeql bqrs decode

.. option:: <file>

   [Mandatory] BQRS file to decode.

.. option:: -o, --output=<file>

   The file to write the desired output to.

.. option:: -r, --result-set=<name>

   Select a particular result set from the BQRS file to decode. The
   available results sets can be listed by :doc:`codeql bqrs info
   <bqrs-info>`.

   If no result set is selected, all result sets will be decoded,
   provided the selected output format and processing options support
   that. Otherwise an error results.

.. option:: -k, --sort-key=<col>[,<col>...]

   Sort the selected result set by the indicated columns.

.. option:: --sort-direction=<direction>[,<direction>...]

   Sort the selected result set using the indicated sort directions.

   If sort directions are not specified, then ascending order will be
   used for all columns.

Output format options
~~~~~~~~~~~~~~~~~~~~~

.. option:: --format=<fmt>

   Select output format. Choices include:

   ``text`` (default): A human-readable plain text table.

   ``csv``: Comma-separated values.

   ``json``: Streaming JSON.

   ``bqrs``: BQRS. This must be used with ``--output``. Most useful
   together with ``--sort-key``.

.. option:: --no-titles

   Omit column titles for ``text`` and ``csv`` formats

.. option:: --entities=<fmt>[,<fmt>...]

   [Advanced] Control how result columns of entity type are shown. A
   comma-separated list of the following choices:

   ``url``: A URL referring to a source location, if the query was
   compiled to produce such URLs for entitity types.

   ``string``: A string computed by the toString() method in QL, if the
   query was compiled to produce such strings for the column.

   ``id``: The internal ID of the entity, which may not be informative.

   ``all``: Show columns with all the information the BQRS file provides.

   All the selected options are shown, if possible.

Options for pagination (for use by interactive front-ends)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --rows=<num>

   [Advanced] Output this many rows from the selected resultset, starting
   at the top, or at the location given by ``--start-at``.

.. option:: --start-at=<offset>

   [Advanced] Start printing the row defined at a particular byte offset
   in the BQRS file. The offset must be gotten from :doc:`codeql bqrs
   info <bqrs-info>`, or from the "next" pointer found in JSON output
   from a previous invocation with ``--rows`` set. Other offsets are
   likely to produce nonsense output and/or explicit errors.

   Must always be used together with ``--rows``, and is incompatible with
   ``--sort-key``.

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

