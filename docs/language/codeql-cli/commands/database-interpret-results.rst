database interpret-results
==========================

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql database interpret-results --format=<format> --output=<output> [--threads=<num>] <options>... [--] <database> <file|dir|suite>...

Description
-----------

[Plumbing] Interpret computed query results into meaningful formats such
as SARIF or CSV.

The results should have been computed and stored in a CodeQL database
directory using :doc:`codeql database run-queries
<database-run-queries>`. (Usually you'd want to do these steps together,
by using :doc:`codeql database analyze <database-analyze>`).


Options
-------

.. program:: codeql database interpret-results

.. option:: <database>

   [Mandatory] Path to the CodeQL database that has been queried.

.. option:: <file|dir|suite>...

   [Mandatory] Repeat the specification of which queries were executed
   here.

   (In a future version it ought to be possible to omit this and instead
   interpret all results that are found in the database. That glorious
   future is not yet. Sorry.)

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

Options for finding QL packs (which may be necessary to interpret query suites)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

