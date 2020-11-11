.. code-block:: yaml

   name: my-query-tests
   version: 0.0.0
   libraryPathDependencies: my-custom-queries
   extractor: java
   tests: .

This ``qlpack.yml`` file states that ``my-query-tests`` depends on
``my-custom-queries``. It also declares that the CLI should use the
Java ``extractor`` when creating test databases.
Supported from CLI 2.1.0 onward, the ``tests: .`` line declares 
that all ``.ql`` files in the pack should be
run as tests when ``codeql test run`` is run with the 
``--strict-test-discovery`` option.
