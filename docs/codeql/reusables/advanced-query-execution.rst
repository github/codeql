.. pull-quote:: Other query-running commands

   Queries run with ``database analyze`` have strict :ref:`metadata requirements
   <including-query-metadata>`. You can also execute queries using the following
   plumbing-level subcommands:
   
   - `database run-queries <../manual/database-run-queries>`__, which
     outputs non-interpreted results in an intermediate binary format called
     :ref:`BQRS <bqrs-file>`.
   - `query run <../manual/query-run>`__, which will output BQRS files, or print
     results tables directly to the command line. Viewing results directly in
     the command line may be useful for iterative query development using the CLI.
   
   Queries run with these commands don't have the same metadata requirements.
   However, to save human-readable data you have to process each BQRS results
   file using the `bqrs decode <../manual/bqrs-decode>`__ plumbing
   subcommand. Therefore, for most use cases it's easiest to use ``database
   analyze`` to directly generate interpreted results.