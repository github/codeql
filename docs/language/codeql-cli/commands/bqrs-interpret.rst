bqrs interpret
==============

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql bqrs interpret --format=<format> --output=<output> -t=<String=String> [--threads=<num>] [--source-archive=<sourceArchive>] [--source-location-prefix=<sourceLocationPrefix>] <options>... [--] <bqrs-file>

Description
-----------

[Plumbing] Interpret data in a single BQRS.

A command that interprets a single BQRS file according to the provided
metadata and generates output in the specified format.


Options
-------

.. program:: codeql bqrs interpret

.. option:: <bqrs-file>

   [Mandatory] The BQRS file to interpret.

.. option:: --format=<format>

   [Mandatory] The format in which to write the results. One of:

   ``csv``: Formatted comma-separated values, including columns with both
   rule and alert metadata.

   ``sarif-latest``: Static Analysis Results Interchange Format (SARIF),
   a JSON-based format for describing static analysis results. This
   format option uses the most recent supported version (v2.1.0). This
   option is not suitable for use in automation as it will produce
   different versions of SARIF between different CodeQL versions.

   ``sarifv1``: SARIF v1.0.0.

   ``sarifv2``: SARIF v2.0.0 (Committee Specification Draft 1).

   ``sarifv2.1.0``: SARIF v2.1.0.

   ``graphtext``: A textual format representing a graph. Only compatible
   with queries with @kind graph.

   ``dgml``: Directed Graph Markup Language, an XML-based format for
   describing graphs. Only compatible with queries with @kind graph.

.. option:: -o, --output=<output>

   [Mandatory] The output path to write results to. For graph formats
   this should be a directory, where one result will be written per
   query.

.. option:: -t=<String=String>

   [Mandatory] A query metadata key value pair. Repeat for each piece of
   metadata.At least the keys 'kind' and 'id' must be specified. Keys do
   not need to be prefixed with @.

.. option:: --max-paths=<maxPaths>

   The maximum number of paths to produce for each alert with paths.
   (Default: 4)

.. option:: --[no-]sarif-add-file-contents

   [SARIF v2 formats only] Include the full file contents for all files
   referenced in at least one result.

.. option:: --[no-]sarif-add-snippets

   [SARIF v2.1.0 and later only] Include code snippets for each location
   mentioned in the results, with two lines of context before and after
   the reported location.

.. option:: --[no-]sarif-multicause-markdown

   [SARIF v2.1.0 and later only] For akerts that have multiple causes,
   include them as a Markdown-formatted itemized list in the output in
   addition to as a plain string.

.. option:: --no-group-results

   [SARIF formats only] Produce one result per message, rather than one
   result per unique location.

.. option:: --csv-location-format=<csvLocationFormat>

   The format in which to produce locations in CSV output. One of: uri,
   line-column, offset-length. (Default: line-column)

.. option:: -j, --threads=<num>

   The number of threads used for computing paths.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

.. option:: --sarif-run-property=<String=String>

   [SARIF v2.1.0 and later only] A key value pair to add to the generated
   SARIF 'run' property bag. Can be repeated.

.. option:: --column-kind=<columnKind>

   [SARIF v2.1.0 and later only] The column kind used to interpret
   location columns. One of: utf8, utf16, utf32, bytes.

.. option:: --[no-]unicode-new-lines

   [SARIF v2.1.0 and later only] Whether the unicode newline characters
   LS (Line Separator, U+2028) and PS (Paragraph Separator, U+2029) are
   considered as new lines when interpreting location line numbers.

Source archive options - must be given together or not at all
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: -s, --source-archive=<sourceArchive>

   The directory or zip file containing the source archive.

.. option:: -p, --source-location-prefix=<sourceLocationPrefix>

   The file path on the original file system where the source code was
   stored.

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

