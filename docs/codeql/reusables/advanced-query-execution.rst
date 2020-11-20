.. pull-quote:: Other query-running commands

   Queries run with ``database analyze`` have strict :ref:`metadata requirements
   <including-query-metadata>`. You can also execute queries using the following
   plumbing-level subcommands:
   
   - `database run-queries <../codeql-cli-manual/database-run-queries.html>`__, which
     outputs non-interpreted results in an intermediate binary format called
     :ref:`BQRS <bqrs-file>`.
   - `query run <../codeql-cli-manual/query-run.html>`__, which will output BQRS files, or print
     results tables directly to the command line. Viewing results directly in
     the command line may be useful for iterative query development using the CLI.
   
   Queries run with these commands don't have the same metadata requirements.
   However, to save human-readable data you have to process each BQRS results
   file using the `bqrs decode <../codeql-cli-manual/bqrs-decode.html>`__ plumbing
   subcommand. Therefore, for most use cases it's easiest to use ``database
   analyze`` to directly generate interpreted results.