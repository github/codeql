test run
========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql test run [--threads=<num>] [--ram=<MB>] <options>... [--] <test|dir>...

Description
-----------

Run unit tests for QL queries.

Options
-------

.. program:: codeql test run

.. option:: <test|dir>...

   Each argument is one of:

   * A ``.ql`` or ``.qlref`` file that defines a test to run.

   * A directory which will be searched recursively for tests to run.

.. option:: --failing-exitcode=<code>

   [Advanced] Set the exit code to produce if any failures are
   encountered. Usually 1, but tooling that parses the output may find it
   useful to set it to 0.

.. option:: --format=<fmt>

   Select output format. Possible choices:

   * ``text`` for a human-readable textual rendering (default),

   * ``json`` for a streamed JSON array of objects, and

   * ``jsonz`` for a stream of zero-terminated JSON objects.

.. option:: --[no-]keep-databases

   [Advanced] Preserve the databases extracted to run the test queries,
   even where all tests in a directory pass. (The database will always be
   left present when there are tests that *fail*).

.. option:: --[no-]fast-compilation

   [Advanced] Omit particularly slow optimization steps when compiling
   test queries. (Beware: there are many of the standard tests where this
   makes *execution* of the test infeasibly slow).

.. option:: --[no-]learn

   [Advanced] When a test produces unexpected output, instead of failing
   it, update its ``.expected`` file to match the actual output, such
   that it passes. Tests can still fail in this mode, for example if
   creation of a test database to query does not succeed.

.. option:: --consistency-queries=<dir>

   [Advanced] A directory with consistency queries that will be run for
   each test database. These queries should not produce any output
   (except when they find a problem) unless the test directory includes a
   ``CONSISTENCY`` subdirectory with a ``.expected`` file. This is mostly
   useful for testing extractors.

.. option:: --[no-]check-databases

   [Advanced] Run :doc:`codeql dataset check <dataset-check>` over each
   test database created and report a failure if it detects
   inconsistencies. This is useful when testing extractors. If the check
   is (temporarily!) expected to fail for a particular database, place a
   ``DB-CHECK.expected`` file in the test directory.

.. option:: --[no-]show-extractor-output

   [Advanced] Show the output from extractor scripts that create test
   databases. This is mostly useful for debugging extractor failures.
   Beware that it can cause duplicated or malformed output if you use
   this with multiple threads!

.. option:: -M, --ram=<MB>

   Set total amount of RAM the test runner should be allowed to use.

.. option:: --slice=<N/M>

   [Advanced] Divide the test cases into *M* roughly equal-sized slices
   and process only the *N*\ th of them. This can be used for manual
   parallelization of the testing process.

.. option:: --[no-]strict-test-discovery

   [Advanced] Only use queries that can be strongly identified as tests.
   This mode tries to distinguish between ``.ql`` files that define unit
   tests and ``.ql`` files that are meant to be useful queries. This
   option is used by tools, such as IDEs, that need to identify all unit
   tests in a directory tree without depending on previous knowledge of
   how the files in it are arranged.

   Within a QL pack whose ``qlpack.yml`` declares a ``tests`` directory,
   all ``.ql`` files in that directory are considered tests, and ``.ql``
   files outside it are ignored. In a QL pack that doesn't declare a
   ``tests`` directory, a ``.ql`` file is identified as a test only if it
   has a corresponding ``.expected`` file.

   For consistency, ``.qlref`` files are limited by the same rules as
   ``.ql`` files even though a ``.qlref`` file cannot really be a
   non-test.

Options to find libraries and extractors used by the tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Options that control the evaluation of test queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. option:: --[no-]tuple-counting

   [Advanced] Include tuple counts for each evaluation step in the query
   evaluator logs. (This can be useful for performance optimization of
   complex QL code).

.. option:: --timeout=<seconds>

   [Advanced] Set the timeout length for query evaluation, in seconds.

   The timeout feature is intended to catch cases where a complex query
   would take "forever" to evaluate. It is not an effective way to limit
   the total amount of time the query evaluation can take. The evaluation
   will be allowed to continue as long as each separately timed part of
   the computation completes within the timeout. Currently these
   separately timed parts are "RA stages" of the optimized query, but
   that might change in the future.

   If no timeout is specified, or is given as 0, no timeout will be set
   (except for :doc:`codeql test run <test-run>` where the default
   timeout is 5 minutes).

.. option:: -j, --threads=<num>

   Use this many threads to evaluate queries.

   Defaults to 1. You can pass 0 to use one thread per core on the
   machine, or -\ *N* to leave *N* cores unused (except still use at
   least one thread).

Options for checking imported TRAP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

