test accept
===========

.. BEWARE THIS IS A GENERATED FILE
   com.semmle.codeql.doc.Codeql2Rst --detail=ADVANCED --output=documentation/restructuredtext/codeql/codeql-cli/commands

Synopsis
--------

::

  codeql test accept <options>... [--] <test|dir>...

Description
-----------

Accept results of failing unit tests.

This is a convenience command that renames the ``.actual`` files left by
:doc:`codeql test run <test-run>` for failing tests into ``.expected``,
such that future runs on the tests that give the same output will be
considered to pass. What it does can also be achieved by ordinary file
manipulation, but you may find its syntax more useful for this special
case.

The command-line arguments specify one or more *tests* -- that is,
``.ql(ref)`` files -- and the command automatically derives the names of
the ``.actual`` files from them. Any test that doesn't have an
``.actual`` file will be silently ignored, which makes it easy to accept
just the results of *failing* tests from a previous run.

Options
-------

.. program:: codeql test accept

.. option:: <test|dir>...

   Each argument is one of:

   * A ``.ql`` or ``.qlref`` file that defines a test to run.

   * A directory which will be searched recursively for tests to run.

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

