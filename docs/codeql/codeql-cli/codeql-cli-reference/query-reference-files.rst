.. _query-reference-files:

Query reference files
=====================

A query reference file is text file that defines the location of one query to test.

You use a query reference file when you want to tell the ``test run`` subcommand
to run a query that's not part of a test directory.
There are two ways to specify queries that you want to run as tests:

#. Use a query reference file to specify the location of a query to test.
   This is useful when you create tests for alert and path queries that 
   are intended to identify problems in real codebases. You might create 
   several directories of test code, each focusing on different
   aspects of the query. Then you would add a query reference file to 
   each directory of test code, to specify the query to test.
#. Add the query directly to a directory of tests.
   These is typically useful when you're writing queries explicitly to test the behavior
   of QL libraries. Often these queries contain just a few calls to library predicates,
   wrapping them in a ``select`` statement so their output can be tested.

Defining a query reference file
-------------------------------

Each query reference file, ``.qlref``, contains a single line that defines
where to find one query. The location must be defined relative
to the root of the QL pack that contains the query. 
Usually, this is a QL pack specified by the ``libraryPathDependencies`` for the test pack.

You should use forward slashes in the path on all operating
systems to ensure compatibility between systems. 

Example
^^^^^^^^

A query reference file to test a JavaScript alert query:
`DeadAngularJSEventListener.qlref <https://github.com/github/codeql/blob/main/javascript/ql/test/query-tests/AngularJS/DeadAngularJSEventListener/DeadAngularJSEventListener.qlref>`__

The `QL pack <https://github.com/github/codeql/blob/main/javascript/ql/test/qlpack.yml>`__ 
for the ``javascript/ql/test`` directory defines the ``codeql-javascript`` queries as
a dependency. So the query reference file defines the location of the query relative
to the ``codeql-javascript`` QL pack::

    AngularJS/DeadAngularJSEventListener.ql

For another example, see `Testing custom queries <../using-the-codeql-cli/test-queries.html#example>`__.
